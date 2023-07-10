# VM Multi Action

## Selecting VMs

### From the Web-UI

The experiment must be started; click on the experiment name to enter the
Running Experiment component. Within that component, click on the checkbox 
adjacent to the `VM Name` column to select all the VMs.  Alternatively,
the checkbox adjacent to a specific VM name can be used to select the
VM.  Once one or more VMs are selected, a toolbar will appear to the
left of the search text box.  The buttons on the toolbar are essentially
the same as described in [VMs](vms.md).

![screenshot](images/vms_multi_select.png)

### From the Command Line Binary

Not applicable.

## Searching for VMs

The search text box can be used to filter the list of VMs to
only apply actions to the filtered list.

### From the Web-UI

The experiment must be started; click on the experiment name to enter the
Running Experiment component. Within that component, use the search
textbox to find VMs by:

  * state - The keywords `running,shutdown,paused,capturing` can be used 
  to find  VMs in a specific state.  Also, the `not` keyword can be used
  to negate search term(s) (i.e. `not running`)

  * ipv4 address - VMs in a specific subnet can be found by entering the
  subnet (i.e `192.168.2.0/30`)

  * other fields (i.e. name, taps, tags) - All other fields will be
  searched for a keyword contained within the field

  * combine search terms - Search terms can be combined by using `or and`
  keywords.  Parenthesis can also be used to group search terms. 

  * escape keywords - To find keywords that appear in a VM name use double
  quotes. For example, to find a VM named `free_running`, type `"running"`.

#### Example

Multiple search terms

![screenshot](images/vms_multi_running_combined_terms.png)

### From the Command Line Binary

Not applicable.

## Starting/stoppping Packet Captures

### From the Web-UI

When a valid ipv4 subnet is entered, the `play` button adjacent to the IPv4 label will be enabled.
To start capturing, press the `play` button.

![screenshot](images/vms_multi_capture_start.png)

Once there are valid captures, the `stop` button adjacent to the play button will be enabled.
To stop all the catpures, press the `stop` button.

![screenshot](images/vms_multi_capture_stop.png)

To stop all packet captures for all subnets, the term `capturing` can be entered in the search bar
to find all the VMs with active packet captures.

![screenshot](images/vms_multi_captures_stop_all.png)

### From the Command Line Binary

To start packet captures on running VMs for a specific subnet, use the following command.

```
$> phenix vm capture start-subnet <experiment name> <subnet>
```

To stop all packet captures for a specific subnet, use the following command.

```
$> phenix vm capture stop-subnet <experiment name> <subnet>
```

To stop all packet captures for an experiment, use the following command.

```
$> phenix vm capture stop-all <experiment name>
```

## Stopped Experiment Component

Similar to the Running Experiment component, multiple VMs can be selected
for the Stopped Experiment component.  In addition, VMs in the Stopped
Experiment component can be searched by:

* state - The keyword `dnb` can be used to find all VMs with the 
  `do not boot` flag set to `true`.  Also, the `not` keyword can be used
  to negate search term(s) (i.e. `not dnb`)

* ipv4 address - VMs in a specific subnet can be found by entering the
  subnet (i.e `192.168.2.0/30`)

* other fields (i.e. VM, host, disk) 

* combine search terms - Search terms can be combined by using `or and`
  keywords.  Parenthesis can also be used to group search terms. 

* escape keywords - To find keywords that appear in a VM name use double
  quotes. For example, to find a VM named `dnb_me`, type `"dnb"`.
