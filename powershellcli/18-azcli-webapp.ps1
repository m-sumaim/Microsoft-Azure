$ResourceGroupName = "rg-az104-dev-eus"
$Location          = "centralus"
$AppServicePlan    = "asp-web-dev-plan-01"
$WebAppName        = "app-web-dev01"

az appservice plan create `
--resource-group $ResourceGroupName `
  --location $Location `
  --name $AppServicePlan `
  --sku F1 `
  --is-linux

az webapp create `
--resource-group $ResourceGroupName `
--name $WebAppName `
--plan $AppServicePlan `
--runtime "PHP:8.3"