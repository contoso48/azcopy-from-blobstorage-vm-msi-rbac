# azcopy-from-blobstorage-vm-msi-rbac
AZCOPY from Azure Blob Storage using Azure VM Identity MSI example

An Azure VM using Managed System Identity (MSI) can use AZCOPY to read, write, or sync data from an Azure Blob Storage account and Azure RBAC.   Azure Arc VMs can use System Assigned identity as well as Azure Virtual Desktop Host Pool VMs with EntraID Login. 

This example uses Windows Server as the OS.  Linux VMs in Azure also support System Managed Identity. 

# PREREQUISITES
- Install AZCOPY on the VM in a path that allows it to be executed 
- Ensure the Azure VM has a managed identity configured (either System Assigned or User Managed). In EntraID, this VM name and ObjectID was found under "Devices" and not Users or Groups or Enterprise Apps. 
- Ensure PowerShell is enabled if using Windows to run a task automatically
- Create an Azure Storage Account, a Blob Container (private), and then add a test file to that.  Use Flat Namespace if you want to enable "Container Replication" to other storage accounts  (Oct-2024)
- Assign the Azure RBAC Role called "Storage Blob Data Reader" (or Contributor) to the VM's identity under the scope of either the Blob Container or the storage account, or Resource Group if this should apply to multiple storage accounts.
- Create a local folder as destination for downloading or syncing the cloud storage-based files to.  
        Example:   "mkdir c:\demo"
- Ensure the Azure VM (or other) can reach the Azure Storage account - review network firewall settings on the storage account and ensure no corporate firewalls or proxy is blocking traffic.
- Ensure the Azure VM can reach EntraID URLs to login.  Using Storage Account Key (SAS) does not neede EntraID URL firewall allow access, but this example does require it. 

# TASKS
- Create a script file to run on the VM (Windows PowerShell extension used as example)  
    Example:   **C:\path\azcopyfile.ps1**
- Use the following AZCOPY commands in this script file to "authorize" using the VM's identity and to then "copy" or "sync" files from a blob storage container.  Note that other AZCOPY command options can be used once authorized, not just the "sync" example below  
- **azcopy login --login-type=MSI**
- **``azcopy sync "https://<storageaccountname>.blob.core.windows.net/<containername>" "C:\demo" --recursive  --delete-destination=true``**  


## NOTES on TASKS
- Used "--recursive" to copy the subfolders
- Used "--delete-destination=true" to match the existence or removal of files on the "master" Azure blob storage container.  This is optional, but did confirm that it removes files locally if not present in the blob storage container. 
- Used "--login-type" is new and replaces "--Identity", which may still works until deprecated
- This is not a production-ready example with any error catches nor any monitoring
- Also note that this is not SMB/CIFS and thus does not preserve any NTFS permissions. 
- It uses HTTPS blob transfer, so it is not as latency sensitive as SMB/CIFS traffic

# RUN IN BACKGROUND TASK OPTION
- To run this as a background task using the Windows Task Scheduler, for example, consider these steps
- Open Task Scheduler
- Click on the Windows logo, search for Task Scheduler in the Start menu, and open it.
- Create a New Task
- Click on "Create Basic Task" in the right sidebar  
- Enter a name for the task and click Next.
- Choose "When the computer starts" as the trigger and click Next.  Alternatively, you can use other trigger options of when to run the task, such as when the user logs-in or -out, or on a schedule, etc. 
- Select "Start a program" as the action and click Next.
- In the "Program/script" field, enter **powershell.exe**.
- In the "Add arguments" field, enter **-File "C:\path\azcopyfile.ps1"**
- Click Next and then Finish to create the task.

# LINKS
- https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-blobs-download
- https://learn.microsoft.com/en-us/azure/storage/common/storage-ref-azcopy-copy
- https://learn.microsoft.com/en-us/entra/identity/managed-identities-azure-resources/how-to-assign-managed-identity-via-azure-policy

