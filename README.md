# Ansible
#### Playbooks designed to assist with the installation of checkmarx agents. These plays help reduce the amount of time it takes to get the package onto the system. The plays are not designed to install the agent since the agent goes through a GUI in which ansible does not support.

## Requirements
- Install [Homebrew](https://brew.sh/)
- Install [Python3](https://docs.python-guide.org/starting/install3/osx/). Can be install with [Homebrew](https://brew.sh/).

#### Installing ansible on MacOS
```$ brew install ansible```

#### Install ansible windows modules
```$ ansible-galaxy collection install community.windows```

## Setting Up Vault Password
Vault passwords are used when playbooks are executed. The playbook will use your vault password to retrieve any secrets needed to run the playbook. The `ansible.cfg` expects the VAR `$ANSIBLE_VAULT_PASSWORD_FILE` to retrieve the password and decrypt the vault secrets. Luckily we automated this process to retrieve the Vault password from [Conjour](https://secrets.cisco.com). This will create a `.vault_pass` in the root directory of your application.

### Executing the script
- Login [Conjour](https://secrets.cisco.com) and navigate to `nonprod/it/code-checkmarx-automation/checkmarx-vault`.
- Select `checkmarx-webapp` and click `Reset API Key`. A new API key will be generated!
- Make the shell script executable:
```chmod +x scripts/create-vault-file.sh```

- Run the script and enter the api key as shown below.
```
code-checkmarx-automation git:(main) ✗ source ./scripts/create-vault-file.sh
Please enter your API key:
```
 You are now ready to run playbooks!!! (ノ◕ヮ◕)ノ*:・゚✧

## Running playbooks
 Playbooks have been developed for ease of use within the environment. An Inventory of hosts has been created in order to deploy to the envrionment you wish.

 > **NOTE** : Use brackets `[:]` in the hosts variable to select the specific hosts you wish to deploy to.

### Deploying into Staging
There are two different methods to deploy into staging.

1. Deploy to all checkmarx staging servers. This is the default way as it will deploy to the `staging-checkmarx` hosts group.
```
$ ansible-playbook playbooks/install-agent.yml
```

2. Deploy to specific staging hosts
hosts group.
```
$ ansible-playbook playbooks/install-agent.yml -e host='cxm-agt-[001:003]-s.cisco.com'
```

### Deploying into production
There are two different methods to deploy into production. `production-checkmarx` is the inventory group that contains all production hosts.

1. Deploy to all checkmarx production servers.
```
$ ansible-playbook playbooks/install-agent.yml -e host='production-checkmarx'
```
2. Deploy to specific production hosts.
```
$ ansible-playbook playbooks/install-agent.yml -e host='cxm-ctr-[001:003]-p.cisco.com'
```

### You are now ninja certified to run playbooks for checkmarx. 🥷😎
