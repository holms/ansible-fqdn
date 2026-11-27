# ansible-fqdn

[![Molecule](https://github.com/holms/ansible-fqdn/actions/workflows/molecule.yml/badge.svg)](https://github.com/holms/ansible-fqdn/actions/workflows/molecule.yml)

Configure a system hostname and FQDN name resolution on Linux and Windows.

## Requirements

- Ansible Core >= 2.16
- Linux: no extra collections required
- Windows: the `ansible.windows` collection is required only when `fqdn_windows_reboot` is enabled
- Tests: the `containers.podman` collection is installed by Molecule

## Platforms

- Debian and Ubuntu
- RedHat Enterprise Linux, CentOS Stream, Rocky Linux, AlmaLinux and Fedora
- Windows

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `fqdn` | `inventory_hostname` | Fully qualified domain name. |
| `hostname` | `inventory_hostname_short` | Short hostname. |
| `ip_address` | `ansible_facts['default_ipv4']['address']`, falling back to `127.0.1.1` | IPv4 address used for `/etc/hosts`. May be a list. |
| `fqdn_hosts_ips` | Derived from `ip_address` | IP addresses written to `/etc/hosts`. |
| `fqdn_hosts_aliases` | `[fqdn, hostname]` | Names written after each IP in `/etc/hosts`. |
| `fqdn_use_full_hostname` | `false` | Use `fqdn` as the system hostname instead of `hostname`. |
| `fqdn_manage_etc_hosts` | `true` | Manage a marked block in `/etc/hosts`. |
| `fqdn_manage_cloud_init` | `false` | Write cloud-init configuration to preserve the hostname and disable cloud-init management of `/etc/hosts`. |
| `fqdn_unsafe_writes` | `false` | Permit unsafe writes for bind-mounted `/etc/hosts` and `/etc/hostname` files, as found in containers. |
| `fqdn_redhat_install_selinux_python` | `true` | Install SELinux Python bindings on RedHat-family systems. |
| `fqdn_windows_reboot` | `false` | Reboot Windows automatically when required. Requires the `ansible.windows` collection. |

Advanced overrides: `fqdn_etc_hosts_file`, `fqdn_etc_hosts_marker`, `fqdn_cloud_init_config_dir`, `fqdn_cloud_init_config_file`, and `fqdn_selinux_python_package`.

## Examples

Linux:

```yaml
- hosts: all
  become: true
  roles:
    - role: holms.fqdn
      vars:
        fqdn: web01.example.com
        hostname: web01
```

Containers and cloud images:

```yaml
vars:
  fqdn_unsafe_writes: true
  fqdn_manage_cloud_init: true
```

Windows:

```yaml
- hosts: windows
  roles:
    - role: holms.fqdn
      vars:
        fqdn: win01.example.com
        hostname: win01
        fqdn_windows_reboot: true
```

## Testing

```bash
pip install -r requirements.txt
ansible-galaxy collection install containers.podman ansible.windows
molecule test
ansible-lint
```

Molecule runs the role against Podman containers for Debian 12, Ubuntu 24.04, and Rocky Linux 9.

## License

MIT

## Author Information

Roman Gorodeckij (<holms@holms.lt>)
