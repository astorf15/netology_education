Kibana
=========

Simple download binaries from official website and install Kibana.

Role Variables
--------------

There is only two variables that you can redefine in your playbook.

```yaml
elastic_version: "7.12.0" # Use for download only this version of kibana
elastic_home: "/opt/kibana/{{ kibana_version }}" # Use for unpackage distro and create KIBANA_HOME variable
```

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```yaml
- hosts: all
  roles:
      - kibana
```

License
-------

BSD

Author Information
------------------

Alexey Zaitsev
