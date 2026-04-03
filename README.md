# MATLAB + R Starter Template

This project is a starter devcontainer for data analysis and modeling work with:
- MATLAB
- R (managed with `renv`)
- RStudio Server on port `8787`

## What This Repository Is For

Use this template when you want a ready-to-run, reproducible environment for MATLAB + R work in Codespaces (or any Dev Container-compatible setup).

It gives you:
- A preconfigured container image
- Automatic system dependency install
- Automatic R package restore from `renv.lock`
- RStudio Server configured to run inside the container

## Main Files

- `.devcontainer/devcontainer.json`: Dev container definition (image, features, lifecycle commands, forwarded ports)
- `.devcontainer/on-create.sh`: One-time setup during container creation (apt packages + `renv` restore)
- `.devcontainer/post-create.sh`: RStudio runtime configuration and service restart
- `.Rprofile`: Activates `renv` in R sessions
- `renv.lock`: Locked R package versions for reproducibility

## How To Use

1. Open this repo in a new Codespace.
2. Wait for container creation to finish.
3. Open forwarded port `8787` to launch RStudio Server.

## RStudio Login Behavior

RStudio is configured to use PAM login in this template for reliability behind the Codespaces proxy.

Use:
- Username: `root`
- Password: `root`

## Current Effective RStudio Settings

- `auth-none=0`
- `auth-validate-users=1`
- `auth-minimum-user-id=0`
- `server-user=root`
- `rsession-ld-library-path=<R RHOME>/lib:/usr/lib/R/lib` (derived dynamically)

## If Port 8787 Fails

Run:

```bash
rstudio-server test-config
service rstudio-server restart
ps -ef | rg rserver
```
