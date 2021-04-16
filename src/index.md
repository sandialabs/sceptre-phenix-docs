# Welcome

This is the documentation for the minimega `phenix` orchestration tool. `phenix`
development happens in the
[sandia-minimega/phenix](https://github.com/sandia-minimega/phenix) GitHub
repository.

## Getting Started with phenix

The first step in using `phenix` is to get it installed. `phenix` needs access
to the minimega unix socket, so the best place to deploy it is on a minimega
cluster's head node. The minimega unix socket will be located at
`/tmp/minimega/minimega` on default cluster deployments and will be owned by
root, so unless the socket's group ownership and group write permissions have
been updated, `phenix` will need to be run as root in order to access the
socket.

### Installing and Running via Docker

A Docker image can be built by cloning the git repo and running the
`docker-build.sh` script in the root of the repo.

To run `phenix` as a Docker container, it will need to run in privileged mode
and have access to the host network and some host directories. An example is
below.

```
docker run -d --name phenix \
  --hostname=$(hostname) \
  --network=host \
  --privileged \
  --volume=/dev:/dev \
  --volume=/proc:/proc \
  --volume=/phenix:/phenix \
  --volume=/etc/phenix:/etc/phenix \
  --volume=/tmp:/tmp \
  --volume=/var/log/phenix:/var/log/phenix \
  --volume=/etc/localtime:/etc/localtime:ro \
  phenix phenix ui
```

* `--hostname=$(hostname)`: set the container's hostname to be the same as the
  host. This is mainly beneficial when gathering cluster node details.

* `--network=host`: use the host's network stack in the container. Using
  `--publish=3000:3000` is also a valid option.

* `--privileged`, `--volume=/dev:/dev`, and `--volume=/proc:/proc`: needed for
  building images with `phenix`. These options can be omitted if `phenix` won't
  be used to build images.

* `--volume=/phenix:/phenix`: `/phenix` is used as the base directory for
  `phenix` by default (see `--base-dir.phenix` global option), so we share this
  directory with the host to persist changes across container restarts.

* `--volume=/etc/phenix:/etc/phenix`: the `phenix` config store is written to
  `/etc/phenix/store.bdb` by default when `phenix` is run as root, so we share
  this directory with the host so config changes persist across container
  restarts.

* `--volume=/tmp:/tmp`: `minimega` creates its Unix socket in `/tmp/minimega` by
  default, so we share this directory with the host so `phenix` can have access
  to the `minimega` socket. `phenix` also writes some files to `/tmp` that
  `minimega` needs access to (e.g. injecting the `miniccc` agent into images),
  which also makes this volume mount necessary.

* `--volume=/var/log/phenix:/var/log/phenix`: `phenix` writes its logs to
  `/var/log/phenix` by default when run as root. Sharing this directory with the
  host makes it easier to debug issues if the container fails.

* `--volume=/etc/localtime:/etc/localtime:ro`: set the container's timezone to
  be the same as the host.

!!! note
    If you build the Docker image manually, be sure to replace the last line in
    the command above with the tag used to build the image.

With `phenix` running in a container, it's useful to setup a bash alias for
`phenix`:

```
alias phenix="docker exec -it phenix phenix"
```

!!! note
    The Docker image will also include the `phenix` user apps available in the
    [sandia-minimega/phenix-apps](https://github.com/sandia-minimega/phenix-apps)
    repo.

### Installing and Running via Apt

A `minimega` Debian package is hosted at
[https://apt.sceptre.dev](https://apt.sceptre.dev) that includes all the
`minimega` executables, as well as the `phenix` executable. The `minimega`
executables in this package will be more up-to-date than the versioned Debian
package released by the official `minimega` development team.

When installed via the Debian package, `systemd` units get installed for
`minimega`, `miniweb`, and `phenix`, and a `minimega` system group is created.
Any user part of the `minimega` group can access minimega without having to run
as root.

Contrary to the `phenix` Docker image, the `phenix-apps` must be installed
separately, but there's a Debian package for them too.

See [https://apt.sceptre.dev](https://apt.sceptre.dev) for instructions on
adding the Apt repo and installing `phenix` (via the `minimega` package) and
`phenix-apps`.

### Building from Source

To build locally, you will need Golang v1.14 and Node v14.2 installed. Once
those are installed (if not already), simply run `make bin/phenix`.
 
If you do not want to install Golang and/or Node locally, you can also use
Docker to build phenix (assuming you have Docker installed). Simply run
`./docker-build.sh` from the `phenix` directory and once built, the phenix
binary will be available at `bin/phenix`. See `./docker-build.sh -h` for usage
details.

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
