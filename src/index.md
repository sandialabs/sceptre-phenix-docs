# Welcome

This is the documentation for the minimega phenix orchestration tool.

## Getting Started with phenix

### Building

To build locally, you will need Golang v1.14 and Node v14.2 installed. Once
those are installed (if not already), simply run `make bin/phenix`.
 
If you do not want to install Golang and/or Node locally, you can also use Docker
to build phenix (assuming you have Docker installed). Simply run
`./build-with-docker.sh` and once built, the phenix binary will be available at
`bin/phenix`. See `./build-with-docker.sh -h` for usage details.

### Using

The following output results from `bin/phenix help`:

```
A cli application for phēnix

Usage:
  phenix [flags]
  phenix [command]

Available Commands:
  config      Configuration file management
  experiment  Experiment management
  help        Help about any command
  image       Virtual disk image management
  ui          Run the phenix UI
  util        Utility commands
  version     print version information
  vlan        Used to manage VLANs
  vm          Virtual machine management

Flags:
      --base-dir.minimega string   base minimega directory (default "/tmp/minimega")
      --base-dir.phenix string     base phenix directory (default "/phenix")
  -h, --help                       help for phenix
      --hostname-suffixes string   hostname suffixes to strip
      --log.error-file string      log fatal errors to file (default "/var/log/phenix/error.log")
      --log.error-stderr           log fatal errors to STDERR (default true)
      --store.endpoint string      endpoint for storage service (default "bolt:///etc/phenix/store.bdb")

Use "phenix [command] --help" for more information about a command.
```

Thanks to [viper](https://github.com/spf13/viper), it is possible to specify
values for all of the global and `ui` command flags listed above using a
configuration file. Global flags set at the command line will override settings 
in the configuration file. phenix looks for a configuration in the following 
locations.

When run as root (not including sudo):

```
/etc/phenix/config.[yaml|json|toml]
```

When run as regular user (including sudo):

```
$HOME/.config/phenix/config.[yaml|json|toml]
/etc/phenix/config.[yaml|json|toml]
```

An example configuration file might look like the following:

```
base-dir:
  minimega: /tmp/minimega
  phenix: /phenix
log:
  error-file: /var/log/phenix/error.log
  error-stderr: true
store:
  endpoint: bolt:///etc/phenix/store.bdb
ui:
  listen-endpoint: 0.0.0.0:3000
  jwt-signing-key: abcde12345
  log-level: info
  log-verbose: true
  logs:
    phenix-path: /var/log/phenix/phenix.log
    minimega-path: /var/log/minimega/minimega.log
```

Environment variables can also be used to set global and `ui` command flags. The
environment variables must be prefixed with `PHENIX_`, with the rest of the
variable matching the flag name with `-` and `.` replaced with `_`. For example,
`--store.endpoint` becomes `PHENIX_STORE_ENDPOINT`.

Further documentation on the available commands can be found at:

* [config](configuration.md)
* [experiment](experiments.md)
* [vm](vms.md)
* [image](image.md)

### Store

The phenix tool uses a key-value data store as the storage service for all of
data needed throughout the various capabilities (as opposed to a database). By
default it uses [bbolt](https://github.com/etcd-io/bbolt) but also supports
[etcd](https://github.com/etcd-io/etcd). `bbolt` is used by default because it
has no external dependencies, but has a limitation of only being accessible on a
single machine. Using `etcd`, on the other hand, allows for users to run
`phenix` on multiple machines and access the same data, but requires `etcd` be
deployed as a separate service.

To use `etcd`, the `--store.endpoint` global flag should be configured with the
URL of the deployed `etcd` server. For example, `--store.endpoint
etcd://localhost:2379`.
