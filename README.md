# Credits

Brandon Royal

# Instructions

## Installation with PowerShell

```
git clone https://github.com/friism/azure-test

cd azure-test

Login-AzureRmAccount

.\deploy.ps1
```

This is an interactive script. You will be prompted for:

- the Azure region where resources will be created
- the resource group name (RG will be created if it does not exist)
- the prefix to use for resource names
- your SSH public key for remote access to Linux nodes
- administrator credentials to set
- your Docker Hub credentials

## Setup

1. Find `MGR_UCP_HOSTNAME` in deployment output in Azure portal. Visit this in browser (using `https`) and log in with `admin` and the admin password
2. Visit `/manage/resources/nodes/create` to get the swarm join command
3. Remote-desktop into each worker (the above sample creates just one) and run the join command in PowerShell

Your swarm is now ready to use