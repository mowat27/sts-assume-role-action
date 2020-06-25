#!/usr/bin/env sh

if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || 
   [ -z "$AWS_DEFAULT_REGION" ] || [ -z "$AWS_ASSUME_ROLE_ARN" ] ; then
  cat >&2 <<EOF
ERROR : The following environment variables must be set:
- AWS_ACCESS_KEY_ID
- AWS_SECRET_ACCESS_KEY
- AWS_DEFAULT_REGION
- AWS_ASSUME_ROLE_ARN
EOF
  exit 1
fi 

export PAGER=''
session_name=${AWS_ROLE_SESSION_NAME:-temp-session}
temp_role=$(aws sts assume-role \
     --role-arn "$AWS_ASSUME_ROLE_ARN" \
     --role-session-name "$session_name")

echo "::set-output name=AccessKeyId::$(echo "$temp_role" | jq -r .Credentials.AccessKeyId)"
echo "::set-output name=SecretAccessKey::$(echo "$temp_role" | jq -r .Credentials.SecretAccessKey)"
echo "::set-output name=SessionToken::$(echo "$temp_role" | jq -r .Credentials.SessionToken)"
echo "::set-output name=Expiration::$(echo "$temp_role" | jq -r .Credentials.Expiration)"

