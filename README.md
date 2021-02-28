# aws-sysops-notes
[deployment_and_provisioning](#deployment_and_provisioning)  
[CloudFormation](#cloud-formation)


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

updating stacks
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

