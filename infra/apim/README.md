
# APIM ↔ FastAPI Connection

1. Deploy FastAPI (Container Apps or App Service) and capture the HTTPS base URL, e.g. `https://fsi-api.azurecontainerapps.io`.
2. In `infra/bicep/main.bicep`, set `serviceUrl` on the `fsi-api` resource to the FastAPI base URL.
3. (Optional) Add private endpoints to the FastAPI host and attach APIM to the same VNET.
4. Global policy enforces `rate-limit 60/min` and CORS. API policy enforces `30/min per IP`.
5. Use APIM subscription keys or JWT validation as needed (add `<validate-jwt>` to policies).
