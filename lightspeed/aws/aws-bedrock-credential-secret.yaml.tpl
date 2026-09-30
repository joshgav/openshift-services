apiVersion: v1
kind: Secret
metadata:
  name: aws-bedrock-credential
  namespace: openshift-lightspeed
type: Opaque
stringData:
  apitoken: ${AWS_BEDROCK_API_KEY}