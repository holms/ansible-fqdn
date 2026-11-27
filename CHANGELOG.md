# Changelog

## v2.2.0 (2026-11-28)

### Added

- `fqdn_loopback_entry` (default `true`): writes a `127.0.1.1` entry with the FQDN and hostname after the real addresses, following the Debian installer convention. The real addresses stay first because `/etc/hosts` resolution is first-match-wins. Set to `false` to disable.

## v2.1.0 (2026-11-27)

### Added

- Opt-in IPv6 support: `fqdn_manage_ipv6` writes the host's `default_ipv6` address to `/etc/hosts` alongside the IPv4 entries; the address can be overridden with `fqdn_ipv6_address` (closes #36).
- Molecule coverage for Debian 13, Rocky Linux 10 and Fedora 42. Each distro runs as a parallel CI job; set `MOLECULE_PLATFORM` to test a single distro locally.
- CI job verifying the minimum supported ansible-core version (2.16) in addition to the latest (2.22).
- Windows integration test on a `windows-latest` GitHub runner: the role is applied over PSRP from a WSL controller, verifying DNS suffix registry values, idempotence and reboot reporting.
- Weekly scheduled CI runs and Dependabot for pip and GitHub Actions dependencies.

### Fixed

- Minimal RedHat-family images without the `hostname` package (for example Fedora 42) no longer fail: runtime hostname reads use gathered facts and `/proc/sys/kernel/hostname` instead of the `hostname` binary.
- The Windows PowerShell script is now invoked with single-dash parameters as PowerShell requires; the previous GNU-style double dashes broke parameter binding, and the failure was silently hidden because the script exited with code 0. Runtime errors now exit nonzero through an explicit trap.
- `/etc/hosts` backups were dropped: ansible backup copies replicate chattr attributes, which intermittently fails on bind-mounted files in containers, and the marked `blockinfile` block never touches content outside itself.

### Changed

- Galaxy platform metadata now lists the tested versions per platform instead of `all`.

## v2.0.0

Breaking-change modernization release. Requires ansible-core >= 2.16.

- Replaced the removed `include` action with `include_tasks` and modern FQCNs.
- `/etc/hosts` is managed through a marked `blockinfile` block with multi-IP and alias support.
- Container-aware hostname handling and optional cloud-init integration.
- RedHat-family SELinux Python bindings selected per distro major version.
- Modernized Windows hostname/DNS suffix handling with optional reboot control.
- Molecule tests on Debian 12, Ubuntu 24.04 and Rocky Linux 9 with GitHub Actions CI.
