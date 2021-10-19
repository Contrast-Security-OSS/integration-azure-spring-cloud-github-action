#!/bin/bash

# set -x

# printenv

echo "creating environment variables from contants..."
export AZURE_ADAL_LOGGING_ENABLED=1
export AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL="https://repository.sonatype.org/service/local/artifact/maven/redirect?r=central-proxy&g=com.contrastsecurity&a=contrast-agent&v=LATEST"
export AZURE_FILE_UPLOAD_ARTIFACT_LOCATION="/spring-upload.jar"
echo "-------------------------------------------"

# echo "mapping environment variables to inputs..."

if [ -z "$CONTRAST_SECURITY_CREDENTIALS_FILE" ]; then
    printf '%s\n' "No Contrast Security credentials file passed via input." >&2
    exit 1
else
    echo "$CONTRAST_SECURITY_CREDENTIALS_FILE" >> contrast.json
#    echo "contrast_security_credentials_file value:"
#    cat contrast.json
#    cat contrast.json | jq '.'
    echo "Contrast Security credentials file found"
    echo "parsing configuration file and setting to environment variables..."
#    echo "quick test"
#    echo "-----------"
#    cat contrast.json | jq -r '.contrast_api_url'
    echo "mapping..."
    export CONTRAST_API_URL=$(cat contrast.json | jq -r '.contrast_api_url')
    export CONTRAST_API_USERNAME=$(cat contrast.json | jq -r '.contrast_api_username')
    export CONTRAST_API_API_KEY=$(cat contrast.json | jq -r '.contrast_api_api_key')
    export CONTRAST_API_SERVICE_KEY=$(cat contrast.json | jq -r '.contrast_api_service_key')
    export CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME=$(cat contrast.json | jq -r '.contrast_agent_java_standalone_app_name')
    export CONTRAST_APPLICATION_VERSION=$(cat contrast.json | jq -r '.contrast_application_version')
    echo "parsing and mapping complete."
#    echo "removing contrast.json..."
    rm -f contrast.json
    echo "-----------------------------"
fi

# echo "results:"
# echo "contrast-api-url: $CONTRAST_API_URL"
# echo "contrast-api-username: $CONTRAST_API_USERNAME"
# echo "contrast-api-api-key: $CONTRAST_API_API_KEY"
# echo "contrast-api-service-key: $CONTRAST_API_SERICE_KEY"
# echo "contrast-agent-java-standalone-app-name: $CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME"
# echo "contrast-application-version: $CONTRAST_APPLICATION_VERSION"
# echo "---------------------------------"

if [ -z "$AZURE_CREDENTIALS_FILE" ]; then
    printf '%s\n' "No Azure credentials file passed via input." >&2
    exit 1
else
    echo "$AZURE_CREDENTIALS_FILE" >> azure.json
#    echo "azure_credentials_file value:"
#    cat azure.json
#    cat azure.json | jq '.'
    echo "Azure configuration file found"
    echo "parsing configuration file and setting to environment variables..."
#    echo "quick test"
#    echo "-----------"
#    cat azure.json | jq -r '.azure_tenant_id'
    echo "mapping..."
    export AZURE_APPLICATION_ID=$(cat azure.json | jq -r '.azure_application_id')
    export AZURE_TENANT_ID=$(cat azure.json | jq -r '.azure_tenant_id')
    export AZURE_CLIENT_SECRET=$(cat azure.json | jq -r '.azure_client_secret')
    export AZURE_SUBSCRIPTION_ID=$(cat azure.json | jq -r '.azure_subscription_id')
    export AZURE_REGION=$(cat azure.json | jq -r '.azure_region')
    export AZURE_RESOURCE_GROUP_NAME=$(cat azure.json | jq -r '.azure_resource_group_name')
    # export AZURE_SP_SERVICE_NAME=$(cat azure.json | jq -r '.azure_spring_cloud_service_name')
    echo "parsing and mapping complete."
#    echo "removing azure.json..."
    rm -f azure.json
    echo "-----------------------------"
fi

# echo "results:"
# echo "azure-application-id: $AZURE_APPLICATION_ID"
# echo "azure-tenant-id: $AZURE_TENANT_ID"
# echo "azure-client-secret: $AZURE_CLIENT_SECRET"
# echo "azure-subscription-id: $AZURE_SUBSCRIPTION_ID"
# echo "azure-region: $AZURE_REGION"
# echo "azure-resource-group-name: $AZURE_RESOURCE_GROUP_NAME"
# echo "azure-sp-service-name: $AZURE_SP_SERVICE_NAME"
# echo "---------------------------------"

# echo "printing environment variables for testing..."
# printenv
# echo "-------------------------------------------"

# install spring-cloud extension into azure cli
echo "++installing azure spring-cloud extension into azure cli..."
az extension add --name spring-cloud;
echo "++successfully installed spring-cloud extension"
echo "-------------------------------------------"

# log into azure cli using service principal and secret
echo "++logging into azure cli..."
az login --service-principal -u "${AZURE_APPLICATION_ID}" -p "${AZURE_CLIENT_SECRET}" --tenant "${AZURE_TENANT_ID}"; 
echo "++successfully logged into azure cli"
echo "-------------------------------------------"

# set subscription for cli interaction
echo "++setting subscription to cli interaction..."
az account set --subscription "${AZURE_SUBSCRIPTION_ID}"; 
echo "++successfully set subscription to cli interaction"
echo "-------------------------------------------"

# configure default resource group for spring cloud interaction on cli
echo "setting default resource group for spring cloud interaction..."
az configure --defaults group="${AZURE_RESOURCE_GROUP_NAME}" spring-cloud="${AZURE_SP_SERVICE_NAME}"; 
echo "successfully set default resource group for spring cloud interaction"
echo "-------------------------------------------"

# create spring cloud application and assign specs
echo "creating spring cloud application..."
# az spring-cloud app create --name "${AZURE_APPLICATION_NAME}" --service "${AZURE_SP_SERVICE_NAME}" -g ${AZURE_RESOURCE_GROUP_NAME} --instance-count 1 --is-public true --memory 2 --jvm-options='-Xms2048m -Xmx2048m' --enable-persistent-storage true --assign-endpoint;
az spring-cloud app create --name "${AZURE_APPLICATION_NAME}" --instance-count "${APPLICATION_INSTANCE_COUNT}" --is-public true --memory "${APPLICATION_MEMORY}" --jvm-options='-Xms2048m -Xmx2048m' --enable-persistent-storage true
echo "successfully created spring cloud application"
echo "-------------------------------------------"

# deploy sample file-upload jar into the Azure Spring Cloud application
echo "deploying sample file-upload jar..."
az spring-cloud app deploy --name "${AZURE_APPLICATION_NAME}" --jar-path "${AZURE_FILE_UPLOAD_ARTIFACT_LOCATION}" --verbose
echo "successfully deployed sample file-upload jar"
echo "-------------------------------------------"

# get application endpoint for jar upload
echo "retrieving endpoint information..."
AZURE_APPLICATION_URL="https://${AZURE_SP_SERVICE_NAME}-${AZURE_APPLICATION_NAME}.azuremicroservices.io"
echo ${AZURE_APPLICATION_URL}
echo "successfully retrieved endpoint information"
echo "-------------------------------------------"

# download constrast security jar file
echo "downloading contrast security java agent jar file..."
curl -L "${AZURE_CONTRAST_JAVA_AGENT_DOWNLOAD_URL}" -o contrast.jar
echo "successfully downloaded contrast security java agent jar file"
echo "-------------------------------------------"

# echo "checking file system..."
# ls -l
# echo "-------------------------------------------"

# upload contrast Security jar file into application using file-upload jar
# this is where the nodejs puppeteer script runs
echo "running puppet-upload.js script..."
node puppet-upload.js --url "${AZURE_APPLICATION_URL}" --headless false --contrast-upload-file 'contrast.jar'
echo "puppet-upload.js script successfully completed."
echo "-------------------------------------------"

# wait for script to complete - 10 seconds
echo "waiting for 10 seconds..."
sleep 10s;
echo "sleep concluded. continue processing..."
echo "------------------------------------------"

# if user doesn't pass any application jvm options, then just append the contrast security java agent location, else append the contrast java agent location with a space between the passed jvm options the user passes via input
if [ -z "$AZURE_APPLICATION_JVM_OPTIONS" ]; then
    echo "No user-defined application jvm options passed"
    echo "using -javaagent:/persistent/apm/contrast.jar..."
    END_RESULT_AZURE_APPLICATION_JVM_OPTIONS="-javaagent:/persistent/apm/contrast.jar"
else
    echo "user passed in application-specific jvm options outside of contrast deployment"
    echo "appending contrast java agent location to user input..."
    END_RESULT_AZURE_APPLICATION_JVM_OPTIONS="${AZURE_APPLICATION_JVM_OPTIONS} -javaagent:/persistent/apm/contrast.jar"
fi

END_JVM_OPTIONS="$END_RESULT_AZURE_APPLICATION_JVM_OPTIONS"

# deploy sample file-upload jar into the Azure Spring Cloud application
echo "deploying application jar..."
az spring-cloud app deploy --name ${AZURE_APPLICATION_NAME} --jar-path application-artifact.jar --jvm-options="${END_JVM_OPTIONS}" --env CONTRAST__API__URL=${CONTRAST_API_URL} CONTRAST__API__USER_NAME=${CONTRAST_API_USERNAME} CONTRAST__API__API_KEY=${CONTRAST_API_API_KEY} CONTRAST__API__SERVICE_KEY=${CONTRAST_API_SERVICE_KEY} CONTRAST__AGENT__JAVA__STANDALONE_APP_NAME=${CONTRAST_AGENT_JAVA_STANDALONE_APP_NAME} CONTRAST__APPLICATION__VERSION=${CONTRAST_APPLICATION_VERSION} CONTRAST__AGENT__LOGGER__STDERR=true --verbose
echo "successfully deployed application jar"
echo "-------------------------------------------"

# get application endpoint for jar upload
echo "retrieving endpoint information..."
#az spring-cloud app show --name "${AZURE_APPLICATION_NAME}" | grep url
echo ${AZURE_APPLICATION_URL}
echo "successfully retrieved endpoint information"
echo "-------------------------------------------"
