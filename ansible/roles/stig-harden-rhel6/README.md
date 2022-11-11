This role makes use of a third-party ansible-galaxy role that was created to run stig checks on Rhel 6 instances.

Taking this approach avoids having to write a LOT of our own bash code for the Rhel 6 base ami that is only used by Weblogic EC2 instances.

## Sources
[Ansible Galaxy Stig - Rhel6 Role](https://galaxy.ansible.com/MindPointGroup/STIG-RHEL6)

[Github](https://github.com/ansible-lockdown/RHEL6-STIG)

## Calling this role
As mentioned above this role is only used by Weblogic EC2 instances because the AWS base Rhel 6 ami can't use the stig clamp scripts available elsewhere for Rhel 7.

It is called from ~/teams/nomis/rhel_6_10_baseimage/terraform.tfvars as a custom component for the rhel_6_10_baseimage ami via stig_rhel6_ansible.yml.tftpl

## Notes about tags
The role has a lot of tags that can be used to run specific checks.
In line with other stig check scripts (which are part of AWS) we are only running CAT1 (high) and CAT2 (medium) checks.

--tags
 - amibuild <- required to run the role
 - prelim   <- runs the prelim stig checks 
 - cat1     <- runs the cat1 stig checks
 - cat2     <- runs the cat2 stig checks

--skip-tags: 
 - all related to checks which currently fail to execute for various reasons

These might be explicit i.e. V-38484 or are a group like sshd. Some might fail because the handler being used doesn't exist on the ami/base image, some other dependency is missing or the check itself does actually fail. Some checks might be making assumptions which aren't relevant in our use case.

There is a follow up item to review these and see if we can fix them. See [DSOS-1569](https://dsdmoj.atlassian.net/browse/DSOS-1569) for more details.
