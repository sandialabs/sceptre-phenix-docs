# Apps

`phenix` apps provide a means of modifying an experiment topology, cluster
networking, hardware-in-the-loop devices, etc. in a layered, scripted, and
codified manner. `phenix` itself includes four (4) default apps that get applied
to every experiment by default. In addition to the default apps, it is possible
to apply _user apps_ to an experiment using a
[scenario](configuration.md#scenario) configuration.

## Default Apps

|         |                                                                                              |
|---------|----------------------------------------------------------------------------------------------|
| ntp     | provides/configures NTP service for experiment                                               |
| serial  | configures serial interfaces in VM images                                                    |
| startup | configures minimega startup injections based on OS type                                      |
| vrouter | customizes Vyatta/VyOS and minirouter routers, including setting interfaces, ACL rules, etc. |

### vrouter App

As of commit `e276a5b`, the `vrouter` app also supports the use of minimega's
`minirouter` to include interface configuration, DHCP and DNS configuration,
firewall rules, etc.

!!! note
    Support for firewall rules with `minirouter` currently requires the use of
    the `activeshadow/minimega@minifw` branch until [PR
    1456](https://github.com/sandia-minimega/minimega/pull/1456) is merged.

The following is an example of how the `vrouter` app can be configured via a
`Scenario` configuration, showing all the possible options.

```
spec:
  apps:
  - name: vrouter
    hosts:
    - hostname: rtr
      metadata:
        ipsec:
        - local: 10.0.10.2
          peer: 10.0.40.2
          tunnels:
          - local: 192.168.10.0/24
            remote: 192.168.100.0/24
        acl:
          ingress:
            IF0: in-rules
          rulesets:
          - name: in-rules
            default: drop
            rules:
            - action: accept
              description: Allow Incoming HTTP
              source:
                address: 192.168.0.0/24
              destination:
                address: 10.0.0.0/24
                port: 80
              protocol: tcp
        dhcp:
        - listenAddress: 10.0.0.254
          ranges:
          - lowAddress: 10.0.0.10
            highAddress: 10.0.0.20
          defaultRoute: 10.0.0.254
          dnsServers:
          - 10.0.0.254
          staticAssignments:
            00:00:00:00:00:AA: 10.0.0.50
        - listenAddress: 192.168.0.254
          ranges:
          - lowAddress: 192.168.0.10
            highAddress: 192.168.0.20
          defaultRoute: 192.168.0.254
          dnsServers:
          - 192.168.0.254
          staticAssignments:
            00:00:00:00:00:BB: 192.168.0.50
        dns:
          1.2.3.4: foo.com
```

* `ipsec`: if present, point-to-point IPSec tunnels are nailed up between the
  list of given IP addresses and traffic between the given networks is tunneled.

    * `local`: IP address on a local interface (e.g. this router) to bind the
      IPSec tunnel to. It must have a route to the `peer` IP address.

    * `peer`: remote IP address to create the IPSec tunnel with.

    * `tunnels`: list of local and remote networks to tunnel through this
      point-to-point connection.

        * `local`: local network to tunnel to the given remote network.

        * `remote`: remote network to tunnel to the given local network.

* `acl`: if present, access control lists (ACLs / firewall rules) are created on
  the router per the defined rulesets.

    * `ingress`: for each interface-to-ruleset mapping, apply the given ruleset
      to the given interface for inbound traffic. Note that the interface name
      used (in this example, `IF0`) refers to the name given to a network
      interface in the router's topology configuration.

    * `egress`: for each interface-to-ruleset mapping, apply the given ruleset
      to the given interface for outbound traffic.

    * `rulesets`: list of rulesets to create on the router.

      * `name`: name of the ruleset; used in the interface-to-ruleset mapping in
        the `ingress/egress` sections.

      * `default`: default action to apply to traffic that doesn't match any
        rules.

      * `rules`: list of rules to apply to traffic.

        * `action`: action to apply to traffic matching rule.

        * `source`: map describing what source to limit matching traffic to. If
          not provided, all sources are matched.

          * `address`: source address to limit matching traffic to. If not
            provided, all source addresses are matched.

          * `port`: source port to limit matching traffic to. If not
            provided, all source ports are matched.

        * `destination`: map describing what destination to limit matching
          traffic to. If not provided, all sources are matched.

          * `address`: destination address to limit matching traffic to. If not
            provided, all destination addresses are matched.

          * `port`: destination port to limit matching traffic to. If not
            provided, all destination ports are matched.

        * `protocol`: IP protocol to limit matching traffic to. If not provided,
          all protocols are matched.

* `dhcp`: if present, DHCP is configured on the router per the provided list.

  * `listenAddress`: IP address on a local interface (e.g. this router) to bind
    this DHCP configuration to.

  * `ranges`: list of IP address low/high ranges to use for DHCP assignments.
    The IP addresses must be within the IP network of the `listenAddress`.

  * `defaultRoute`: default gateway to be included in DHCP leases.

  * `dnsServers`: list of DNS servers to be included in DHCP leases.

  * `staticAssignments`: map of MAC-to-IP assignments to use for static DHCP
    addresses.

* `dns`: if present, map of IP-to-domain DNS entries to create on the router.

!!! note
    Currently, the `ipsec` metadata section only applies to Vyatta/VyOS routers.

!!! note
    Currently, the `dhcp` and `dns` metadata sections only apply to minirouter
    routers.

## Additional Core Apps

The apps listed below are provided by the core `phenix` application, but are not
considered default apps since they do not get applied to every experiment by
default. They're more like a [user app](#user-apps), but implemented in the core
application instead of as a stand-alone executable.

|     |                                                      |
|-----|------------------------------------------------------|
| soh | provide state of health monitoring for an experiment |
| scorch | [Scorch](/scorch) &mdash; **SC**enario **ORCH**estration &mdash; is an automated scenario orchestration framework within phenix |

## User Apps

`phenix` _user apps_ are stand-alone executables that `phenix` shells out to at
different stages of the experiment lifecycle (`configure, pre-start, post-start,
running, and cleanup`). When `phenix` encounters an app in an experiment
scenario that isn't a default app, it checks to see if an executable exists in
its current `PATH` in the form of `phenix-app-<app name>`. If the executable
exists, `phenix` shells out to it, providing the current lifecycle stage as an
argument and providing the experiment `metadata, spec, and status` as a JSON
string over `STDIN`.

!!! note
    There will be three (3) top-level keys available in the JSON passed to a
    user app over `STDIN`: `metadata, spec, and status`. For the `configure and
    pre-start` stages, the `status` value will be null or otherwise ignored. The
    `spec` value will be [experiment schema](schema.md#experiment-schema).

!!! tip
    You can run `phenix util app-json <exp name>` to see an example of what the
    JSON that's passed to a user app looks like.

The user app can modify the experiment at will, then return the updated
JSON over `STDOUT` and exit with a `0` status. If the user app encounters an
error, it can print any error messages to `STDERR` and exit with a non-zero
status to signal to `phenix` that an error occurred.

!!! note
    `phenix` will only process updates to the `spec` value for the `configure
    and pre-start` stages, and will only process updates to the `status` value
    for the `post-start, running, and cleanup` stages. More specifically, it
    will only process updates to `status.apps.<app name>`, which can be anything
    the app wants it to be (e.g. a simple string, an array, or a
    map/dictionary).

!!! note
    It is possible for the execution of app stages to be canceled by the caller.
    In the case of user apps, `phenix` will send a `SIGTERM` to the user app
    process and wait a maximum of 10 seconds for the process to exit gracefully
    before killin the process with a `SIGKILL`.

### Available User Apps

The
[sandia-minimega/phenix-apps](https://github.com/sandia-minimega/phenix-apps)
repo is home to some user apps that have already been created by the community,
including the following:

* protonuke
* wireguard
* mirror

In addition, this repo also contains some generic library/utility code for
making custom user app development easier. See the
[README](https://github.com/sandia-minimega/phenix-apps/blob/master/README.md)
for additional details.

### Example

Below is a very contrived example of a simple _user app_ that changes the disk
image used for every node in the experiment topology. Assuming the name of the
executable for this app as `phenix-app-image-changer`, it could be applied to a
topology by including a scenario in an experiment that includes an experiment
app named `image-changer`.

```
import json, sys


def eprint(*args):
    print(*args, file=sys.stderr)


def main() :
    if len(sys.argv) != 2:
        eprint("must pass exactly one argument on the command line")
        sys.exit(1)


    raw = sys.stdin.read()

    if sys.argv[1] != 'pre-start':
        print(raw)
        sys.exit(0)


    exp = json.loads(raw)
    spec = exp['spec']

    for n in spec['topology']['nodes']:
        for d in n['hardware']['drives']:
            d['image'] = 'm$.qc2'


    print(json.dumps(exp))
```
