+++
title = "Deploying to AWS Elastic Container Service"
weight = 8
template = "doc.html"
aliases = ["docs/using/elastic-container-service"]
+++

Urbit can be deployed as a [Docker Image](https://hub.docker.com/r/tloncorp/urbit). [Amazon Web Services](https://aws.amazon.com/) provides the Elastic Container Service, which, when combined with AWS Fargate, allows containers to be deployed without explicitly provisioning underlying EC2 instances.

## Initialize your ship

When deploying a ship in a container, it is best to boot your ship locally and then copy your pier to the cloud storage which will be volume-mounted. Container hosting providers generally do not provide console access to individual containers.

In particular, you will want to run `+code` from your dojo while running your ship locally, before copying your pier to the cloud. Save the provided code, you will use it when signing into your ship's Landscape frontend or running API calls against your ship.

## Warnings

- We recommend deploying only moons or comets via this method, unless you are absolutely sure you know    what you are doing. Mistakes in the deployment procedure can lead to data loss and/or require a breach.
- Landscape will be exposed via *insecure HTTP over the public Internet.* Thus, this guide should only be used for experimentation or as a basis for creating more secure deployments, e.g. by deploying nginx with LetsEncrypt as a reverse proxy.

## Sign into the AWS console

You will need to sign in as the root user or as an IAM user authorized to create and configure

- Security groups
- EFS File shares
- EC2 virtual machine instances
- ECS deployments

## Create security groups

AWS Security groups act both as a label for a set of network addresses, and as a firewall ruleset for those addresses. 
We will create three security groups for this deployment:

- A security group for the EC2 virtual machine which we will use to upload our pier
- A security group for the ECS service which will run our ship
- A security group for the EFS file share which will hold our ships pier and be mounted as a container volume

First, navigate to the VPC service

![An Image](1- Go To VPC.png)

Navigate to the "Security Groups" screen

![](2 - Go To Security Groups.png)

Select "Create security group"

![](3 - Click Create SG.png)

Name your security group `urbit-ecs` and ensure it is created in your default VPC.

![](4 - urbit-ecs sg.png)

We want to allow inbound HTTP connections, so that we can connect to Landscape, and inbound Ames connections, so that other Urbit ships can easily connect with ours. Make sure both ports are exposed to the CIDR `0.0.0.0/0`.

![](5 - urbit-ecs inbound rules.png)

Ensure the default rule allowing all outbound traffic is in place, then select "Create security group."

![](6 - create urbit-ecs sg.png)

The `urbit-ecs` security group is now shown in the dashboard:

![](7 - urbit-ecs created.png)

Create another security group, and name it `urbit-ec2`. Again ensure that it is created in the default VPC:

![](8 - urbit-ec2 sg.png)

Create a single inbound rule, for SSH access from CIDR `0.0.0.0/0`

![](9 - urbit-ec2 rules.png)

Create one more, called `urbit-efs`, again ensuring it is created in the default VPC.

![](10 - urbit-efs sg.png)

For the inbound rules for the `urbit-efs` security group, allow NFS traffic from
both previous security groups: `urbit-ec2` and `urbit-ecs`.

![](11 - urbit-efs rules.png)

Now that all three security groups have been created, it is time to create the EFS share that will hold our pier. Navigate to the EFS service:

![](12 - go to EFS.png)

Navigate to the "File systems" screen:

![](13 - go to filesystems.png)

Select "Create file system":

![](14 - click create file system.png)

Name your file system (we recommend the name of your ship) and ensure it is being created in the default VPC. Then select "Customize."

![](15 customize file system.png)

For each subnet in the customization pane: ensure that the `urbit-efs` security group, and no other, is selected. Then pick `Next` to create the filesystem

![](16 - set fs urbit efs sg.png)

Now we will create a temporary EC2 VM instance in order to upload our pier to our newly-created EFS share. Navigate to the EC2 service:

![](17 - go to EC2.png)

Select the "Instances" screen:

![](18 - Go to instances.png)

Select the "Launch instances" button:

![](19 - Click launch instance.png)

Find the Amazon Linux AMI, and choose "Select" for that image:

![](20 - Select Amazon Linux AMI.png)

Select the radio button for the `t2.micro` instance type, then select "Next: Configure instance details".

![](21 Click Configure Instance Details.png)

Ensure the "Auto-assign Public IP" option is set to "Enable"

![](22 - Enable Public IP.png)

In the "File systems" section, click "Add file system"

![](23 - Click Add Filesystem.png)

Select the file system created above, and note the default mount point `/mnt/efs/fs1`. This is where the EFS file system will be accessible on the EC2 instance.

Ensure the checkbox "Automatically create and attach the required security groups" is **unchecked**. We will assign a previously created security group to the instance in a later step.

![](24 - Mount EFS.png)

In the list of steps at the top, click "Configure Security group"

![](25 - Click Security Groups.png)

Make sure the radio button for "Select an existing security group" is selected,
then select only the `urbit-ec2` security group.

![](26 - Set EC2 SG.png)

Click the "Review and launch" button

![](27 - Click Review and Launch.png)

After reviewing your instance for correctness, click "Launch"

![](28 - Click Launch.png)

A modal will pop up asking you how to provision SSH keys for the instance.
Select "Create a new key pair" and use the name of your ship as the key pair name.
Click "Download key pair" and note where you save the resulting `.pem` file.

![](29 - Click Download Key Pair.png)

After downloading and saving the key, click "Launch Instances"

![](30 - Click Launch.png)

On the landing page, click the "View instances" button.

![](31 - Click View Instances.png)

Wait for your instance to achieve "Running" status. You may need to refresh.
Once your instance is "Running", select the instance, and locate the "Public IPv4 DNS"
field in the "Details" tab. Select the copy icon next to the hostname to copy it to the clipboard.

![](32 - Select and Copy instance hostname.png)

Open a terminal. Change the permissions of the downloaded key file to exclude group and other
from all actions:  
  
```bash
chmod go-rwx /path/to/my/key.pem
```

This is necessary for your SSH agent to load the key. Next, load the key into your SSH agent:

```bash
ssh-add /path/to/my/key.pem
```

If prompted for a passphrase, leave the passphrase empty and confirm.

Copy your pier to the home directory of the default EC2 user:

```bash
rsync -av /path/to/sapmel-palnet ec2-user@<pasted-hostname>:~/
```

(Note there is a trailing `/` after the home directory in the remote path, but none after the pier in the local path.) Now shell into the instance:  
```bash
ssh ec2-user@<pasted-hostname>
```

Change the ownership of the pier to root:  
  
```bash
sudo chown root:root -R sapmel-palnet
```

Move the pier to the EFS volume, at the path noted when creating the EC2 instance:

```bash
sudo mv sapmel-palent /mnt/efs/fs1
```

Check that the pier is in place

```bash
ls /mnt/efs/fs1
```

Power off the EC2 instance:

```bash
sudo poweroff
```

Exit the terminal and return to the AWS console. Ensure that the instance reaches status "Terminated". If not, terminate it manually, or you will continue to be billed for it.

![](33 - Instance Terminated.png)

Our pier is now copied onto an EFS file system. It is time to launch a container running our ship!

Navigate to the Elastic Container Service:

![](34 - Go To ECS.png)

Go to the "Task Definitions" screen:

![](35 - Go To Task Definitions.png)

Select "Create new Task Definition"

![](36 - Click Create Task Definition.png)

Ensure that you have selected to create a Fargate task, then click "Next step"

![](37 - Fargate Task.png)

Fill in your ship name for the task name:

![](38 Task Name.png)

Provision 2GB of RAM and one vCPU for the task:

![](39 Task Size.png)

Scroll down to the "Volumes" section and select "Add volume"

![](40 Add Volume.png)

Name the volume for your ship name. Select the "EFS" volume type. Select the EFS volume you created previously, and ensure you are mounting `/` as the root directory. Select "Add".

![](41 - Volume name and ID.png)

Scroll back up to the "Container Definitions" section, and select "Add container".

![](42 - Click Add Container.png)

Set the container name to be your ship name, and the image to be `tloncorp/urbit:latest`. This will cause the latest version of the docker image to be pulled from Docker Hub.

Ensure that TCP port 80 and UDP port 34343 (for Ames) are mapped in the container.

![](43 - Container basics.png)

Scroll down to the "Storage And Logging" section of the container definition.
Under "Mount points" select the volume defined earlier as the "Source volume",
and set the "Container path" to "/urbit". When the container is started, the EFS filesystem containing your pier will be mounted at `/urbit` in the container.

![](44 - Container Volume.png)

At the bottom of the container definition screen, click "Create".

![](45 - Click Create.png)

Click the Create button at the bottom of the Task Definition screen. On the landing page, click "View task definition."

![](46 - Click View Task Definition.png)

From the left-side navigation bar, select the "Clusters" screen.

![](47 - Go To Clusters.png)

On the "Clusters" screen, click "Create Cluster"

![](48 - Click Create Cluster.png)

Ensure the "Networking Only" cluster template is selected, then click "Next step"

![](49 - Fargate Cluster.png)

Name your cluster e.g. `urbit-cluster`. Ensure that the "Create VPC" checkbox is **unchecked**, then click "Create" at the bottom of the screen.

![](50 - Create Cluster.png)

On the landing page, click "View Cluster"

![](51 - Click View Cluster.png)

Viewing the cluster, select the "Services tab", and within the tab click "Create".

![](52 - Click Service Create.png)

Ensure that the "Launch type" is `FARGATE`.

Pick the task definition named for your ship that you created earlier.

Ensure the ""Platform version" is `1.4.0`, even if `1.3.0` is tagged "Latest". If not, you will be unable to create a Fargate service with an EFS volume mount.

Ensure the cluster you created previously is selected. Name the service for your ship. Ensure that the "Number of tasks" is `1`, as we do not want to run duplicate instances of a ship.

![](53 Service Options.png)

Click "Next step" at the bottom of the screen

![](54 - Service Click Next Step.png)

Ensure the cluster default VPC is selected, and select at least two of its subnets.

Select the "Edit" button by "Security Groups."

![](55 - Select Edit SG.png)

Select the "Select existing security group" radio button, then select only the `urbit-ecs` security group. Click "Save" at the bottom.

![](56 - Select urbit-ecs SG.png)

Ensure that "Auto-assign public IP" is `ENABLED`

![](57 - Network Config.png)

Select "Next step" at the bottom

![](58 - Next Step.png)

Ensure under "Set Auto Scaling" that the radio button "Do not adjust the service's desired count" is selected, to avoid duplicated instances of your ship.

![](59 - Default Auto Scaling.png)

Click "Create Service" at the bottom

![](60 - Click Create Service.png)

On the landing page, click "View Service"

![](61 - Click View Service.png)

Click the "Tasks" tab, and select the hexadecimal identifier of your ship's task:

![](62 - Tasks Tab.png)

On the page for your ship's task, select the "Details" tab, then scroll down to find the "Public IP" field.

![](63 - Public IP.png)

Copy and paste this into your browser. If all goes well, you should be presented with the Landscape login page for your ship.