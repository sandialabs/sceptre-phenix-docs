# Apps

`phenix` apps provide a means of modifying an experiment topology, cluster
networking, hardware-in-the-loop devices, etc. in a layered, scripted, and
codified manner. `phenix` itself includes four (4) default apps that get applied
to every experiment by default. In addition to the default apps, it is possible
to apply _user apps_ to an experiment using a
[scenario](configuration.md#scenario) configuration.

## Default Apps

|         |                                                                               |
|---------|-------------------------------------------------------------------------------|
| ntp     | provides/configures NTP service for experiment                                |
| serial  | configures serial interfaces in VM images                                     |
| startup | configures minimega startup injections based on OS type                       |
| vrouter | customizes Vyatta/VyOS routers, including setting interfaces, ACL rules, etc. |

## Additional Core Apps

The apps listed below are provided by the core `phenix` application, but are not
considered default apps since they do not get applied to every experiment by
default. They're more like a [user app](#user-apps), but implemented in the core
application instead of as a stand-alone executable.

|     |                                                      |
|-----|------------------------------------------------------|
| soh | provide state of health monitoring for an experiment |

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
