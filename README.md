# audit-aws-instances
Audits AWS instances for unused reserved instances, or instances without corresponding reserved instances.  Designed for use as a sensu/nagios plugin, so no output is good.  Returns exit code 1 (warn) if there are any outstanding RIs or unreserved instance.  Returns exit code 2 (crit) if there are >$crit outstanding for any instance type.

## Configuration
Install and configure the AWS CLI and give the IAM user the necessary permissions to check reservations.

http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html

This script happens to source AWS API info from ~/.profile, but just make sure "aws cli" runs without errors, and the script should work.  The "used_types" list can be modified to reflect only the instance types you care about.

## Sample output
```
UNRESERVED INSTANCES: (4) - m3.large
UNRESERVED INSTANCES: (2) - m3.xlarge
UNUSED RESERVATION: (1) - m3.2xlarge
UNUSED RESERVATION: (1) - m4.large
UNUSED RESERVATION: (1) - r3.large
UNRESERVED INSTANCES: (1) - r3.2xlarge
```
