#!/bin/sh
apt-get update
apt-get install jq gettext -y
LOCAL_MOCK_IDENTITY_PROPERTIES=deployments/configs/mock-identity-system-default.properties
UPDATED_MOCK_IDENTITY_PROPERTIES=mock-identity-system-default.properties


export DB_HOST=$(gcloud sql instances describe $1 --format=json  | jq -r ".ipAddresses[0].ipAddress")
export DB_PORT=5432
export DB_USERNAME=postgres
export DB_PASSWORD=$(gcloud secrets versions access latest --secret $2)

envsubst < $LOCAL_MOCK_IDENTITY_PROPERTIES  > $UPDATED_MOCK_IDENTITY_PROPERTIES

kubectl create configmap mock-identity-properties -n esignet  --from-file=$UPDATED_MOCK_IDENTITY_PROPERTIES


echo "mock identity config map created"


