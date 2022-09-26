This role installs and sets up the script exporter service. As the intention of this role is to be used during the image building process with database images, further configuration of the agent should be added when creating the data image.

The script exporter runs and exposes metrics regarding monitoring scripts for Oracle VMs. This does require adding sudo privileges for the script exporter user (prometheus) so that it can run the check scripts as the oracle user.

This role has only been confirmed to work with RHEL7.

For more information regarding the script exporter itself please see: https://github.com/ricoberger/script_exporter
