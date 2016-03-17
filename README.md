# audit-aws-instances
Audits AWS instances for unused reserved instances, or instances without corresponding reserved instances

Requires that AWS EC2 tools exist and are configured.  http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html

## Configuration
Install and configure the AWS CLI and give the IAM user the necessary permissions to check reservations.  This script happens to source AWS API info from ~/.profile, but just make sure "aws cli" runs without errors, and the script should work.  The "used_types" list should be modified to reflect only the instance types you care about.

## Sample output
```
~# audit-aws-instances
OK - m3.medium
OK - m3.large
UNUSED RESERVATION: (1) - m3.large
UNUSED RESERVATION: (2) - m3.xlarge
OK - m3.2xlarge
OK - r3.large
OK - r3.xlarge
OK - r3.2xlarge
OK - r3.4xlarge
OK - r3.8xlarge
```
