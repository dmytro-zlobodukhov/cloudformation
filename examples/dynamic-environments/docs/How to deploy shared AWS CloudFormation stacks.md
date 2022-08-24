# How to deploy shared AWS CloudFormation stacks
[Back to the menu](../README.md)

As decided per project requirements, VPC, Load Balancer, and all different database instances will be shared. All different environments will use the same shared infrastructure but their databases.

Before we can create a dedicated development instance, for example, `develop`, `research`, etc., we need to spin up shared infrastructure first.


To do that, log in to the AWS console and navigate to the `CloudFormation`:

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/488639F8-6C4E-49E7-9844-B4E7DDC1F4AF%20Large.jpeg)

On the left-hand side, open `Stacks`, then press `Create Stack > With new resources (standard)`:

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/AEDF1D52-1FFB-4A85-BEDA-EFDDE0FEB849%20Large.jpeg)

Select `Template is Ready`, then select `Upload a template file`, press `Choose file`, select the appropriate file, and press `Next`:

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/52CAE1AA-E7FA-4A01-AEB5-9F1789D01548%20Large.jpeg)

As all the `CloudFormation` modules and stacks are located in the `dynamic-environments` folder, we need to go to this folder and select the following file: ` dynamic-environments/environments/shared/shared.yaml`

You also can check the stack file in the GitHub repo: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/environments/shared/shared.yaml)

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/32042F5B-9B24-4958-945C-DFF98EE918B9%20Large.jpeg)

Then, you need to set the `Stack name` parameter.

If you plan to create different `shared` environments, use names that can help you differentiate similar infrastructure in the `CloudFormation` portal.


The second vital parameter is `Route53StackName`.

Remember, we set the stack name when we were deploying the Route53 stack here: [How to deploy Route53 AWS CloudFormation stacks](./How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks.md)?

Don’t forget to change the default value of the `Route53StackName` parameter and set the valid Route53 stack name.

It is needed because the `Route53` stack exports its outputs so they are available for other stacks and can automate filling almost all needed parameters.

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/579FD392-8CEB-4BC9-BAA0-215E82E30C32%20Large.jpeg)

The rest of the parameters have default values.

All the services that will be deployed using the shared infrastructure stack are divided into groups:
* General
* Availability Configuration
* VPC Configuration
* RDS Configuration
* ALB Configuration

Carefully go through all the parameters and configure them as you need.
![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/0D072ED5-A11C-4DEF-BAB1-E0046334E34F%20Large.jpeg)

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/68B8BC36-784D-4D9E-857F-6A9F48B98981%20Large.jpeg)

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/0DBBF16C-5179-4774-B801-DF56BF1C6A7C%20Large.jpeg)

Press `Next` and set other `CloudFormation` parameters as needed. On the last screen, check all the checkmarks and press `Create stack`:

![](images/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks/9BB9EA7D-27AD-4162-874D-16A6F1E15EC6%20Large.jpeg)


Let’s say you set all the parameters and selected two availability zones.

The stack will deploy the following resources:
* AWS VPC Network with specified CIDR and networking-related resources (all the details you can find in the CloudFormation VPC module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/vpc/fragments/vpc.yaml))
	* Two public subnets + Public routing table + Routing table association with Public subnets
	* Two private subnets + Private routing table + Routing table association with private subnets
	* One Internet gateway + gateway attachment
	* Two NAT gateways + ElasticIP for each NAT gateway
	* Two private subnets for databases + routing table + routing table association with database subnets
* RDS Database instance for MySQL + all related resources (all the details you can find in the CloudFormation RDS module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/rds/fragments/rds.yaml))
	* AWS Secrets Manager secret for RDS MySQL admin user without rotation configuration
	* RDS Parameter Group
	* RDS Subnet Group + RDS Security Group
	* Two days snapshot retention
* Elasticache instance for Redis + all related resources (all the details you can find in the CloudFormation Redis module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/redis/fragments/redis.yaml))
	* Redis Parameter Group
	* Redis Subnet Group + Redis Security Group
	* Two days snapshot retention
* Application Load Balancer + all related resources (all the details you can find in the CloudFormation ALB module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/alb/fragments/alb.yaml))
	* HTTP Listener with redirection to HTTPS + HTTPS Listener with attached ACM Certificate and fixed-response rule
	* ALB Security Group + Ingress rules
	* Wildcard Alias record in Route53

