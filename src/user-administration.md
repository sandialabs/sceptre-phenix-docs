# User Administration in phēnix

## Create a new user

There are two primary ways to create new users. 

1. Choose the `Create Account` link off the login page and complete all fields
   in the `Create a New Account` dialogue. This will initiate a message to an
   administrator's account who can then activate the account, setting the
   role(s) and resource name(s).

    ![screenshot](images/login_create.png){: width=400 .center}

    ![screenshot](images/create_new_account.png){: width=400 .center}

2. From the `Users` tab, click the `+` button to create a new user. Here the
   administrator will add the [role(s) and resource
   name(s)](#user-administration). 

    ![screenshot](images/create_a_new_user.png){: width=400 .center}

## Login

The login page is self-descriptive. Using the `Remember me` checkbox will set a
token to local storage so that you can remove the requirement to enter a
`Username` and `Password` each time the page or site is reloaded. 

If an administrator starts the UI server with the following command,
authentication is enabled:

```
$> phenix ui -k <some_string>
```

Without the `-k` (or `--jwt-signing-key`), authentication is disabled.

## User Administration

### Updating Users

An administrator is able to click on the username on the table in the Users tab
to update a user. They can update `First Name` or `Last Name`, `Role`,
`Experiment Names`, and `Resource Name(s)`.

### Roles

`Global Admin` is the administrator level account and has access to all
capabilities, to include user management. Global Admins also have access to all
resources. The following table provides a high-level overview of all the
available roles and their access rights.

| Role              | Limits                                                                                                                   | List  |  Get  | Create | Update | Patch | Delete |
|-------------------|:-------------------------------------------------------------------------------------------------------------------------|:-----:|:-----:|:------:|:------:|:-----:|:------:|
| Global Admin      | Can see and control absolutely anything/everything.                                                                      | E V U | E V U | E V U  | E V U  | E V U | E V U  |
| Global Viewer     | Can see absolutely anything/everything, but cannot make any changes.                                                     | E V U | E V U |        |        |       |        |
| Experiment Admin  | Can see and control anything/everything for assigned experiments, including VMs, but cannot create new experiments.      | E V   | E V   |   V    | E V    |   V   |   V    |
| Experiment User   | Can see assigned experiments, and can control VMs within assigned experiments, but cannot modify experiments themselves. | E V   | E V   |        |        |   V   |        |
| Experiment Viewer | Can see assigned experiments and VMs within assigned experiments, but cannot modify or control experiments or VMs.       | E V   | E V   |        |        |       |        |
| VM Viewer         | Can only see VM screenshots and access VM VNC, nothing else.                                                             |   V   |       |        |        |       |        |

Key: E - experiment resource, V - VM resource, U - user resource

### Resources

#### Resource: `experiments`

|      |      |
|------|------|
| Verb | list |
| Desc | get a list of all experiments |
| Exp. Scoped | yes (list is filtered to only include experiments in scope) |
| Res. Scoped | no |

|      |      |
|------|------|
| Verb | get
| Desc | get a specific experiment
| Exp. Scoped | yes
| Res. Scoped | no

|      |      |
|------|------|
| Verb | create
| Desc | create a new experiment
| Exp. Scoped | no
| Res. Scoped | no

|      |      |
|------|------|
| Verb | delete
| Desc | delete a specific experiment
| Exp. Scoped | yes
| Res. Scoped | no

#### Resource: `experiments/start`

|      |      |
|------|------|
| Verb | update
| Desc | start an experiment
| Exp. Scoped | yes
| Res. Scoped | no

#### Resource: `experiments/stop`

|      |      |
|------|------|
| Verb | update
| Desc | stop an experiment
| Exp. Scoped | yes
| Res. Scoped | no

#### Resource: `experiments/schedule`

|      |      |
|------|------|
| Verb | get
| Desc | get current schedule for an experiment
| Exp. Scoped | yes
| Res. Scoped | no

|      |      |
|------|------|
| Verb | create
| Desc | schedule an experiment using schedule algorithm
| Exp. Scoped | yes
| Res. Scoped | no

#### Resource: `experiments/captures`

|      |      |
|------|------|
| Verb | list
| Desc | get list of packet captures for an experiment
| Exp. Scoped | yes (list is filtered to only include experiments in scope)
| Res. Scoped | yes (list is filtered to only include VMs in scope)

#### Resource: `experiments/files`

|      |      |
|------|------|
| Verb | list
| Desc | get list of files for an experiment
| Exp. Scoped | yes (list is filtered to only include experiments in scope)
| Res. Scoped | no

|      |      |
|------|------|
| Verb | get
| Desc | get specific experiment file
| Exp. Scoped | yes
| Res. Scoped | no

#### Resource: `vms`

|      |      |
|------|------|
| Verb | list
| Desc | get list of VMs for an experiment
| Exp. Scoped | yes (list is filtered to only include experiments in scope)
| Res. Scoped | yes (list is filtered to only include VMs in scope)

|      |      |
|------|------|
| Verb | get
| Desc | get a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | patch
| Desc | update a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | delete
| Desc | delete a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/start`

|      |      |
|------|------|
| Verb | update
| Desc | start a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/stop`

|      |      |
|------|------|
| Verb | update
| Desc | stop a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/redeploy`

|      |      |
|------|------|
| Verb | update
| Desc | redeploy a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/screenshot`

|      |      |
|------|------|
| Verb | get
| Desc | get screenshot for a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/vnc`

|      |      |
|------|------|
| Verb | get
| Desc | get VNC address for a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/captures`

|      |      |
|------|------|
| Verb | list
| Desc | get list of packet captures for a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | create
| Desc | start a packet capture on a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | delete
| Desc | stop all packet captures on a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/snapshots`

|      |      |
|------|------|
| Verb | list
| Desc | get list of snapshots for a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | create
| Desc | create a snapshot of a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | update
| Desc | restore a specific experiment VM to a previous snapshot
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `vms/commit`

|      |      |
|------|------|
| Verb | create
| Desc | create a new backing image from a specific experiment VM
| Exp. Scoped | yes
| Res. Scoped | yes

#### Resource: `applications`

|      |      |
|------|------|
| Verb | list
| Desc | get list of user applications
| Exp. Scoped | no
| Res. Scoped | yes (list is filtered to only include applications in scope)

#### Resource: `topologies`

|      |      |
|------|------|
| Verb | list
| Desc | get list of available topologies
| Exp. Scoped | no
| Res. Scoped | yes (list is filtered to only include topologies in scope)

#### Resource: `disks`

|      |      |
|------|------|
| Verb | list
| Desc | get list of available backing images
| Exp. Scoped | no
| Res. Scoped | yes (list is filtered to only include backing images in scope)

#### Resource: `hosts`

|      |      |
|------|------|
| Verb | list
| Desc | get list of minimega cluster hosts
| Exp. Scoped | no
| Res. Scoped | yes (list is filtered to only include hosts in scope)

#### Resource: `users`

|      |      |
|------|------|
| Verb | list
| Desc | get list of users
| Exp. Scoped | no
| Res. Scoped | yes (list is filtered to only include users in scope)

|      |      |
|------|------|
| Verb | get
| Desc | get a specific user
| Exp. Scoped | no
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | create
| Desc | create a new user
| Exp. Scoped | no
| Res. Scoped | no

|      |      |
|------|------|
| Verb | patch
| Desc | update an existing user
| Exp. Scoped | no
| Res. Scoped | yes

|      |      |
|------|------|
| Verb | delete
| Desc | delete an existing user
| Exp. Scoped | no
| Res. Scoped | yes

### Built-In Roles

See the [previous](#resources) section for policy resource and verb
descriptions.

```
case GLOBAL_ADMIN:
  return Policies([]*Policy{
    {
      Experiments:   []string{"*"},
      Resources:     []string{"*", "*/*"},
      ResourceNames: []string{"*"},
      Verbs:         []string{"*"},
    },
  })
case GLOBAL_VIEWER:
  return Policies([]*Policy{
    {
      Experiments:   []string{"*"},
      Resources:     []string{"*", "*/*"},
      ResourceNames: []string{"*"},
      Verbs:         []string{"list", "get"},
    },
  })
case EXP_ADMIN:
  // must supply experiment names and resource names or nothing will authorize
  return Policies([]*Policy{
    {
      Resources: []string{"experiments", "experiments/*"},
      Verbs:     []string{"list", "get", "update"},
    },
    {
      Resources: []string{"vms", "vms/*"},
      Verbs:     []string{"list", "get", "create", "update", "patch", "delete"},
    },
    {
      Resources:     []string{"disks"},
      ResourceNames: []string{"*"},
      Verbs:         []string{"list"},
    },
    {
      Resources:     []string{"hosts"},
      ResourceNames: []string{"*"},
      Verbs:         []string{"list"},
    },
  })
case EXP_USER: // EXP_VIEWER + VM restart + VM update + VM capture
  // must supply experiment names and resource names or nothing will authorize
  return Policies([]*Policy{
    {
      Resources: []string{"experiments", "experiments/*"},
      Verbs:     []string{"list", "get"},
    },
    {
      Resources: []string{"vms", "vms/*"},
      Verbs:     []string{"list", "get", "patch"},
    },
    {
      Resources: []string{"vms/redeploy"},
      Verbs:     []string{"update"},
    },
    {
      Resources: []string{"vms/captures"},
      Verbs:     []string{"create", "delete"},
    },
    {
      Resources: []string{"vms/snapshots"},
      Verbs:     []string{"list", "create", "update"},
    },
    {
      Resources:     []string{"hosts"},
      ResourceNames: []string{"*"},
      Verbs:         []string{"list"},
    },
  })
case EXP_VIEWER:
  // must supply experiment names and resource names or nothing will authorize
  return Policies([]*Policy{
    {
      Resources: []string{"experiments", "experiments/*", "vms", "vms/*"},
      Verbs:     []string{"list", "get"},
    },
    {
      Resources:     []string{"hosts"},
      ResourceNames: []string{"*"},
      Verbs:         []string{"list"},
    },
  })
case VM_VIEWER:
  // must supply experiment names and resource names or nothing will authorize
  return Policies([]*Policy{
    {
      Resources: []string{"vms"},
      Verbs:     []string{"list"},
    },
    {
      Resources: []string{"vms/screenshot", "vms/vnc"},
      Verbs:     []string{"get"},
    },
  })
```

