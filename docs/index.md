# Welcome

This is the documentation for the minimega `phenix` orchestration tool. 
`phenix` development happens in the
[sandialabs/sceptre-phenix](https://github.com/sandialabs/sceptre-phenix) 
GitHub repository.

## Getting Started with phēnix

The first step in using `phenix` is to get it installed. `phenix` needs access
to the minimega unix socket, so the best place to deploy it is on a 
[minimega](https://www.sandia.gov/minimega/)
cluster's head node. The minimega unix socket will be located at
`/tmp/minimega/minimega` on default cluster deployments and will be owned by
root, so unless the socket's group ownership and group write permissions have
been updated, `phenix` will need to be run as root in order to access the
socket.

!!! note
    In most cases, it's much easier to deploy the latest version of both phēnix
    and minimega with [Docker](https://www.docker.com/) (see next section). 
    The phēnix repository includes
    a [Docker Compose](https://docs.docker.com/compose/) file that will always 
    ensure the required versions are
    working together correctly.

### Installing and Running via Docker

The phēnix repository includes Docker resources in the `docker` directory. By
far the easiest way to get phēnix up and running is to use the 
[Docker Compose](https://docs.docker.com/compose/)
configuration located at `docker/docker-compose.yml`. This will ensure that the
latest required version of minimega is also present and configured with the
additional Linux tools required to operate correctly with phēnix.

To run phēnix and minimega using Docker Compose, run the following command from
the `docker` directory.

```shell
docker compose up -d --build
```

The above command will first build the phenix Docker image and
then start all the Docker services defined in the compose file in detached mode.

Besides phēnix and minimega, there are two additional services defined in the
compose file; one for Elasticsearch and one for Kibana. These are included in
the compose file because they're often used with the Scorch phēnix application.
If you don't need the Elasticsearch and Kibana services, you can prevent them
from being started by specifying that only the `phenix` service (and its
dependency service `minimega`) be brought up.

```shell
docker compose up -d --build phenix
```

!!! note
    The Docker image will also include the `phenix` user apps available in the
    [sandialabs/sceptre-phenix-apps](https://github.com/sandialabs/sceptre-phenix-apps)
    repo.

With `phenix` running in a container, it's useful to setup a bash alias for
`phenix`:

```shell
alias phenix="docker exec -it phenix phenix"
```

Included below are explanations of some of the configuration options chosen to
be used in the Docker Compose file.

The Docker `privileged` mode, along with the `/dev` and `/proc` volume mounts,
are needed for building QCOW2 VM images with phēnix. They can be omitted if
phēnix won't be used to build images.

The `/var/log/phenix` volume mount is shared with the host to make debugging
failed container issues easier, since phēnix writes logs to `/var/log/phenix` 
by default when run as root.

The `/etc/phenix` volume mount is shared with the host to persist phēnix
configuration changes across container restarts, since the phēnix configuration
store is written to `/etc/phenix/store.bdb` by default when run as root.

The `/var/run/netns` volume mount is shared with the host to synchronize 
network
namespaces created by phēnix taps between the phēnix and minimega containers.

The `/phenix` volume mount is used as the base directory for phēnix by default
(see `--base-dir.phenix` global option), so we share this directory with the
host to persist changes across container restarts.

### Simplified deployment
The simplified deployment will deploy the latest version of phenix and minimega 
without building from source, instead using the latest version of the phenix 
Docker image pulled from GitHub.

The primary differences are:
- Uses pre-build phenix Docker image from GitHub
- No Elasticsearch or Kibana services

```shell
git clone https://github.com/sandialabs/sceptre-phenix.git
cd sceptre-phenix/docker

# Start phenix and minimega containers
docker compose -f no-build_docker-compose.yml up -d --pull

# Run the following command and wait until minimega and phenix finish initializing
docker compose logs -f
# CTRL+C to exit
```

### Building from Source

The easiest way to build from source is to use the Docker-based build script
located at `hack/build/docker-build.sh` by running the following command from
the root directory of the repository.

```
hack/build/docker-build.sh
```

Once the build is finished, there will be a `phenix` executable located in the
`bin` directory. For additional usage details, pass the `-h` option to the 
build
script.

### Using

The following output results from `bin/phenix help`:

```shell
A cli application for phēnix

Usage:
  phenix [flags]
  phenix [command]

Available Commands:
  config      Configuration file management
  experiment  Experiment management
  help        Help about any command
  image       Virtual disk image management
  mm          Send commands, or attach, to minimega
  settings    View or edit phenix settings
  ui          Run the phenix UI
  util        Utility commands
  version     print version information
  vlan        Used to manage VLANs
  vm          Virtual machine management

Flags:
      --base-dir.minimega string   base minimega directory (default "/tmp/minimega")
      --base-dir.phenix string     base phenix directory (default "/phenix")
      --bridge-mode string         bridge naming mode for experiments ('auto' uses experiment name for bridge; 'manual' uses user-specified bridge name, or 'phenix' if not specified) (options: manual | auto) (default "manual")
      --deploy-mode string         deploy mode for minimega VMs (options: all | no-headnode | only-headnode) (default "no-headnode")
      -h, --help                   help for phenix
      --hostname-suffixes string   hostname suffixes to strip (default "-minimega,-phenix")
      --log.error-file string      log fatal errors to file - DEPRECATED (Determined by log.file.level)
      --log.error-stderr           log fatal errors to STDERR - DEPRECATED (Determined by log.level) (default true)
      --log.file.level string      level to log messages at for log file (options: debug | info | warn | error | none) (default "info")
      --log.file.path string       path to log to (default "/var/log/phenix/phenix.log")
      --log.level string           level to log messages at (default "info")
      --store.endpoint string      endpoint for storage service (default "bolt:///etc/phenix/store.bdb")
      --unix-socket string         phēnix unix socket to listen on (ui subcommand) or connect to (default "/tmp/phenix.sock")
      --use-gre-mesh               use GRE tunnels between mesh nodes for VLAN trunking

Use "phenix [command] --help" for more information about a command.
```

Thanks to [viper](https://github.com/spf13/viper), it is possible to specify
values for all of the global and `ui` command flags listed above using a
configuration file. Global flags set at the command line will override 
settings
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

```yaml
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
has no external dependencies, but has a limitation of only being accessible on 
a
single machine. Using `etcd`, on the other hand, allows for users to run
`phenix` on multiple machines and access the same data, but requires `etcd` be
deployed as a separate service.

To use `etcd`, the `--store.endpoint` global flag should be configured with the
URL of the deployed `etcd` server. For example, `--store.endpoint etcd://localhost:2379`.
