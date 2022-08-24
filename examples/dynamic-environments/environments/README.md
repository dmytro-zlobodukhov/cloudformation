[Back to the menu](../README.md)

Here you can find stacks that are using to build the infrastructure.

They are divided into two folders:

| name | description |
|---|---|
| shared | A couple of stacks that deploys a shared infrastructure (Route53, VPC, ALB, RDS, Redis, Bastion host) |
| dedicated | Stacks, that are used to set up dedicated development environment, such as `develop` or `research` Can be EC2 or ASG + EC2. |

How to deploy infrastructure (in order):
| order # | service name | template name | comments |
|---|---|---|---|
| 1 | Route53 | shared/shared-route53.yaml | Deploys `public` or `private` hosted zone |
| 2 | VPC + RDS + Redis + ALB | shared/shared.yaml | Deploys `shared` infrastructure |
| 3 | Bastion host | shared/shared-bastion.yaml | Deploys EC2 instance and deploys Pritunl VPN |
| 4 | ASG + EC2 | dedicated/dedicated-ec2-asg.yaml | Deploys dedicated infrastructure for specified environment |

More info you can find here:
