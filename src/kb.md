# Knowledge Base

## Article EX-SC-UPG-01

The phenix Scenario configuration has been upgraded to v2 to get rid of the
distinction between experiment apps and host apps. While the phenix app takes
care of upgrading existing v1 scenarios to v2 when viewing, embedding into an
experiment, etc., it does not automatically upgrade embedded scenarios in
existing experiment configs.

Users might encounter the following error message when trying to do anything
with experiments that were created with a v1 scenario config:

```
'scenario.apps': source data must be an array or slice, got map
```

There are two ways to overcome this error:

1. Delete the experiment using the `config delete` subcommand and recreate it
   with the `experiment create` command; or
1. Edit the experiment using the `config edit` subcommand. If the experiment
   is running, use the `--force` flag with `config edit`.

If you choose to edit an existing experiment rather than deleting and
recreating, all you need to do is delete the `experiment` and `host` keys in the
`scenario.apps` section of the experiment spec and make `scenario.apps` a list
of apps instead of a map.

For example, say you have an experiment whose `scenario.apps` section of the
config looks like the following when you go to edit it:

```
scenario:
  apps:
    experiment:
    - name: test-user-app
      metadata: {}
    host:
    - name: protonuke
      hosts:
      - hostname: host-00
        metadata:
          args: -logfile /var/log/protonuke.log -level debug -http -https -smtp -ssh 192.168.100.100
```

After editing, the scenario section should look like the following:

```
scenario:
  apps:
  - name: test-user-app
    metadata: {}
  - name: protonuke
    hosts:
    - hostname: host-00
      metadata:
        args: -logfile /var/log/protonuke.log -level debug -http -https -smtp -ssh 192.168.100.100
```
