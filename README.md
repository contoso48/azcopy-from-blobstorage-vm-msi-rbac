# azcopy-from-blobstorage-vm-msi-rbac
AZCOPY from Azure Blob Storage using Azure VM Identity MSI example

An Azure VM using Managed System Identity (MSI) can use AZCOPY to read, write, or sync data from an Azure Blob Storage account and Azure RBAC.   Azure Arc VMs can use System Assigned identity as well as Azure Virtual Desktop Host Pool VMs with EntraID Login. 

This example uses Windows Server as the OS.  Linux VMs in Azure also support System Managed Identity. 

PREREQUISITES
- Install AZCOPY on the VM in a path that allows it to be executed 
- Ensure the Azure VM has a managed identity configured (either System Assigned or User Managed). In EntraID, this VM name and ObjectID was found under "Devices" and not Users or Groups or Enterprise Apps. 
- Ensure PowerShell is enabled if using Windows to run a task automatically
- Create an Azure Storage Account, a Blob Container, and then add a test file to that.  Use Flat Namespace if you want to enable "Container Replication" to other storage accounts  (Oct-2024)
- Assign the Azure RBAC Role called "Storage Blob Data Reader" (or Contributor) to the VM's identity under the scope of either the Blob Container or the storage account, or Resource Group if this should apply to multiple storage accounts. 


Create a script file to run on the VM (Windows PowerShell extension used as example):
- Example:   **C:\path\azcopyfile.ps1**

Use the following AZCOPY commands in this script file to "authorize" using the VM's identity and to then "copy" or "sync" files from a blob storage container.  Note that other AZCOPY command options can be used once authorized, not just the "sync" example below.
**azcopy login --login-type=MSI
azcopy sync https://<storageaccountname>.blob.core.windows.net/<containername> "C:\temp" --recursive  --delete-destination=true**


NOTES
Used "--recursive" to copy the subfolders
Used "--delete-destination=true" to match the existence or removal of files on the "master" Azure blob storage container.  This is optional, but did confirm that it removes files locally if not present in the blob storage container. 
"--login-type" is new and replaces "--Identity".  


BACKGROUND TASK 
To run this as a background task using the Windows Task Scheduler, for example, consider these steps: 
Open Task Scheduler:
- Click on the Windows logo, search for Task Scheduler in the Start menu, and open it.
Create a New Task:
• Click on "Create Basic Task" in the right sidebar.
• Enter a name for the task and click Next.
• Choose "When the computer starts" as the trigger and click Next.  Alternatively, you can use other trigger options of when to run the task, such as when the user logs-in or -out, or on a schedule, etc. 
• Select "Start a program" as the action and click Next.
• In the "Program/script" field, enter **powershell.exe**.
• In the "Add arguments" field, enter **-File "C:\path\azcopyfile.ps1"**
• Click Next and then Finish to create the task.


REFERNCE LINKS
- https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-blobs-download
- https://learn.microsoft.com/en-us/azure/storage/common/storage-ref-azcopy-copy
