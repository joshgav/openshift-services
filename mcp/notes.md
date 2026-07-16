## Install OpenShift MCP Server

- https://docs.redhat.com/en/documentation/openshift_container_platform/4.22/html/ai_applications/mcp-server

```bash
helm repo add openshift-helm-charts https://charts.openshift.io/

helm upgrade -i -n openshift-mcp-server --create-namespace openshift-mcp-server \
    openshift-helm-charts/redhat-openshift-mcp-server \
    --set "config.toolsets={core,config,helm,metrics,netedge}" \
    --set "ingress.host=openshift-mcp.apps.ipi.aws.joshgav.com" \
    --set "openshift=true" \
    --set-json 'rbac.extraClusterRoleBindings=[{"name":"use-view-role","roleRef":{"name":"view","external":true}}]'
```

Add to ~/.config/Code/User/mcp.json:

```json
{
    "servers": {
		"openshift-remote": {
			"type": "http",
			"url": "https://openshift-mcp.apps.ipi.aws.joshgav.com/mcp"
		}
    }
}
```