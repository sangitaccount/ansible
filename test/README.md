Run the ansible playbook using #ansible-playbook playbook.yml.

The script asks for AWS_ACCESS_KEY and AWS_SECRET_ACCESS.

Update group_vars/all.yml for VPC, Subnet, AMI, SSH and rest of the values.

Check the roles/ec2-instance/files/user_data.sh for rest of the tasks. 
