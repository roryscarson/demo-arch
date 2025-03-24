import boto3
import os
import json
import subprocess

TAG_FILTER = {"Key": "HasSecurityAgent", "Value": "FALSE"}
SECRET_NAME = "security-agent-secrets"
SSH_KEY="~/.ssh/install_key.pem"

ec2 = boto3.client('ec2', region_name=os.environ["AWS_DEFAULT_REGION"])
secretsmanager = boto3.client('secretsmanager', region_name=os.environ["AWS_DEFAULT_REGION"])

def get_ec2_instances():
    #assumption is tagging policy in place and set of standard tags exist
    filters = [{"Name": f"tag:{TAG_FILTER['Key']}", "Values": [TAG_FILTER["Value"]]}]
    reservations = ec2.describe_instances(Filters=filters)["Reservations"]
    instances = []
    for r in reservations:
        for i in r["Instances"]:
            if i["State"]["Name"] == "running":
                instances.append(i["PublicIpAddress"])
    return instances

def get_agent_secret():
    response = secretsmanager.get_secret_value(SecretId=SECRET_NAME)
    return json.loads(response["SecretString"])

def write_inventory(hosts):
    with open("inventory.ini", "w") as f:
        f.write("[ec2_instances]\n")
        for ip in hosts:
            f.write(f"{ip} ansible_user=ec2-user ansible_ssh_private_key_file={SSH_KEY}\n")

def run_ansible():
    subprocess.run(["ansible-playbook", "-i", "inventory.ini", "deploy_agent.yml"])

if __name__ == "__main__":
    hosts = get_ec2_instances()
    if not hosts:
        print("No hosts found.")
        exit()

    secret = get_agent_secret()
    write_inventory(hosts)

    # Write agent URL/token to vars file
    with open("vars.yml", "w") as f:
        f.write(f"agent_download_url: {secret['agent_download_url']}\n")
        f.write(f"agent_install_token: {secret['agent_install_token']}\n")

#    run_ansible()
