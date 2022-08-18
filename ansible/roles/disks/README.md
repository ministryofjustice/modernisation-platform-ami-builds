This role sets up the installation disks for Oracle, `\u01` and `\u02` and adds entries to `fstab`. It also configures the swap disk, which should be a dedicated ec2 ebs volume of the desired size. See [memory requirements](https://docs.oracle.com/cd/E11882_01/install.112/e24326/toc.htm#BHCJCBAF).

The device names should match the names of the block devices attached to the ec2 instance. There are defaults provided that match those set in the AMI build variables.
