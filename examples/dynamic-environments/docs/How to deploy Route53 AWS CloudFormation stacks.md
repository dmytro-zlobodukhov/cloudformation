# How to deploy Route53 AWS CloudFormation stacks
[Back to the menu](../README.md)

Before creating `shared` and `dedicated` environments, we need to create a Route53 Hosted Zone.

It is needed for two reasons:
* `Route53`  stack will create a `wildcard` certificate for the specified domain name
* This certificate is required for the ALB deployment when the stack will create an HTTPS Listener (ACM Certificate is required for HTTPS Listener)

To do that, log in to the AWS console and navigate to the `CloudFormation`:

![](images/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks/488639F8-6C4E-49E7-9844-B4E7DDC1F4AF%20Large.jpeg)

On the left-hand side, open `Stacks`, then press `Create Stack > With new resources (standard)`:

![](images/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks/AEDF1D52-1FFB-4A85-BEDA-EFDDE0FEB849%20Large.jpeg)

Select `Template is Ready`, then select `Upload a template file`, press `Choose file`, select the appropriate file, and press `Next`:

![](images/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks/52CAE1AA-E7FA-4A01-AEB5-9F1789D01548%20Large.jpeg)

As all the `CloudFormation` modules and stacks are located in the `dynamic-environments` folder, we need to go to this folder and select the following file: ` dynamic-environments/environments/shared/shared-route53.yaml`

You also can check the stack file in the GitHub repo: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/environments/shared/shared-route53.yaml)

![](images/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks/B4F6D343-2A2A-438E-9472-2288D30B8F10%20Large.jpeg)

Then, you need to set the `Stack name` parameter.

You will need to deploy at least one `public` hosted zone. Then, you can create as many hosted zones as you want.


The second vital parameter is `DomainName`.

This parameter will be used as a Hosted Zone name. If you plan to create more than one hosted zone, Domain Names must be unique within the account.

![](images/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks/F75F4421-2506-47F4-840B-7D2AD47F367B%20Large.jpeg)

This stack can deploy both `public` and `private` Route53 Hosted Zone.

If you want to deploy an additional `private` zone, use the same stack, set the `HostedZoneType` to `private`, and don’t forget to set the `VpcId` .

- - - -
NOTE

You can deploy the private hosted zone only when you have a VPC.
- - - -

![](images/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks/0E94CFBC-3B92-417D-8C3D-7C9867872987%20Large.jpeg)

Press `Next` and set other `CloudFormation` parameters as needed. On the last screen, check all the checkmarks and press `Create stack`:

![](images/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks/9BB9EA7D-27AD-4162-874D-16A6F1E15EC6%20Large.jpeg)


The stack will deploy the following resources:
* `Route53 Public` Hosted Zone (all the details you can find in the CloudFormation Route53 module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/route53/fragments/route53.yaml))
	* Public Hosted zone
	* Wildcard ACM Certificate for the specified domain name
* If selected/needed, `Route53 Private` Hosted Zone (all the details you can find in the CloudFormation Route53 module: [Link](https://github.com/dmytro-zlobodukhov/cloudformation/blob/main/dynamic-environments/modules/route53/fragments/route53.yaml))
	* Private Hosted zone associated with the VPC (VPC must be in place)

