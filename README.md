# Managing terraform state file. Terraform state commands.

Terraform has lots of commands which you want to be familiar with if you want to use Terraform, and detailed description is given in the next link [alphabetical list of commands](https://www.terraform.io/docs/cli/commands/import.html)

But when you work with Terraform state file there's a specific list of subcommands that you can see after running `terraform state` command that you can use with terraform state:

```
Subcommands:
    list                List resources in the state
    mv                  Move an item in the state
    pull                Pull current state and output to stdout
    push                Update remote state from a local state file
    replace-provider    Replace provider in the state
    rm                  Remove instances from the state
    show                Show a resource in the state
```

`terraform state list` - is a command which lists all the resources (types of resources) and their names, that was created and currently sitting in state file. Output from this command will be like this, in my case I have two instances and security group:

```
aws_instance.first_ec2
aws_instance.second_ec2
aws_security_group.sg_for_ec2
```

If you would like to see detailed information about particular resource `terraform state show` is the command, in my case I'm pulling info about my ec2 instance.

```
terraform state show aws_instance.second_ec2  (resource type and name)
```

Here in addition to `terraform state show` you need to give the `resource type.resource name` as it shown above and the output will be next:

```
# aws_instance.second_ec2:
resource "aws_instance" "second_ec2" {
    ami                          = "ami-0be2609ba883822ec"
    arn                          = "arn:aws:ec2:us-east-1:974912841781:instance/i-0a88e8b8309c412c2"
    associate_public_ip_address  = true
    availability_zone            = "us-east-1d"
    cpu_core_count               = 1
    cpu_threads_per_core         = 1
    disable_api_termination      = false
    ebs_optimized                = false
    get_password_data            = false
    hibernation                  = false
    id                           = "i-0a88e8b8309c412c2"
    instance_state               = "running"
    instance_type                = "t2.micro"
    ipv6_address_count           = 0
    ipv6_addresses               = []
    monitoring                   = false
    primary_network_interface_id = "eni-08a7e28271dd24db2"
    private_dns                  = "ip-172-31-92-93.ec2.internal"
    private_ip                   = "172.31.92.93"
    public_dns                   = "ec2-54-144-177-15.compute-1.amazonaws.com"
    public_ip                    = "54.144.177.15"
    secondary_private_ips        = []
    security_groups              = [
        "default",
    ]
    source_dest_check            = true
    subnet_id                    = "subnet-ebc366ca"
    tags                         = {
        "Name" = "second"
    }
    tenancy                      = "default"
    vpc_security_group_ids       = [
        "sg-5edf9167",
    ]

    credit_specification {
        cpu_credits = "standard"
    }

    enclave_options {
        enabled = false
    }

    metadata_options {
        http_endpoint               = "enabled"
        http_put_response_hop_limit = 1
        http_tokens                 = "optional"
    }

    root_block_device {
        delete_on_termination = true
        device_name           = "/dev/xvda"
        encrypted             = false
        iops                  = 100
        tags                  = {}
        throughput            = 0
        volume_id             = "vol-0165edeadb9b51cf9"
        volume_size           = 8
        volume_type           = "gp2"
    }
}
 ```
The next command  will taint/untaint the instances that are in the state file. The ```terraform taint``` command manually marks a Terraform-managed resource as tainted, forcing it to be destroyed and recreated on the next apply. This command will not modify infrastructure, but does modify the state file in order to mark a resource as tainted. Generally if we run ```tefform tain aws_instance.test_instance``` it will tain that resourcse and we run terraform init , it will initializes again and when we run terraform plan, it will show that our first instance will be desroyed and a new instance will be created. But we can easily untain the resource by running ```terraform untaint aws_instance.test_instance``` and if we run ```terraform plan``` it will say that evything is up to date.

```
terraform taint/untaint resourcetype.resourcename (aws_instance.test_instance)
```
Output from running command above will be:

```
Resource instance aws_instance.test_instance has been marked as tainted. 
```
The next command is ```terraform state rm```:

```
terraform state rm aws_instance.test_instance
```
It works the same way as the other commands which were refering to the objects (resources) in the state file. When you run ```terraform state rm aws_instance.test_instance``` it will get deleted from the state file and terraform has no idea that the first instance was ever created, is not physically destroyed from AWS. But if we run ```terraform plan``` it will say that new instance will get created as it is shown in our configurations (template). So that instance which teffaform is not aware of will be still up and running, always run command ```terraform plan``` to make sure what you are doing by running that command. There are various use cases for removing items from a Terraform state file. The most common is refactoring a configuration to no longer manage that resource (perhaps moving it to another Terraform configuration/state).
The next command is terraform move, what is does is moves one resource to another: 
```
terraform state mv aws_instance.test_instance_2 aws_instance.move_to_me
```
Here basically since all the configurations are the same on both resources , terraform just renaming the ```aws_instance.test_instance_2``` to ```aws_instance.move_to_me```. So if we run ```terraform state list``` we get different output form the previous one. Instead of this:
```
aws_instance.test_instance_2
```
we will get this:
```
aws_instance.move_to_me
```
That means it was moved from one to another.

The next command is ```terraform refresh``` this command will compare the state file and the real world infrastructure and can detect if there any changes were done.This does not modify state infrastructure but does modify the state file. If state is changed it will occure in the next ```terraform apply```.

```terraform validate``` will go and check your configurations and makes sure it's valid, if it is not it give an error by saying this part wasn't configured right.It is a good practice to run this command to check while you are writing your  code, really helpfultf command, takes just a few seconds to run. 

```terraform fmt``` command will will make sure your code (configurations) are well formated by hashi corp standards.

```terraform import``` will import existing resources into terraform.To copy a module you need to run the next command:
```
terraform import module.my-ec2.aws_instance.ec2-instance i-0a0c9cd872cb1a200. # module.modules_name.resource_type.resource_name followed by resource ID
```
To import an ec2 it will look like this:
```
terraform import aws_instance.my-ec2 i-0a0c9cd872cb1a200 # resource_type.resource_name followed by resource ID.
```
For the s3 bucket it looks like this"
```
terraform import aws_s3_bucket.bucket bucket-name
```
