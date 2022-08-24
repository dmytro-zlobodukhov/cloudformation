[Back to the menu](../README.md)

All the modules in the directory are just small chunks (separate AWS services).
They are combined into stacks. You can find all stacks templates [here](https://github.com/dmytro-zlobodukhov/cloudformation/tree/main/examples/dynamic-environments/environments).

---

### What the module is?
AWS CloudFormation Modules are building blocks that can be reused across multiple CloudFormation templates and is used just like a native CloudFormation resource.

More info about modules can be found in [this](https://aws.amazon.com/blogs/mt/introducing-aws-cloudformation-modules/) article.

CloudFormation modules are available in the CloudFormation registry, so you can use them just like a native resource. A module with a resource type is postfixed in the CloudFormation registry with `::MODULE` so it’s easy to denote when you are using a module or a native registry resource. Parameters that are defined in the CloudFormation module become properties when consuming the `::MODULE` resource type. When you use a CloudFormation module, the module template is expanded into the consuming template, which makes it possible for you to access the resources inside the module using a `Ref` or `Fn::GetAtt`.

### How to initiate a module?
Create the folder where you want to store the module and `cd` into it.
To initiate the folder as module, run the following command `cfn init` and provile the necessar info, for example:
```
mkdir ec2-asg-test && cd ec2-asg-test
cfn init
Initializing new project
Do you want to develop a new resource(r) or a module(m) or a hook(h)?.
>> m
What's the name of your module type?
(<Organization>::<Service>::<Name>::MODULE)
>> Test001::EC2::Bastion::MODULE
Directory  /Users/some_user/cfn_test/ec2-asg-test/fragments  Created
Initialized a new project in /Users/some_user/cfn_test/ec2-asg-test
```
This command will create all necessary files for publishing.
By default, `cfn init` command will create a `sample.json` file in `fragments` folder.
You can delete this file and create `*.yaml` file instead. This will be the main file for your new template.

### How to publish module?
You can publish the module using the following command (I use multiple AWS CLI profiles for multiple regions, thus I use env variable to set the correct profile name):
```
AWS_PROFILE=test001 cfn submit --region us-west-2 --set-default -v
```

When you changing the module, you will need to upload the new version to the AWS module registry. Just use the same command above.

### How to find registered modules?
You can find all the published modules in `AWS Console > Cloud Formation > Activated extensions > Modules`

### How to de-register module?
If you want to de-register module, you can use the following command:
```
aws cloudformation deregister-type --type-name "<Organization>::<Service>::<Name>::MODULE" --type MODULE --profile <aws_cli_profile_name> --region <aws_region>
```
---

## Module usage
| module name | stack name | comments |
|---|---|---|
| alb | shared/shared.yaml | Used to deploy `shared` infrastructure |
| ec2 | dedicated/dedicated-ec2.yaml | not used |
| ec2-asg | dedicated/dedicated-ec2-asg.yaml | Used to deploy `dedicated` infrastructure |
| ec2-bastion | shared/shared-bastion.yaml | Used to deploy `bastion` host |
| ecr | dedicated/dedicated-ec2-asg.yaml | Used to deploy `dedicated` infrastructure |
| ecs-ec2 | shared-ecs-cluster.yaml | not used |
| ecs-service | not used | not used |
| rds | shared/shared.yaml | Used to deploy `shared` infrastructure |
| redis | shared/shared.yaml | Used to deploy `shared` infrastructure |
| route53 | shared/shared-route53.yaml | Used to deploy `shared` infrastructure |
| vpc | shared/shared.yaml | Used to deploy `shared` infrastructure |

More info [HERE](../README.md)