#!/bin/sh
apt-get update
apt-get install jq gettext -y
LOCAL_ESIGNET_PROPERTIES=deployments/configs/esignet.properties
UPDATED_ESIGNET_PROPERTIES=esignet-local.properties

export ESIGNET_HOST=https://$1/esignet/
export API_INTERNAL=https://$1/esignet/
export KEYCLOAK_URL=https://$1/auth/
export SOFTHSM_PIN=$(kubectl get secrets softhsm -n esignet -o jsonpath={.data.security-pin} | base64 --decode)
export KAFKA_URL=kafka-cluster-kafka-bootstrap.kafka:9092
export DB_HOST=$(gcloud sql instances describe $2 --format=json  | jq -r ".ipAddresses[0].ipAddress")
export DB_PORT=5432
export DB_USERNAME=postgres
export DB_PASSWORD=$(gcloud secrets versions access latest --secret $3)

envsubst < $LOCAL_ESIGNET_PROPERTIES  > $UPDATED_ESIGNET_PROPERTIES

kubectl create configmap esignet-local-properties -n esignet  --from-file=$UPDATED_ESIGNET_PROPERTIES


echo "esignet config map created"