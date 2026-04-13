# OpenShift AI

## Model Serving

- Install OpenShift AI Operator
- Install DataScienceCluster with `.spec.components.kserve.managementState=Managed`
- Create a MachineSet with GPU nodes
- Install additional operators
    - Red Hat Connectivity Link
    - Red Hat build of Leader Worker Set
    - Node Feature Discovery Operator
        - And create a NodeFeatureDiscovery instance
    - Nvidia GPU Operator
        - And create a ClusterPolicy
- Create a Model Deployment in OpenShift AI
- Manifests for creating an inference service
    - TODO: enable auth and route (?)
    - ./resources/hardwareprofile.yaml
    - ./resources/servingruntime.yaml
    - ./resources/inferenceservice.yaml


- To test (set your token and URL):

```
cluster_domain=
inference_url=https://redhat-gpt-oss-20b-llm.apps.${cluster_domain}
token=
curl -s ${inference_url}/v1/chat/completions \
    -H "Authorization: Bearer ${token}" \
    -H "Content-Type: application/json" \
    -d '{
          "model": "redhat-gpt-oss-20b",
          "messages": [{"role": "user", "content": "explain RBAC"}]
        }'
```

### Fixes

- For Nvidia GPU Operator: To fix problem with DCGM Exporter, need to disable CDI on OpenShift:

```
kubectl patch clusterpolicies.nvidia.com/gpu-cluster-policy --type='json' \
  -p='[{"op": "replace", "path": "/spec/cdi/enabled", "value":false}]'
```

## Resources

- https://ai-on-openshift.io/
- https://docs.nvidia.com/datacenter/cloud-native/openshift/latest/
- https://github.com/redhat-ai-services/modelcar-catalog