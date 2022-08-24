# How to deploy dedicated AWS CloudFormation stacks
[Back to the menu](../README.md)

After all the `shared` infrastructure setup, we are ready to create a `dedicated` development environment, for example, `develop`, `research`, etc.

To do that, log in to the AWS console and navigate to the `CloudFormation`:

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/488639F8-6C4E-49E7-9844-B4E7DDC1F4AF%20Large%20Large.jpeg)

On the left-hand side, open `Stacks`, then press `Create Stack > With new resources (standard)`:

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/AEDF1D52-1FFB-4A85-BEDA-EFDDE0FEB849%20Large.jpeg)

Select `Template is Ready`, then select `Upload a template file`, press `Choose file`, select the appropriate file, and press `Next`:

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/52CAE1AA-E7FA-4A01-AEB5-9F1789D01548%20Large.jpeg)

As all the `CloudFormation` modules and stacks are located in the ` dynamic-environments` folder, we need to go to this folder and select the following file: ` dynamic-environments/environments/dedicated/dedicated-ec2-asg.yaml`

You also can check the stack file in the GitHub repo: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/environments/dedicated/dedicated-ec2-asg.yaml)

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/026F5A9C-9898-4A89-B964-C9D2C16F1F0D%20Large.jpeg)

- - - -
NOTE

For deployment of standalone EC2 instances, use the `dedicated-ec2.yaml` stack (it is pretty similar but does not create an Auto-Scaling Group and Target Group and does not need an ALB).

You also can check the stack file in the GitHub repo: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/environments/dedicated/dedicated-ec2.yaml)

For example, if you want to deploy a single-node bastion host (a VPN server).

Example of the Bastion Host can be found here: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/environments/shared/shared-bastion.yaml)
- - - -

Then, you need to set the `Stack name` parameter.

If you plan to create different `dedicated` environments, use names that can help you differentiate similar infrastructure in the `CloudFormation` portal.


The second vital parameter is `EnvironmentName`.

This parameter will be used in Application Load Balancer rules.

For example, if you have created a Route53 hosted zone with the name `apps.test001.io`, then during this stack deployment, `CloudFormation` will make the rules on an ALB listener that will respond on the `research.apps.test001.io` hostname.

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/9CEDD6FC-3764-4CCB-B3B7-EEC1E648E69A%20Large.jpeg)

Remember, we set the stack names when we were deploying the Route53 stack here: [How to deploy Route53 AWS CloudFormation stacks](docs/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks.md) and the shared infrastructure here: [How to deploy shared AWS CloudFormation stacks](docs/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks.md)?

Don’t forget to change the default value of the `SharedStackName` and  `Route53StackName` parameters and set the valid Route53 stack name.

It is needed because `Shared` and `Route53` stacks export their outputs so they are available for other stacks and can automate filling almost all required parameters.

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/FDB3C130-7FAB-4BF7-A9B3-9EBFDD16491B%20Large.jpeg)

`ALBListenerRulePriority` parameter must be unique across all dedicated environments served by a single ALB.

A suitable `InstanceType` that can handle the load of all the apps is `t3.large`.

The most convenient `InstanceStorageSize` is more than 20GB (30GB prefferably).

`SSHKey` must already exist before deploying the `dedicated` environment.

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/86F6616B-5F55-4716-A66E-1653994137A8%20Large.jpeg)

Press `Next` and set other `CloudFormation` parameters as needed. On the last screen, check all the checkmarks and press `Create stack`:

![](images/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks/9BB9EA7D-27AD-4162-874D-16A6F1E15EC6%20Large.jpeg)


The stack will deploy the following resources:
* EC2 Instance inside the Auto-Scaling Group and all related resources (all the details you can find in the CloudFormation EC2-ASG module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/ec2-asg/fragments/ec2.yaml))
	* AWS Secrets Manager secret for RDS MySQL dedicated environment user without rotation configuration
	* EC2 Instance Profile + EC2 Instance Role + EC2 Instance Role Policies (permissions to Parameter Store, Secrets Manager, S3, ECR, )
	* EC2 Launch Template + User Data
		* The script in the User Data installs all necessary software, deploys a placeholder container for health checks, runs the Ansible playbook which created the RDS database and RDS user, and provides permissions for this user to the newly created RDS database (you can find it here: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/helpers/ansible/mysql.yaml)).
	* EC2 Security Group + necessary Ingress rules
	* Target Group + ALB rule for the dedicated environment
	* Ingress rule in the RDS and Redis security groups to allow access from the EC2 security group
* ECR repositories (all the details you can find in the CloudFormation ECR module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/ecr/fragments/ecr.yaml))
	* ECR repo for the backend for PHP FPM app + lifecycle policy
	* ECR repo for the backend PHP Nginx app + lifecycle policy
	* ECR repo for the frontend app + lifecycle policy

