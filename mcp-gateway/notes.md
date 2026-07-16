## Install OpenShift MCP Gateway

- https://docs.redhat.com/en/documentation/red_hat_connectivity_link/1.4/html/installing_the_mcp_gateway
- https://docs.redhat.com/en/documentation/red_hat_connectivity_link/1.4/html/registering_mcp_servers_and_creating_policies/mcp-gateway-register-on-prem-mcp-servers

- Test MCP Gateway:

```bash
curl -X POST https://mcp.aws.joshgav.com/mcp \
  -H "Content-Type: application/json" \
  -d '{"jsonrpc": "2.0", "id": 1, "method": "initialize"}'
```

Add to ~/.config/Code/User/mcp.json:

```json
{
    "servers": {
        "mcp-gateway": {
			"type": "http",
			"url": "https://mcp.aws.joshgav.com/mcp"
		}
    }
}
```