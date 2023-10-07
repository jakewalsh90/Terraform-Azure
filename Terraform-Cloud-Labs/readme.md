This is a collection of Terraform Cloud Labs. 

Follow the pre-reqs below to deploy. 

### Pre reqs:

The following elements need to be added to Terraform Cloud as variables:

#### All Labs
 - admin_id - The admin user id to be added to the Key Vault access policies. 
 - client_id - Service Principal ID
 - client_secret - Service Principal Secret
 - subscription_id - Subscription ID you want to deploy into
 - tenant_id - Tenant ID

#### Lab Specific Variables

##### Core Environment
 - vpn_app_id - ID of the VPN Enterprise Application, see https://learn.microsoft.com/en-us/azure/vpn-gateway/openvpn-azure-ad-tenant
