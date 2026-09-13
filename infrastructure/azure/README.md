# Azure infrastructure

This directory defines the target AKS platform with Bicep. It is a new, parallel platform; it does not modify or delete the existing `aks-eduhamuy` cluster.

## Target topology

All resources are intended for `eastus2`:

```text
eduhamuy-platform-vnet (10.240.0.0/16)
├── subnet-aks (10.240.0.0/20)
├── subnet-appgateway (10.240.16.0/24)
├── subnet-postgres-devtest (10.240.17.0/24)
└── subnet-postgres-prod (10.240.18.0/24)
```

The template creates one AKS cluster with Application Routing enabled, a private PostgreSQL Flexible Server for DEV/TEST, another for PROD, the Keycloak databases, and a Private DNS zone. Keycloak data must remain separate from EduHamuy domain data.

## Important safety notes

- Do not run a deployment until the resource names, CIDRs, SKU, Kubernetes version, backup policy and monthly budget have been reviewed.
- The PostgreSQL administrator passwords are secure deployment parameters. Never commit them or place them in a `.bicepparam` file.
- The template is not yet the migration cutover. Existing AKS, Argo CD, Gateway, Cloudflare records and resource groups remain untouched.
- PostgreSQL subnet delegation and Flexible Server API properties must be validated with `what-if` before the first deployment.

## Validate without deploying

```bash
az bicep build --file infrastructure/azure/main.bicep
az deployment group what-if \
  --resource-group rg-eduhamuy \
  --template-file infrastructure/azure/main.bicep \
  --parameters location=eastus2 \
               postgresDevTestAdminPassword='<provide-securely>' \
               postgresProdAdminPassword='<provide-securely>'
```

For a real deployment, pass the password through a secure prompt or CI secret. Do not paste it into shell history or commit it to Git.
