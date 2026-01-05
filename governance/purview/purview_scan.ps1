
# Microsoft Purview scan & classification (placeholder script)
param(
  [string]$PurviewAccount,
  [string]$ResourceGroup,
  [string]$StorageAccountName
)

# Login and select subscription
az login
# az account set --subscription <SUB_ID>

# Create datasource for Storage (simulates OneLake shortcut backing store)
az purview data-source create --account-name $PurviewAccount --name $StorageAccountName --type AzureStorage --resource-id   $(az storage account show -n $StorageAccountName -g $ResourceGroup --query id -o tsv)

# Create scan using default rule set
az purview scan create --account-name $PurviewAccount --data-source-name $StorageAccountName --name bootcampScan   --scan-ruleset-type System   --scan-ruleset-name AzureStorage   --collection-name default-collection

# Trigger scan
az purview scan run --account-name $PurviewAccount --data-source-name $StorageAccountName --name bootcampScan

# NOTE: For custom classification, use Purview REST APIs or SDK to upload a custom classification rule.
# Evidence to capture: scan status, asset count, lineage graph, classifications.
