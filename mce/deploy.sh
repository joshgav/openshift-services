#! /usr/bin/env bash

this_dir=$(cd $(dirname ${BASH_SOURCE[0]}) && pwd)
root_dir=$(cd ${this_dir}/.. && pwd)
if [[ -e "${root_dir}/.env" ]]; then source ${root_dir}/.env; fi
source ${root_dir}/lib/kubernetes.sh

echo "INFO: install mce operator"
apply_kustomize_dir ${this_dir}/operator
await_resource_ready 'multiclusterengine'

apply_kustomize_dir ${this_dir}/operands

# echo "INFO: install infrastructure management service"
# kustomize build ${this_dir}/assisted | oc apply -f -
# kubectl wait agentserviceconfig/agent --for condition=DeploymentsHealthy --timeout=300s
