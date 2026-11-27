# ansible-fqdn

[![Galaxy](https://img.shields.io/badge/dynamic/json?label=galaxy&url=https%3A%2F%2Fgalaxy.ansible.com%2Fapi%2Fv1%2Froles%2F12355%2F&query=summary_fields.versions%5B0%5D.name&logo=ansible)](https://galaxy.ansible.com/holms/fqdn)
[![Galaxy downloads](https://img.shields.io/badge/dynamic/json?label=downloads&url=https%3A%2F%2Fgalaxy.ansible.com%2Fapi%2Fv1%2Froles%2F12355%2F&query=download_count&logo=ansible)](https://galaxy.ansible.com/holms/fqdn)
[![Molecule](https://github.com/holms/ansible-fqdn/actions/workflows/molecule.yml/badge.svg)](https://github.com/holms/ansible-fqdn/actions/workflows/molecule.yml)

Configure a system hostname and FQDN name resolution on Linux and Windows.

## Requirements

- Ansible Core >= 2.16
- Linux: no extra collections required
- Windows: the `ansible.windows` collection is required only when `fqdn_windows_reboot` is enabled
- Tests: the `containers.podman` collection is installed by Molecule
- Test tooling: Python >= 3.13 is required by the pinned `ansible-core` 2.22 test environment

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
| `fqdn_hosts_ips` | Derived from `ip_address` (and `fqdn_ipv6_address` when IPv6 is enabled) | IP addresses written to `/etc/hosts`. |
| `fqdn_hosts_aliases` | `[fqdn, hostname]` | Names written after each IP in `/etc/hosts`. |
| `fqdn_use_full_hostname` | `false` | Use `fqdn` as the system hostname instead of `hostname`. |
| `fqdn_manage_etc_hosts` | `true` | Manage a marked block in `/etc/hosts`. |
| `fqdn_manage_cloud_init` | `false` | Write cloud-init configuration to preserve the hostname and disable cloud-init management of `/etc/hosts`. |
| `fqdn_manage_ipv6` | `false` | Add the host's `default_ipv6` address to `/etc/hosts` alongside the IPv4 entries. |
| `fqdn_unsafe_writes` | `false` | Permit unsafe writes for bind-mounted `/etc/hosts` and `/etc/hostname` files, as found in containers. |
| `fqdn_redhat_install_selinux_python` | `true` | Install SELinux Python bindings on RedHat-family systems. |
| `fqdn_windows_reboot` | `false` | Reboot Windows automatically when required. Requires the `ansible.windows` collection. |

Advanced overrides: `fqdn_ipv6_address`, `fqdn_etc_hosts_file`, `fqdn_etc_hosts_marker`, `fqdn_cloud_init_config_dir`, `fqdn_cloud_init_config_file`, and `fqdn_selinux_python_package`.

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

IPv6:

```yaml
vars:
  fqdn_manage_ipv6: true
```

This writes both the IPv4 and IPv6 addresses of the host to `/etc/hosts`:

```
192.0.2.10 web01.example.com web01
2001:db8::10 web01.example.com web01
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

Molecule runs the role against Podman containers for Debian 12 and 13, Ubuntu 24.04, Rocky Linux 9 and 10, and Fedora 42. Set `MOLECULE_PLATFORM` to a single inventory host (for example `molecule-debian13`) to test one distro at a time.

Windows is tested in CI on a `windows-latest` runner: the runner itself is the managed host and the Ansible controller runs in WSL (see `tests/windows/`).

## License

MIT

## Author Information

Roman Gorodeckij (<holms@holms.lt>)
