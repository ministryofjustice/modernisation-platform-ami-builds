This role installs Oracle 11g. It assumes the installation disks `\u01` and `\u02` have already been setup (with `disks` role for example).

### Tags

Some tasks are optional and can be included in the play by adding the appropriate tag at the command line. Currently these are:

- `opatch` - add to upgrade opatch to the version in `./vars/patches.yml`
- `patch` - add to install patches set in `./vars/patches.yml`
- `deconfig` - part of the post install tasks, adding this tag will deconfigure Oracle HAS. Typically used when this role is used as part of an AMI build, so that the install can be reconfigured on hosts subsequently launched with said AMI.

E.g. Run `ansible-playbook` with `--tags "all,opatch,patch" to run the Oracle install tasks and upgrade opatch and apply patches

### s3 bucket

The Oracle installation files should be located in an s3 bucket accessible by the remote host. The files should all have the same prefix and the prefix should be included as part of the variable, hence the variable name `s3_bucket_with_prefix`.

### Oracle ASM disks

Oracle ASM (Automatic Storage Manager) [library](https://www.oracle.com/linux/downloads/linux-asmlib-rhel7-downloads.html) is used as the volume manager for Oracle database disks rather than manual configuration with [UDEV rules](https://dsdmoj.atlassian.net/wiki/spaces/DSTT/pages/579994207/UDEV+configuraion+for+ASM+Disks). The variables `oracle_asm_data_disks` and `oracle_asm_flash_disks` contains a list of devices to be configured by ASMlib and should match the device configuration on the remote host (in terms of matching the device names to the required ASM disk labels).

### Issues

There are issues running this role as `ssm-user`. It fails on the `run oracle grid install` task (see `install_grid.yml`) for some reason, complaining that `/u01/app/oraInventory` directory is not empty (which is a directory created as part of the grid install). It works fine if you connect as a normal user, either via the Bastion (see main README for how to set that up) or directly through Session Manager if `ssm-agent` is installed on the instance.
