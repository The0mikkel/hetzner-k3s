# hetzner-k3s

## Pre-requisites

The following software needs to be installed on your local machine:

- [Terraform](https://www.terraform.io/downloads.html) / [OpenTofu](https://opentofu.org)
- [Packer](https://developer.hashicorp.com/packer/tutorials/docker-get-started/get-started-install-cli#installing-packer) (For initial setup of snapshots for the servers)
- [Kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/) (For interacting with the Kubernetes cluster)
- [hcloud cli tool](https://github.com/hetznercloud/cli) (For interacting with the Hetzner Cloud API)
- SSH client (For connecting to the servers)

The following services are required, in order to deploy the Kubernetes cluster:

- [Hetzner Cloud](https://www.hetzner.com/cloud) account
- [Hetzner Cloud API Token](https://console.hetzner.cloud/projects) (For authenticating with the Hetzner Cloud API)
- [Cloudflare](https://www.cloudflare.com/) account
- [Cloudflare API Token](https://dash.cloudflare.com/profile/api-tokens) (For authenticating with the Cloudflare API)
- [Cloudflare controlled domain](https://dash.cloudflare.com/) (For allowing the system to allocate a domain for the Kubernetes cluster)

### SSH keys

In order to connect to the servers, you need to have an SSH key pair. The keys path needs to be set in the tfvars file.

*The SSH key should be ssh-ed25519 or rsa-sha2-512 (for easy use, passphrase-less)*  
`ssh-keygen -t ed25519`

## Running the setup

### Cluster 

Setup the cluster in `/cluster` directory.

#### Initial setup - Creation of snapshots

In order to create the cluster, we need to create snapshots of the servers that will be used in the cluster. This is done by running the following command (say yes, to build snapshots using packer):

```bash	
tmp_script=$(mktemp) && curl -sSL -o "${tmp_script}" https://raw.githubusercontent.com/kube-hetzner/terraform-hcloud-kube-hetzner/master/scripts/create.sh && chmod +x "${tmp_script}" && "${tmp_script}" && rm "${tmp_script}"
```
**Note:** This will create a snapshot of the server, which will be used as the base image for the Kubernetes cluster, as well as ensuring local software is installed.  
*The software has been provided by the [kube-hetzner](https://github.com/kube-hetzner/terraform-hcloud-kube-hetzner) project.*

#### Cluster setup

Configure the `tfvars/template.tfvars` file with the required values.

Then run the following command to create the Kubernetes cluster:

```bash
tofu init
tofu apply --var-file tfvars/template.tfvars
```

Now, watch the cluster being created.

### Content

Setup the content of the cluster in `/content` directory.

Configure the `tfvars/template.tfvars` file with the required values.

Then run the following command to create the Kubernetes cluster:

```bash
tofu init
tofu apply --var-file tfvars/template.tfvars
```

Now, watch the content being deployed.
