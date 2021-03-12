# aws-sysops-notes
[deployment_and_provisioning](#deployment_and_provisioning)  
[CloudFormation](#cloud-formation)  
[route-53](#route-53)  
[as_group](#ASG)  
[ec_2](#EC2)  
[ia_m](#IAM)  
[aws_lambda](#Lambda)  
[aws_batch](#Batch)


<a name="deployment_and_provisioning">Deployment and Provisioning</a>
==

Api gateway
Codebuild 

Dynamic page on s3 – lambda + dynamodb (nosql)
Api gateway – managed service. Front door to access data,logic from backend. Processes api calls for your app, RESTful api. Lambda or ec2, dynamodb. Pay as you go. http api or restapi

SQS – mq. Standard (no ordering) and fifo queue (user commands in order)

Alb – cloudwatch for user requests. Data points stats. Access logs disabled by default. Cloudtrail not good for client request

Ec2 subnet/vpc cannot change. To move, only ami and recreate

Ami cross region -copy 

Ec2 region quota – open support

Change volume type to io1 without downtime

Auto scaling launch configuration – create ami at CF stack creation.
Bootstrap with software download will take time
Cf metadata to indicate software – not supported. Dynamic creation images

Ami can be copied to another region

Options to bootstrap
https://aws.amazon.com/blogs/infrastructure-and-automation/enable-fast-bootstrapping-of-your-auto-scaled-instances-using-dynamically-created-images/

1)	Custom ami. Pre-baked can be not up to date
2)	Base ami + download pkg
3)	Quick start
a.	Start ec2 with user-data and cfn-init config set
b.	Lambda that creates ami from ec2 (with boto3)
c.	CF custom resource that invokes lambda
d.	Take new build ami
e.	Lambda function to deregister ami



<a name="cloud-formation">CloudFormation</a>
==

integrates with ci/cd pipeline. Aws codepipeline


topics:
- templates - json/yaml
	- "Type" : "AWS::EC2::Instance", or "AWS::EC2::EIP", and "InstanceId" : {"Ref": "MyEC2Instance"}
	- input parameters - asked when launched
	- mappings in template - ex AMI ID/region
	- functions like join text
	- template macros - custom processing on templates (replace or transform)
		- lambda function toprocess
		- resource CF macro - enable users to call lambda from CF template
		- endpoint to skip public internet
	- conditions to select size based on environment
	- CF error - rollback in progress status
- stacks - collection of resources
- change sets 
	- changes to running resource in a stack 
	- updating stack creates change set (summary of changes)
	- shows what will be deleted

blue/green deployment:
- use codedeploy
- new env green, current env blue - both in template
- transform section AWS::CodeDeployBlueGreen and Hook section AWS::CodeDeploy::BlueGreen
- create change set to review changes

stackset:
- crud a stack on multiple accounts with single operation

IAM user needs permission to create EC2 to use CF.
Save template to s3. if locally, aws still will upload it, then default s3 permissions on bucket
template can contain input parameters
update stack - modify s3 - CF generate change set 

updating stacks:
- no interruption - no id change
- update with interruption
- replace - new physical id 
- direct modification - won't replace resource 
- input parameter. 2 changes - static and dynamic
- prevent changes - stack policy. by default all protected, add allow. one policy. applies during stack updates
- stack status: failed (cannot update) or completed
- drift - manual changes. CF detect drift . some resources dont' have drift 
- drift detect on private resource that are provisionale = provision type fully_mutable or immutable
- drift fix retains resource, not deletes
- output section, export field vs nested stack


import resources:
- resource import (not all)
- identifier property (aws::s3::bucket) and value (bucket name)
- must have deletionpolicy

move resource between stacks
- refactor stacks. 
- retain detection policy


tools: AWS CloudFormation Designer (GUI but properties manually)

artifact – file between stages in pipeline/s output of build process to consume by another job. Available after run
CD – code changes are automatically BUILT. Update repository and bam
1.	Source artifact – template and files
2.	




ELB

https://aws.amazon.com/elasticloadbalancing/features/#Product_comparisons
https://docs.aws.amazon.com/elasticloadbalancing/latest/application/load-balancer-access-logs.html

- when deleted, listerenrs also get deleted
- in region, distributes to AZ
- monitors health
- arch: 
	- listener for incoming requests (port+protocol)
	- rules for routing (priority+action+condition)
	- target group(s). target can be in multiple TG
	- HC per TG

supports:
- ALB
	- features:
		- path condition (based on url)
		- host condition (http header)
- NLB
- GLB 
- CLB


<a name="route_53">Route 53</a>
==

Features:
- onpremise and aws
- dns checks for healthy endpoints > cloudwatch alarm  > sns topic 
	- public ip address, protocol (http/s, tcp), threshold count
- traffic flow (with visual editor)
	- latency based
	- geo dns 
	- geo proximity
	- weighted rr
	- CF zone apex (= root domain), so example.com instead www.example.com
- buy DNS 

static webpage on s3 .
1. create bucket type static website hosting
2. create bucket for www and redirec requests


use route 53:
1. create hosted zone
2. record + routing policy

Route 53 routing policies:
https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/routing-policy.html
- failover
- geoloc. 
	- default record for non-mapped ips. either ip of dns resolver, or client ip (EDNS0)
	- map ip to location
	- location of users (dns queries come from)
- geoprox
	- must use traffic flow (only public zones)
	- bias to calculate closes server 
	- based on location of resources
- latency
	- create latency record everywhere
	- route 53 refers to its data about latency 
	- multiple regions
	
geoprox vs geoloc vs latency
https://tutorialsdojo.com/latency-routing-vs-geoproximity-routing-vs-geolocation-routing/


<a name="as_group">ASG</a>
==
https://aws.amazon.com/blogs/aws/new-ec2-auto-scaling-groups-with-multiple-instance-types-purchase-options/?&trk=ha_a131L000005uJTZQA2&trkCampaign=pac-edm-2019-spot-sitemerch-autoscalingblog&sc_ichannel=ha&sc_icampaign=Adoption_Campaign_pac-edm-2019-spot-site_merch-adoption-all-auto_scaling_console_test&sc_ioutcome=Enterprise_Digital_Marketing

https://aws.amazon.com/blogs/aws/new-ec2-auto-scaling-groups-with-multiple-instance-types-purchase-options/?&trk=ha_a131L000005uJTZQA2&trkCampaign=pac-edm-2019-spot-sitemerch-autoscalingblog&sc_ichannel=ha&sc_icampaign=Adoption_Campaign_pac-edm-2019-spot-site_merch-adoption-all-auto_scaling_console_test&sc_ioutcome=Enterprise_Digital_Marketing


features:
- distribution strategies
- launch configuration cannot modify after creation
- 

<a name="ec_2">EC2</a>
==

https://aws.amazon.com/premiumsupport/knowledge-center/manage-service-limits/

https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/placement-groups.html


- max instances 20 per region. Trusted advisor shows quotas


<a name="ia_m">IAM</a>
==
- trust entity
- permission boundaries - max permissions


<a name="aws_lambda">Lambda</a>
==
- schedule via cloudwatch event
-  for 3rd party libraries - create deployment package and upload to lambda/s3
- sam templates and CF
https://docs.aws.amazon.com/serverless-application-model/latest/developerguide/what-is-sam.html
- increase concurrent limit - request to AWS SC

<a name="aws_batch">Batch</a>
==
https://aws.amazon.com/blogs/compute/optimizing-for-cost-availability-and-throughput-by-selecting-your-aws-batch-allocation-strategy/

https://docs.aws.amazon.com/batch/latest/userguide/Batch_GetStarted.html

- create batch vpc and compute environment (ec2)


<a name="aws_db">Databases</a>
==
- dynamodb point in time recovery, 35 days must enable
- dynamodb 

WAF
==
- not at subnet level

VPC
==
- NACL to multiple subnets
- subnet with only one NACL
- spread placement max 7 ec2/AZ
- vpc traffic mirroring - replicate network traffic and forward it to tools.
https://aws.amazon.com/blogs/aws/new-vpc-traffic-mirroring/

Config
==
- aggregator - multiple accounts and regions. no need to manually create in each region
https://docs.aws.amazon.com/config/latest/developerguide/setup-aggregator-console.html
- logs changes to config, and retraces steps via cloudtrail 
https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/TrackingChanges.html
- inventory of resources and alerts on config changes. but no api calls 

Systems Manaager
==
- max 1000 onprem in single account and region

S3
==
https://aws.amazon.com/premiumsupport/knowledge-center/s3-bucket-owner-access/
- access login for bucket, more effective that cloudtrail
- block public access 
https://docs.aws.amazon.com/AmazonS3/latest/user-guide/block-public-access.html
- doesn't provide posix

EBS
==
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/ebs-initialize.html
- data consistency  - ebs disables io on volume, so volume status is fail. Switch to auto-enable io or enable volume io
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/monitoring-volume-status.html#work_volumes_impaired

Instance store
==
https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/InstanceStorage.html
- for temporary stuff


cloud watch log insights
==
- analyze data
https://docs.aws.amazon.com/AmazonCloudWatch/latest/logs/AnalyzingLogData.html

Athena
==
- analyzes only s3

Kinesis
==
real-time processing of logs 

Firehose
==
- 1 minute lag

AWS artifact 
==
- pci attest
- https://docs.aws.amazon.com/en_pv/artifact/latest/ug/getting-started.html

KMS
==
- customer managed key - import your own key to encrypt ebs 
https://docs.aws.amazon.com/kms/latest/developerguide/importing-keys.html


ALB
==
- first detach instances, then disable ALB


OpsWorks
==
- cfg mgmt - provides managed chef and puppet instances

EFS
==
- posix


RDS
==
- parameter groups