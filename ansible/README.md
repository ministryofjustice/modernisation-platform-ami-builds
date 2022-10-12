# Modernisation Platform AMI builds with Ansible

## Introduction

AMI images can use ansible as part of the build process.

The following directory structure is proposed where common ansible resources,
such as roles, are located here. Team specific resources, such as playbooks,
are located within the relevant `teams` directory. Directory strucure as
follows:

<pre>
.
├── LICENSE
├── README.md
├── <span style="color:green">ansible</span>
│   ├── <span style="color:green">roles</span>
│   └── <span style="color:green">(...)</span>
├── modernisation-platform
│   └── (...)
├── scripts
│   └── (...)
└── teams
    ├── example
    │   └── (...)
    ├── nomis
    │   ├── <span style="color:green">ansible</span>
    │   │   ├── <span style="color:green">playbooks</span>
    │   │   │   ├── <span style="color:green">database-ami-provisioning.yml</span>
    │   │   │   └── <span style="color:green">(...)</span>
    │   │   └── <span style="color:green">(...)</span>
    │   ├── backend.tf
    │   ├── (...)
    │   └── weblogic_pipeline_vars.tf
    └── sprinkler
        └── (...)
</pre>

Please include a README.md for each role.

## Using ansible within a build

See [example-component.yml](/teams/nomis/components/ansible.yml.tftpl)
for an example. This

- installs ansible within a virtual environment
- clones this repo
- installs dependencies
- runs ansible against localhost
- tidies up

## Running ansible against an EC2 instance post build

A generic [site.yml](/ansible/site.yml) is provided with a dynamic inventories
under [hosts/](/ansible/hosts/) folder. This creates groups based of the following
tags:

- environment-name
- ami

There are separate inventories depending on whether the EC2 is stood up
as part of an autoscaling group or as an individual instance. In an autoscaling
group, all instances will have the same tags, so the instance id is used as the
hostname rather than the Name tag.

Use tags to differentiate between AMI build tasks and in-life operational
tasks. For example, "amibuild" and "ec2patch" respectively.

Ansible tasks are executed on ec2 instances via AWS Session Manager, so you must have [awscli](https://docs.aws.amazon.com/cli/latest/userguide/install-cliv2-mac.html#cliv2-mac-install-cmd) installed in addition to the Session Manager [plugin](https://docs.aws.amazon.com/systems-manager/latest/userguide/session-manager-working-with-install-plugin.html#install-plugin-macos-signed). The target ec2 instance must also have [ssm-agent](https://docs.aws.amazon.com/systems-manager/latest/userguide/ssm-agent.html) installed. You do not need to have an account on the remote ec2 instance in order to connect.

The `ansible_connection` variable is set to use the `community.aws.aws_ssm` plugin in [group_vars/aws_ec2.yml](/ansible/group_vars/aws_ec2.yml). The `aws_ec2` group is the default group for all instances that are obtained from dynamic inventory.

Ensure you have set your AWS credentials as environment variables or setup your `~/.aws/credentials` accordingly before attempting to run ansible. Note that at the time of writing, it does not seem possible to run Ansible with credentials obtained from `aws sso login`. Temporary credentials can be obtained from https://moj.awsapps.com/start#/

You may encounter an error similar to `ERROR! A worker was found in a dead state`. Apparently this is a Python issue and the workaround is to set an env:

```
export no_proxy='*'
```

The Session Manager plugin requires that an S3 bucket is specified as one of the connection variables. Set this within an environment specific variable, for example [group_vars/environment_name_nomis_test.yml](/ansible/group_vars/environment_name_nomis_test.yml)

Define the list of roles to run on each type of server under an ami specific variable. For example [group_vars/ami_nomis_rhel_6_10_baseimage.yml](/ansible/group_vars/ami_nomis_rhel_6_10_baseimage.yml)

```
---
ansible_python_interpreter: /usr/local/bin/python3.9
roles_list:
  - node-exporter
```

Run ansible

```
# Run against all hosts in check mode
ansible-playbook site.yml --check

# Limit to a particular host/group
ansible-playbook site.yml --limit bastion

# Limit to a particular role
ansible-playbook site.yml -e "role=node-exporter"

# Run locally (the comma after localhost is important)
ansible-playbook site.yml --connection=local -i localhost, -e "target=localhost" -e "@group_vars/ami_nomis_rhel_7_9_baseimage.yml" --check
```
