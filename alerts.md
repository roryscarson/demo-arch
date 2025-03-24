1. **S3 bucket becomes public**  
Why: These buckets are designed to be private and this alert will notify us of sensitive data exposure.  
Trigger: `PutBucketAcl` or`PutBucketPolicy` events are called with a change in policy that contains `Principal: *`  

2. **S3 bucket encryption disabled/removed**  
Why: Disabling encryption enables an attacker to read the data when exfiltrated. It is also likely a compliance violation to not store data at rest.  
Trigger: `PutBucketEncryption` or `DeleteBucketEncryption` is called  

3. **S3 bucket policy modifed**  
Why: While not generally harmful on their own and an expected part of development, modifying the bucket policy of these secure buckets can introduce unintended access and should be quickly reviewed.  
Trigger: `PutBucketPolicy` or `DeleteBucketPolicy` is called on the `demo-arch-bucket` and the `demo-arch-logs-bucket`