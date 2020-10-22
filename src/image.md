# Virtual Disk Images Management

This is only available from the command line binary at this time.

## Listing disk images

```
$> phenix image list
```

## Creating a disk image

The [`vmdb2` utility](https://github.com/glattercj/vmdb2) is required 
-- in path -- to create the disk images.

```
$> phenix image create <image name>
```

The `phenix image create --help` will output:

```
Create a disk image configuration

  Used to create a virtual disk image configuration from which to build 
  an image

Usage:
  phenix image create <image name> [flags]

Examples:

  phenix image create <image name>
  phenix image create --size 2G --variant mingui --release xenial --format qcow2 --compress --overlays foobar --packages foo --scripts bar <image name>

Flags:
  -c, --compress                    Compress image after creation (does not apply to raw image)
  -d, --debootstrap-append string   Additional arguments to debootstrap "(default: --components=main,restricted,universe,multiverse)"
  -f, --format string               Format of disk image (default "raw")
  -h, --help                        help for create
  -m, --mirror string               Debootstrap mirror (must match release) (default "http://us.archive.ubuntu.com/ubuntu/")
  -O, --overlays string             List of overlay names (include full path; separated by comma)
  -P, --packages string             List of packages to include in addition to those provided by variant (separated by comma)
  -R, --ramdisk                     Create a kernel/initrd pair in addition to a disk image
  -r, --release string              OS release codename (default "bionic")
  -T, --scripts string              List of scripts to include in addition to the defaults (include full path; separated by comma)
  -s, --size string                 Image size to use (default "5G")
  -v, --variant string              Image variant to use (default "minbase")

Global Flags:
      --base-dir.minimega string   base minimega directory (default "/tmp/minimega")
      --base-dir.phenix string     base phenix directory (default "/phenix")
      --hostname-suffixes string   hostname suffixes to strip
      --log.error-file string      log fatal errors to file (default "/var/log/phenix/error.log")
      --log.error-stderr           log fatal errors to STDERR
      --store.endpoint string      endpoint for storage service (default "bolt:///etc/phenix/store.bdb")
```

The `vmdb2` configuration file can be read by running the following command:

```
$> phenix cfg get image/<image name>
```

## Building a disk image

Building a disk image requires an existing configuration in the store 
(i.e., the `create` command should be run first to create a configuration); 
the `phenix image build --help` will output:

```
Build a virtual disk image
	
  Used to build a new virtual disk using an exisitng configuration; vmdb2 must 
  be in path.

Usage:
  phenix image build <configuration name> [flags]

Examples:

  phenix image build <configuration name>
  phenix image build --very-very-verbose --output </path/to/dir/>

Flags:
  -c, --cache               Cache rootfs as tar archive
      --dry-run             Do everything but actually call out to vmdb2
  -h, --help                help for build
  -o, --output string       Specify the output directory for the disk image to be saved to
  -v, --verbose             Enable verbose output
  -w, --very-verbose        Enable very verbose output
  -x, --very-very-verbose   Enable very verbose output plus additional verbose output from debootstrap

Global Flags:
      --base-dir.minimega string   base minimega directory (default "/tmp/minimega")
      --base-dir.phenix string     base phenix directory (default "/phenix")
      --hostname-suffixes string   hostname suffixes to strip
      --log.error-file string      log fatal errors to file (default "/var/log/phenix/error.log")
      --log.error-stderr           log fatal errors to STDERR
      --store.endpoint string      endpoint for storage service (default "bolt:///etc/phenix/store.bdb")
```

## Miscellaneous Commands

### Append

The disk image management tool will allow you to add packages, overlays, 
and scripts to exisitng configurations using the `append` command. 
Command usage is:

```
$> phenix image append <configuration name> [flags]
```

Flags are for the overlays, packages, and scripts that you want to append. 

### Create From an Existing Configuration

Run this command if you have an existing configuration that you would like 
to use as the base to create a new configuration from. The usage involves 
referencing the existing configuration, the new configuration name, and 
then additional packages, overlays, and scripts. 

```
$> phenix image create-from <existing configuration> <new configuration> [flags]
```

Flags are for the overlays, packages, and scripts that you want to add to 
the new configuration. 

### Delete

```
$> phenix image delete <image name>
```

An alternative could be to use the configuration management tool.

```
$> phenix cfg delete image/<image name>
```

### Remove

The `remove` command will allow you to remove any packages, overlays, 
and scripts from an existing image configuration.

```
$> phenix image remove <configuration name> [flags]
```
Flags are for the overlays, packages, and scripts that you want to remove.

### Update

This `update` command is used to update the script on an existing image 
configuration. The path to a script is tracked in the code. The image 
configuration gets updated with the script in the path; if no changes were 
made no harm. If the path no longer exists, phenix will leave the 
configuration alone.

```
$> phenix image update <configuration name>
```
