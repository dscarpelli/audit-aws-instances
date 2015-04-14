# audit-aws-instances
Audits AWS instances for unused reserved instances, or instances without corresponding reserved instances

Requires that AWS EC2 tools exist and are configured.  http://docs.aws.amazon.com/AWSEC2/latest/CommandLineReference/set-up-ec2-cli-linux.html

Sample output:
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
