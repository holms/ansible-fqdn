fqdn [![Build Status](https://travis-ci.org/holms/ansible-fqdn.svg?branch=master)](https://travis-ci.org/holms/ansible-fqdn)
====

Sets Fully qualified domain name (FQDN)

Requirements
------------

Ansible version 1.6

## Platforms

* Ubuntu
* Debian
* Centos
* Redhat

Role Variables
--------------


|Variable name | Variable value
|--------------|---------------
|*hostname*    |new hostname (not FQDN, before first dot)
|*fqdn*        | new domain name

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
