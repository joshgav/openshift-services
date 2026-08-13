## Docs

- https://opendatahub-io.github.io/models-as-a-service/latest/install/maas-setup/
- o11y - https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/managing_openshift_ai/managing-observability_managing-rhoai
- how to use routes and avoid LoadBalancer - https://github.com/opendatahub-io/models-as-a-service/blob/main/docs/samples/gateway-patterns/clusterip-route-reencrypt/README.md

- redhatai/ministral - `--max-model-len=147936`

## Tips

Must be set on maas-default-gateway:

```yaml
apiVersion: gateway.networking.k8s.io/v1
kind: Gateway
metadata:
  annotations:
    opendatahub.io/managed: 'false'
    security.opendatahub.io/authorino-tls-bootstrap: 'true'
```

## Authorino

- from: https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/deploy_models_using_distributed_inference_with_llm-d/configuring-authentication-for-llmd_distributed-inference
- and: https://docs.redhat.com/en/documentation/red_hat_openshift_ai_self-managed/3.4/html/govern_llm_access_with_models-as-a-service/deploy-and-manage-models-as-a-service_maas#configure-tls-for-maas_maas-deploy

```bash
oc annotate svc/authorino-authorino-authorization  service.beta.openshift.io/serving-cert-secret-name=authorino-server-cert -n kuadrant-system

oc apply -f - <<EOF
apiVersion: operator.authorino.kuadrant.io/v1beta1
kind: Authorino
metadata:
  name: authorino
  namespace: kuadrant-system
spec:
  replicas: 1
  clusterWide: true
  listener:
    tls:
      enabled: true
      certSecretRef:
        name: authorino-server-cert
  oidcServer:
    tls:
      enabled: false
EOF
```

## Helpers

```bash
## for core LLMInferenceService
base_url=https://ai.apps.ipi.aws.joshgav.com
# model=redhat-gpt-oss-20b
model=redhat-ministral
url=${base_url}/llm/${model}

token=$(oc whoami -t)

## for MaaS
base_url=https://maas.apps.ipi.aws.joshgav.com
# model=redhat-ministral
model=redhat-gpt-oss-20b
url=${base_url}/llm/${model}
# subscription=ministral
subscription=gpt-oss-20b

response=$(curl -sSk \
  -H "Authorization: Bearer $(oc whoami -t)" \
  -H "Content-Type: application/json" \
  -X POST \
  -d "{\"name\": \"key-from-terminal\", \"description\": \"requested via  terminal\", \"expiresIn\": \"1d\", \"subscription\": \"${subscription}\"}" \
  "${base_url}/maas-api/v1/api-keys") && \
token=$(echo ${response} | jq -r .key) && \
echo "API key obtained: ${token:0:20}..."

curl -sSk ${base_url}/maas-api/v1/models \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${token}" | jq

## the following apply to any token

curl ${url}/v1/models -H "Authorization: Bearer ${token}" | jq

curl -s ${url}/v1/chat/completions \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d "{
        \"model\": \"${model}\",
        \"messages\": [{\"role\": \"user\", \"content\": \"Can you help?\"}]
    }" | jq

curl -s ${url}/v1/chat/completions \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d "{
        \"model\": \"${model}\",
        \"messages\": [{\"role\": \"user\", \"content\": \"Can you help?\"}],
        \"stream\": \"true\"
    }" | jq

while true; do
    curl -s ${url}/v1/chat/completions \
        -H "Authorization: Bearer ${token}" \
        -H "Content-Type: application/json" \
        -d "{
            \"model\": \"${model}\",
            \"messages\": [{\"role\": \"user\", \"content\": \"Can you help?\"}],
            \"stream\": true
        }"
done

## fails as unauthorized (-v to see 401)
curl -v -H "Content-Type: application/json" \
  -d "{\"model\": \"${model}\", \"messages\": [{\"role\": \"user\", \"content\": \"Hello\"}], \"max_tokens\": 50}" \
  "${url}/v1/chat/completions"

curl ${url}/v1/responses \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer ${token}" \
  -d '{
    "model": "${model}",
    "instructions": "You are a concise assistant.",
    "input": "How does photosynthesis work?"
  }'
```
