A collection of common tasks. Role is not intended to be called directly,
rather import tasks where needed, for example:

```
- name: map ebs device names
  import_role:
    name: common
    tasks_from: drive_map.yml
```
