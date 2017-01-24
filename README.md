fqdn [![Build Status](https://travis-ci.org/holms/ansible-fqdn.svg?branch=master)](https://travis-ci.org/holms/ansible-fqdn)
====

Sets Fully qualified domain name (FQDN)

Requirements
------------

Ansible version 2.0+

## Platforms

* Ubuntu
* Debian
* Centos
* Redhat
* Windows

Role Variables
--------------


| Variable name | Variable value | Default |
|---------------|----------------|---------|
|*hostname*     | hostname (eg. vm1) | `inventory_hostname_short` |
|*fqdn*         | domain name (eg. vm1.test.com) | `inventory_hostname` |

Example
-------

```
- hosts: mx.mydomain.com:mx
  user: root

  roles:
    - { role: fqdn, fqdn: "mx.mydomain.com", hostname: "mx" }
```

License
-------

MIT

Author Information
------------------

Roman Gorodeckij (<holms@holms.lt>)
John Brooker (jb-github@outlook.com)
