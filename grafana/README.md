# Grafana on OpenShift

- Install the Grafana Operator (community) in namespace `grafana` (./operator.yaml)
- Create a Grafana instance named `grafana` (./grafana.yaml)
- Create a ServiceAccount named `grafana`
- Bind ServiceAccount `grafana` to `cluster-monitoring-view` role
- Create openshift-thanos GrafanaDataSource (./datasource.yaml)