apiVersion: v1
kind: Secret
metadata:
  name: rhoai-credential
  namespace: openshift-lightspeed
type: Opaque
stringData:
  apitoken: ${RHOAI_API_KEY}