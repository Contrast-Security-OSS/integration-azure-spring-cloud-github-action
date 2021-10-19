# azure-spring-cloud-github-action

This github action deploys a java application with a Contrast Security Java Agent (JAR) to the Azure Spring Cloud PaaS environment.
If there is an existing application running on the PaaS with the same name as passed by the user via input, the new deployment will override the existing application deployment. Otherwise, a new application with the passed 'application-name' will be created within the Azure Spring Cloud instance prior to the deployment process.

The automation is based off the sideloading solution found at this git repository: https://github.com/selvasingh/spring-petclinic-microservices

## Prerequisites

- A functioning Azure Spring Cloud Instance
- A functioning Spring Configuration Server
- A deployable java application artifact (JAR)
- An Azure Service Principle with enough permissions to:
    - Read and create an Azure Spring Cloud application 
    - Deploy a JAR file to an Azure Spring Cloud application 
- A valid Contrast Security account
- Prepopulated Contrast Security and Azure JSON objects - details within 'Inputs' section

## Inputs
- `contrast-security-configuration-file`
  - REQUIRED: YES
  - Description: "The configuration contents (JSON) for the Contrast Security Java Agent - used to communication with Contrast Security Team Server. 
  - Default: No Default Value
```sh
{
    "contrast_api_url": xxx,
    "contrast_api_username": xxx,
    "contrast_api_api_key": xxx,
    "contrast_api_service_key": xxx,
    "contrast_agent_java_standalone_app_name": xxx,
    "contrast_application_version": xxx
}
```
- `azure-authentication-details-file`
  - REQUIRED: NO
  - Description: "The configuration contents (JSON) for Azure-specific logins, regions, etc...
  - Default: No Default Value
```sh
{
    "azure_application_id": xxx,
    "azure_tenant_id": xxx,
    "azure_client_secret": xxx,
    "azure_subscription_id": xxx,
    "azure_resource_group_name": xxx,
    "azure_region": xxx
}
```
- `application-name`
  - REQUIRED: YES
  - Description: "Name of the application to be deployed to Azure Spring Cloud."
  - Default: No Default Value
- `spring-cloud-service-name`
  - REQUIRED: YES
  - Description: "Azure Spring Cloud service name."
  - Default: No Default Value
- `application-artifact-location`
  - REQUIRED: NO
  - Description: "Location of the deployable application artifact. Location relative to /github/workspace."
  - Default: '/target/*.jar'
- `application-jvm-options`
  - REQUIRED: NO
  - Description: "Deployable application's jvm-options to pass to the Azure Spring Cloud PaaS deployment."
  - Default: No Default Value
- `application-memory`
  - REQUIRED: NO
  - Description: 'Memory allocated to application deployment'
  - Default: '2'
- `application-instance-count`
  - REQUIRED: NO
  - Description: 'Instance count allocated to application deployment'
  - Default: '1'  

## Documentation

Can be found at these links:

> Note: `This section` is to be updated...

## Example Use

```sh
- name: Contrast Security Azure Spring Cloud Deployment
        uses: Contrast-Security-OSS/azure-spring-cloud-github-action@v0.5
        id: contrast-deployment
        with:
          application-name: 'test-application'
          spring-cloud-service-name: 'spring-cloud-test'
          contrast-security-credentials-file: ${{ secrets.CONTRAST_CREDS_FILE }}
          azure-credentials-file: ${{ secrets.AZURE_CREDS_FILE }}
          application-artifact-location: '/target/*.jar'
```

## Development

> Note: `This section` is to be updated...
