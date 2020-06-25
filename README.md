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
docker run --rm -t \
		-e AWS_ACCESS_KEY_ID \
		-e AWS_SECRET_ACCESS_KEY \
		-e AWS_DEFAULT_REGION \
		-e AWS_ASSUME_ROLE_ARN \
		mowat27/sts-assume-role-action:latest
```

## Example workflow

This push workflow builds a [pulumi](https://pulumi.com) stack using temporary credentials created by this container.  The principle applies to anything else that needs AWS credentials though.

Secrets are stored as [repository secrets](https://help.github.com/en/actions/configuring-and-managing-workflows/creating-and-storing-encrypted-secrets) in GitHub.

```yaml
name: Pulumi up
on: [push]
jobs:
  api_deployment:
    runs-on: ubuntu-latest
    name: Deploy API
    steps:
      - uses: actions/checkout@v2
        with:
          fetch-depth: 1
      - name: Make temp session on AWS
        id: sts-assume-role
        uses: docker://mowat27/sts-assume-role-action
        env:
          AWS_ACCESS_KEY_ID: ${{ secrets.AWS_ACCESS_KEY_ID }}
          AWS_SECRET_ACCESS_KEY: ${{ secrets.AWS_SECRET_ACCESS_KEY }}
          AWS_ASSUME_ROLE_ARN: ${{ secrets.AWS_ASSUME_ROLE_ARN }}
          AWS_DEFAULT_REGION: eu-west-1
      - uses: docker://pulumi/actions
        with:
          args: up --yes
        env:
          AWS_ACCESS_KEY_ID: ${{ steps.sts-assume-role.outputs.AccessKeyId }}
          AWS_SECRET_ACCESS_KEY: ${{ steps.sts-assume-role.outputs.SecretAccessKey }}
          AWS_SESSION_TOKEN: ${{ steps.sts-assume-role.outputs.SessionToken }}
          AWS_REGION: eu-west-1
          PULUMI_ACCESS_TOKEN: ${{ secrets.PULUMI_ACCESS_TOKEN }}
          PULUMI_CI: up
```