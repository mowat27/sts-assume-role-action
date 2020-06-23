# AWS Session Action

Creates a temporary AWS session and outputs the generated key, secret and 
session token as outputs.

The following environment variables must be set:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `AWS_ASSUME_ROLE_ARN`
