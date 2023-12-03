# Configure DNS Records

To access the Azure static websites, DNS records need to be configured to map the custom domain names to the Azure storage accounts hosting the sites. There are two methods for configuring this:

### ASVerify Method

The ASVerify method uses a CNAME record that Azure can automatically verify to validate ownership of the domain. 

To use this method:

1. Get the Azure storage account FQDN from the Azure portal
2. Create "asverify" a CNAME record with the format:

   ```
   asverify.st{project}{env}{region_short_name}{site_identifier}.blob.core.windows.net
   ```
   
3. Point the CNAME record to the Azure storage account FQDN

    For example:

    ```
    asverify.mydomain.com.	1	IN	CNAME	asverify.stmrtprweumrt.blob.core.windows.net.
    ```

Azure will auto-verify this record to validate domain ownership.

## Direct CNAME Method

The direct CNAME method uses a regular CNAME record pointing directly to the Azure storage account endpoint.

To use this method:

1. Get the Azure storage account endpoint from the Azure portal
2. Create a CNAME record pointing your domain to the endpoint

    For example:

    ``` 
    mydomain.com.	1	IN	CNAME	stmrtprweumrt.blob.core.windows.net.
    ```

This maps the domain directly without automated Azure verification. Domain ownership will need to be verfied through another method.

Read more about [configuring DNS records for Azure static websites](https://docs.microsoft.com/en-us/azure/storage/blobs/storage-custom-domain-name?tabs=azure-portal#configure-a-cname-record-with-your-dns-provider).

# Terraform Variables
Here is an explanation of how to use the Terraform variables file:

The variables file defines the key configuration parameters for the Terraform configuration.

The `project` and `env` variables set the base project name and environment. These will be used to construct resource names.

The `static_site_config` variable defines static site configuration. Configuration has:

- `identifier` - A unique 4 character ID for the site
- `index_document` - The index page file
- `error_404_document` - The 404 error page  
- `src` - Source folder with the site content
- `domain` - Optional domain configuration
  - `name` - Custom domain name 
  - `asverify_enabled` - Whether to use Azure auto domain verification

The `region` variable sets the Azure region to deploy to.

To use this variable file:

1. Copy `terraform.tfvars.example` to `terraform.tfvars`
2. Update the values in `terraform.tfvars` as needed
3. Run `terraform plan/apply` to deploy infrastructure

The variables file validates inputs, so any errors will be caught during `terraform plan`.
