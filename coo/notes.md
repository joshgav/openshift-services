## Tests

Try with single-cluster metrics:

```bash
export THANOS_URL=$(oc get route thanos-querier -n openshift-monitoring -o jsonpath='{.spec.host}')
export TOKEN=$(oc whoami --show-token)

curl -X POST "https://${THANOS_URL}/api/v1/query" \
  -H "Authorization: Bearer ${TOKEN}" \
  --data-urlencode 'query=cluster_version'
```

Try with multi-cluster metrics:

```bash
export THANOS_URL=$(oc get route -n open-cluster-management-observability rbac-query-proxy -o  jsonpath='{.spec.host}')
export TOKEN=$(oc whoami --show-token)

curl -X POST "https://${THANOS_URL}/api/v1/query" \
  -H "Authorization: Bearer ${TOKEN}" \
  --data-urlencode 'query=cluster_version'
```