apiVersion: v1
kind: Secret
metadata:
  name: openshiftai-credential
  namespace: openshift-lightspeed
type: Opaque
stringData:
  apitoken: ${OPENSHIFT_OPENAI_API_KEY}