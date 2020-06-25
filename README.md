# STS Assume Role Action

Creates a temporary AWS session and outputs the generated key, secret and 
session token as outputs.

The following environment variables must be set:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_DEFAULT_REGION`
- `AWS_ASSUME_ROLE_ARN`

The following values will be exported using GitHub Actions [output format](https://help.github.com/en/actions/reference/workflow-commands-for-github-actions#setting-an-output-parameter).

- `AccessKeyId` (for temp session)
- `SecretAccessKey` (for temp session)
- `SessionToken`
- `Expiration`

## Run it locally

Export your AWS credentials and role details.

```sh
export AWS_ACCESS_KEY_ID=AKXXXXXX...
export AWS_SECRET_ACCESS_KEY=YYYYYY...
export AWS_DEFAULT_REGION=eu-west-1
export AWS_ASSUME_ROLE_ARN=arn:aws:iam::012345678901:role/SomeRole
```

Then run the container

```sh
docker run --rm  mowat27/aws-assume-role-action:latest
```
