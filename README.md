**Suggested Architecture**  
![demo-arch](images/demo-arch.png)

**Prerequisites**  
1. Access to AWS account and CLI (via IAM user access key or OIDC setup)
2. Terraform and Python installed
3. `direnv` installed and configured 

**How to Build and Deploy**  
Terraform:  
* Navigate to /terraform directory
* `terraform apply` locally  
Note that this will not work out of the box. You need to modify the backend to use an existing bucket in your own infrastructure, or switch it to use local state instead. Also bucket names are globally unique and would need to be changed in `bucket.tf`

Terraform Future  
* (1.0)Setup ruleset enforcement on `main`
* (1.1)Setup `dev` PR to `main` to autoapply Terraform

Agent-Script:  
* Navigate to /deploy-agents directory  
* `python3 -m venv .venv`
* `source .venv/bin/activate`
* `python3 get-instances-to-update.py`  
Note that this will return no results unless you happen to have a bunch of EC2 instances in your account with the following tag `{"Key": "HasSecurityAgent", "Value": "FALSE"}`. The script uses Ansible but the run command that would deploy the agent is commented out(since there are no actual instances setup)


**Alerting**  
Check alerts.md for more detail
1. S3 bucket becomes public
2. S3 bucket encryption disabled/removed
3. S3 bucket policy modifed

**Issues**
1. IP Range allocation in given arch diagram is impossible. AWS only allows VPCs a maximum `/16` which maps to `10.0.0.0 - 10.0.255.255`. There's no way for the private subnet to have the requested IP range and still be within the same VPC. 
2. RDS should have read replicas setup in different AZs
3. RDS Auth should not use user/pass, setup IAM DB Auth instead. In general user/pass should never be used within AWS and all services should be moving to role based short lived token auth. 


**TODO Requirements**  
0.3 Add backend DB  
0.4 Setup ECR  
0.5 Deploy simple app  
1.0 Refactor architecture with security recommendations

**TODO Improvements**  
1.1 Add tf apply GH action on merge to main  
1.2 Add precommit hook secret scanner