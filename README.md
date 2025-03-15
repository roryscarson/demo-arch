**Prerequisites**  
1. Access to AWS account and CLI (via IAM user access key or OIDC setup)
2. Terraform installed
3. `direnv` installed and configured 

**How to Build and Deploy**  
Current:
* `terraform apply` locally  

**Future**
* (1.1)Merge PR to `main` 


**Issues**
1. IP Range allocation in arch diagram is impossible. AWS only allows VPCs a maximum `/16` which maps to `10.0.0.0 - 10.0.255.255`. There's no way to have the private subnet have the requested IP range and still be within the same VPC. 


**TODO Requirements**  
0.1 Setup SGs  
0.2 Add ALB  
0.3 Add backend DB  
0.4 Setup ECR  
0.5 Deploy simple app  

**TODO Improvements**  
1.1 Add tf apply GH action on merge to main  
1.2 Add precommit hook secret scanner