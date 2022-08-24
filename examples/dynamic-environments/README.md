
All pieces of the infrastructure are described with the Infrastructure as Code approach. We use `AWS CloudFormation` stacks for infrastructure deployment.

AWS CloudFormation:
* [Modules](modules/README.md)
* [Environments](environments/README.md)
* [Helpers](helpers/README.md)

Infrastructure:
* [How to deploy Route53 AWS CloudFormation stacks](docs/How%20to%20deploy%20Route53%20AWS%20CloudFormation%20stacks.md)
* [How to deploy shared AWS CloudFormation stacks](docs/How%20to%20deploy%20shared%20AWS%20CloudFormation%20stacks.md)
* [How to deploy dedicated AWS CloudFormation stacks](docs/How%20to%20deploy%20dedicated%20AWS%20CloudFormation%20stacks.md)

Worth to mention:
1. You must deploy at least one `public hosted zone`. It is needed for wildcard certificate enrollment and creating the records for ALB.
2. You can create a `private hosted zone` only after `shared` infrastructure deployment, as it needs the VPC.
3. If you have a 3rd-party DNS registrar, after  `public hosted zone`, you may need to delegate this zone to the AWS. Create the hosted zone, grab the NS servers from the Route53 console, and then create an appropriate DNS record for zone delegation in the 3rd-party DNS service.
4. You can create as many `dedicated` environments as you want. `EnvironmentName` parameter must be unique within your account.
5. In the future, a `shared` environment stack can be combined with a `dedicated` environment stack to create a self-sufficient `dedicated` environment stack (which will be much more expensive).

