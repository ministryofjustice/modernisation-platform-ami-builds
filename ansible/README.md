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

Include an ansible step within the build phase which:

- installs ansible wihtin a virtual environment
- clones this repo
- installs dependencies
- runs ansible against localhost
- tidies up

For example:

```
      - name: InstallAndRunAnsible
        action: ExecuteBash
        inputs:
          commands:
            - |
              set -e
              cd /tmp

              # install, create, activate virtual environment
              pip3.9 install virtualenv
              mkdir /tmp/python-venv && cd "$_"
              python3.9 -m venv ansible
              source ansible/bin/activate

              # Install ansible modules in virtual env
              python3.9 -m pip install --upgrade pip
              python3.9 -m pip install ansible==6.0.0

              # Download playbook
              mkdir /tmp/database-ansible-playbook && cd "$_"
              git clone "https://github.com/ministryofjustice/modernisation-platform-ami-builds.git"
              cd modernisation-platform-ami-builds/ansible

              # Install requirements in virtual env
              python3.9 -m pip install -r requirements.txt
              ansible-galaxy role install -r requirements.yml
              ansible-galaxy collection install -r requirements.yml

              # Get required extra vars and run ansible
              INSTANCE_ID=$(curl http://instance-data/latest/meta-data/instance-id)
              PY_INTERPRETER=$(which python3.9)
              ansible-playbook ../teams/nomis/ansible/playbooks/database-ami-provisioning.yml \
              --connection=local \
              --inventory localhost, \
              --extra-vars "instance_id=$INSTANCE_ID ansible_python_interpreter=$PY_INTERPRETER s3_bucket_with_prefix=ec2-image-builder-nomis20220314103938567000000001/oracle-11g-software" \
              --become \
              --tags "all,opatch,patch,deconfig"

              # Deactivate virtual env and cleanup
              deactivate
              rm -r /tmp/python-venv
              rm -r /tmp/database-ansible-playbook
```
