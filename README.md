# Kubernetes Cluster provisioned via Ansible

## Hosts Preparation 🍳
### 🐧 Ubuntu Server
*I personally left everything default except username, hostname and the following steps*
1. SSH Setup stage
    - Select **Install OpenSSH server**
    - Select **Import SSH identity** with selection `from Github`
    - Input your **Github Username** (in my case would be `gyurikol`)
    - I left `unticked` the **Allow password authentication over SSH** option

*... this will install ssh with also adding your Github users **Public Keys** to the Ubuntu Server under the default users `.ssh/authorized_keys` address*

If you forget this step you can fetch the ssh keys with the:
- `ssh-import-id`:
    - install import id utility `apt-get install ssh-import-id`
    - fetch github users public keys `ssh-import-id gh:github_username`
- or just `curl`:
    - `curl https://github.com/<username>.keys`

---

## Setup Steps 🔧
1. Build Ansible Image
    - `docker build --quiet --tag ansible .`
1. Get Public Key from Ansible Image
    - `docker run --rm --entrypoint "cat" ansible "/home/ansibleuser/.ssh/id_rsa.pub"`
    - *copy output to buffer/clipboard for next step*
1. Add Public Key to All Hosts you wish to run Ansible Cluster provison against
    1. `vi /home/${USER}/.ssh/authorized_keys`
    1. ```diff
       + ssh-rsa someFAKEpubKeysomeFAKEpubKey ansibleuser@8906fb83a900 # ansible container
       ```
1. Update `./host_inventory.yml`
    - Update **Standalone** host values if utilizing single & standalone host
    - Update **Master** & **Worker** hosts if utilizing multiple hosts as master and worker nodes

---

## How to Run 🚀
1. Run the `./run.sh` script which will **Build** and **Run** the Ansible Docker image to provision **Standalone**, **Master** & **Worker** Kubernetes Node setups.
