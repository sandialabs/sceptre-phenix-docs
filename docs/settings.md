# Settings & Configuration

phēnix supports dynamic configuration management via the `phenix settings` command.
Changes made via this command are applied immediately (hot-swapped) without restarting the service.

## Configuration Files

phēnix looks for a configuration file (e.g. `config.yaml`, `config.json`, `config.toml`) in the following locations:

**When run as root:**
*   `/etc/phenix/config.yaml`

**When run as a regular user:**
*   `$HOME/.config/phenix/config.yaml`
*   `/etc/phenix/config.yaml`

### Example Configuration

```yaml
base-dir:
  minimega: /tmp/minimega
  phenix: /phenix
log:
  level: info
  console: stderr
  system:
    path: /var/log/phenix/phenix.log
store:
  endpoint: bolt:///etc/phenix/store.bdb
ui:
  listen-endpoint: 0.0.0.0:3000
  jwt-signing-key: abcde12345
  logs:
    minimega-path: /var/log/minimega/minimega.log
```

## Configuration vs. Data Store

It is important to distinguish between the **System Configuration** and the **Data Store**:

*   **System Configuration (`config.yaml`)**: Configures the phēnix *daemon* itself. It controls *how* the service runs (e.g., log levels, API ports, storage backend connection strings).
*   **Data Store (BoltDB/etcd)**: Stores the *application state*. It holds *what* phēnix manages (e.g., defined experiments, topologies, user accounts, active VM states).

Deleting `config.yaml` resets daemon behavior to defaults. Deleting the Data Store results in data loss (experiments, users, etc.).

## Store Configuration

The phenix tool uses a key-value data store. By default it uses bbolt but also supports etcd.

*   **bbolt (Default)**: No external dependencies, but only accessible on a single machine.
*   **etcd**: Allows running `phenix` on multiple machines accessing the same data, but requires an external `etcd` service.

To use `etcd`, configure the store endpoint (e.g. `etcd://localhost:2379`) via the config file or `phenix settings set`.

## Managing Settings

```bash
# View all current runtime settings
phenix settings list

# Change log level to debug
phenix settings set log.level debug

# Revert a setting to default
phenix settings unset log.level

# Reset all settings
phenix settings unset --all
```

## Configuration Precedence

phēnix resolves configuration settings in the following order (highest to lowest):

1.  **Command Line Flags**: Arguments passed directly to the binary (e.g., `phenix ui --log.level=debug`).
2.  **Config File**: Settings defined in `config.yaml` (managed via `phenix settings set`).
3.  **Environment Variables**: Variables like `PHENIX_LOG_LEVEL`.
4.  **Defaults**: Internal application defaults.

## Settings Reference

| Setting Key | Environment Variable | Default | Description |
| :--- | :--- | :--- | :--- |
| `log.level` | `PHENIX_LOG_LEVEL` | `info` | Global log verbosity (`debug`, `info`, `warn`, `error`). |
| `log.console` | `PHENIX_LOG_CONSOLE` | `stderr` | Destination for console logs (`stderr`, `stdout`, or a file path). Uses **Text/Human-Readable** format. Note: Setting this to a file path will prevent console logs from appearing in `docker logs`. |
| `log.system.path` | `PHENIX_LOG_SYSTEM_PATH` | `/var/log/phenix/phenix.log` | Path to the persistent system log file (used by UI). Uses **JSON** format. This is independent of `log.console` and is always active. |
| `log.system.max-size` | `PHENIX_LOG_SYSTEM_MAX_SIZE` | `100` | Max size in MB before rotation. |
| `log.system.max-backups` | `PHENIX_LOG_SYSTEM_MAX_BACKUPS` | `3` | Number of old log files to retain. |
| `log.system.max-age` | `PHENIX_LOG_SYSTEM_MAX_AGE` | `90` | Max age in days to retain old logs. |
| `ui.logs.level` | `PHENIX_UI_LOGS_LEVEL` | `""` | Log level for the web UI stream (defaults to `log.level`). |
| `ui.logs.minimega-path` | `PHENIX_UI_LOGS_MINIMEGA_PATH` | `""` | Path to the minimega log file to display in the UI. **(Restart Required)** |
