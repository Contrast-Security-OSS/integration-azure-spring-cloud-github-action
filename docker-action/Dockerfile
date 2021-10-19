FROM mcr.microsoft.com/azure-cli

ARG azure_spring_cloud_service_name
ARG azure_application_name
ARG azure_application_artifact_location
ARG azure_application_jvm_options
ARG contrast_security_credentials_file
ARG azure_credentials_file
ARG application_memory
ARG application_instance_count

ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=true
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV AZURE_APPLICATION_JVM_OPTIONS ${azure_application_jvm_options}
ENV AZURE_APPLICATION_NAME ${azure_application_name}        
ENV AZURE_APPLICATION_ARTIFACT_LOCATION ${azure_application_artifact_location} 
ENV AZURE_SP_SERVICE_NAME ${azure_spring_cloud_service_name}   
ENV CONTRAST_SECURITY_CREDENTIALS_FILE ${contrast_security_credentials_file}
ENV AZURE_CREDENTIALS_FILE ${azure_credentials_file}
ENV APPLICATION_MEMORY ${application_memory}
ENV APPLICATION_INSTANCE_COUNT ${application_instance_count}

COPY entrypoint-az.sh /entrypoint.sh
COPY file-demo-0.0.1-SNAPSHOT.jar /spring-upload.jar
COPY package.json /package.json
COPY puppet-upload.js /puppet-upload.js
COPY application-artifact.jar /application-artifact.jar

RUN apk update && apk add --no-cache nodejs npm jq chromium nss freetype harfbuzz ca-certificates ttf-freefont && npm install
# RUN ls -l

ENTRYPOINT ["/entrypoint.sh"]
