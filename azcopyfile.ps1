azcopy login --login-type=MSI
azcopy sync https://<storageaccountname>.blob.core.windows.net/<containername> "C:\demo" --recursive  --delete-destination=true
