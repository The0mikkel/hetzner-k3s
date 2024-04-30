# Hetzner k3s

This directory, contains a template and guide to use [hetzner-k3s](https://github.com/vitobotta/hetzner-k3s), which is a software package to spin up k3s on Hetzner Cloud.

## Requirements

You need the following services available:

- Hetzner Cloud (and project)
- Cloudflare (and DNS zone)

You need the following tools installed:

- [OpenTofu](https://opentofu.org/) ([Terraform](https://www.terraform.io/))
- [hetzner-k3s](https://github.com/vitobotta/hetzner-k3s)
- [kubectl](https://kubernetes.io/docs/tasks/tools/)

## Setup cluster

In order to set up the cluster, [Hetzner-k3s](https://github.com/vitobotta/hetzner-k3s) is used, which is a software package to spin up k3s on Hetzner Cloud.

To use this, you first have to fill out the template in `hetzner-k3s/template.yml` with your own values.  

First start by copying the template file into a new file, e.g. `config.yml`:

```bash
cp hetzner-k3s/template.yml hetzner-k3s/config.yml
```

Then fill out the values in the `config.yml` file.

To create the cluster, you can then use the following command (command uses example config file name):

```bash
cd hetzner-k3s
hetzner-k3s create --config config.yml
```

In order to delete the cluster again you can use the following command (command uses example config file name):

```bash
cd hetzner-k3s
hetzner-k3s delete --config config.yml
```
