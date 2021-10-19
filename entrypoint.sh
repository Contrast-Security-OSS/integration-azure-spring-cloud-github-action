#!/bin/sh -l

# set -x

AZURE_CREDENTIALS_FILE=${1}
CONTRAST_SECURITY_CREDENTIALS_FILE=${2}
AZURE_APPLICATION_NAME=${3}
AZURE_SPRING_CLOUD_SERVICE_NAME=${4}
AZURE_APPLICATION_ARTIFACT_LOCATION=${5}
AZURE_APPLICATION_JVM_OPTIONS=${6}
APPLICATION_MEMORY=${7}
APPLICATION_INSTANCE_COUNT=${8}

# echo "printing environment variables..."
#echo "--------------------------------------------------"
# printenv
#echo "--------------------------------------------------"

# echo "file system..."
# ls -a
# echo "see what is inside the working directory..."
# cd /github/workspace/target
# ls -l
echo "copying input file from host into container file system..."
cp /github/workspace/$AZURE_APPLICATION_ARTIFACT_LOCATION /usr/bin/docker-action/application-artifact.jar
echo "entering docker-action directory..."
cd /usr/bin/docker-action
# echo "what is inside..."
# ls -l

#echo "creating docker image with the following inputs..."
#echo "--------------------------------------------------"
#echo "azure-credentials-file: $AZURE_CREDENTIALS_FILE"
#echo "contrast-security-credentials-file: $CONTRAST_SECURITY_CREDENTIALS_FILE"
#echo "azure-application-name: $AZURE_APPLICATION_NAME"
#echo "azure-spring-cloud-service-name: $AZURE_SPRING_CLOUD_SERVICE_NAME"
#echo "azure-application-artifact-location: $AZURE_APPLICATION_ARTIFACT_LOCATION"
#echo "azure-application-jvm-options: $AZURE_APPLICATION_JVM_OPTIONS"
#echo "application-memory: $APPLICATION_MEMORY"
#echo "application-instance-count: $APPLICATION_INSTANCE_COUNT"
#echo "--------------------------------------------------"

echo "running docker build with passed arguments..."
#echo "--------------------------------------------------"

# here we can make the construction of the image as customizable as we need
# and if we need parameterizable values it is a matter of sending them as inputs
docker build -t docker-action --build-arg azure_application_name="$AZURE_APPLICATION_NAME" --build-arg azure_spring_cloud_service_name="$AZURE_SPRING_CLOUD_SERVICE_NAME" --build-arg azure_application_artifact_location="$AZURE_APPLICATION_ARTIFACT_LOCATION" --build-arg azure_application_jvm_options="$AZURE_APPLICATION_JVM_OPTIONS" --build-arg contrast_security_credentials_file="$CONTRAST_SECURITY_CREDENTIALS_FILE" --build-arg azure_credentials_file="$AZURE_CREDENTIALS_FILE" --build-arg application_memory="$APPLICATION_MEMORY" --build-arg application_instance_count="$APPLICATION_INSTANCE_COUNT" . && docker run docker-action
