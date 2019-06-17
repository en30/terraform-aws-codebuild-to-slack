# terraform-aws-codebuild-to-slack
This is a terraform module to notify CodeBuild evnets to Slack.
![example](https://i.gyazo.com/a6c00090c6c8771f679c46c56a2e6172.png)

## Usage
### terraform 0.12.x
```terraform
variable "encrypted_slack_webhook_url" {}

resource "aws_kms_key" "slack_webhook_url" {
  description = "Key for Slack Webhook URL"
}

module "codebuild_notification" {
  source  = "en30/codebuild-to-slack/aws"
  version = "~> 0.1.1"

  encrypted_slack_webhook_url = var.encrypted_slack_webhook_url
  slack_channel               = "#app"
  kms_key_arn                 = aws_kms_key.slack_webhook_url.arn
}
```

### terraform 0.11.x
```terraform
variable "encrypted_slack_webhook_url" {}

resource "aws_kms_key" "slack_webhook_url" {
  description = "Key for Slack Webhook URL"
}

module "codebuild_notification" {
  source  = "en30/codebuild-to-slack/aws"
  version = "0.0.1"

  encrypted_slack_webhook_url = "${var.encrypted_slack_webhook_url}"
  slack_channel               = "#app"
  kms_key_arn                 = "${aws_kms_key.slack_webhook_url.arn}"
}
```


The `encrypted_slack_webhook_url` is an encrypted slack incoming webhook url using a KMS key whose arn is `kms_key_arn`.
You can get `encrypted_slack_webhook_url` as follows.
```console
$ aws kms encrypt --key-id $AWS_KMS_KEYID --plaintext $SLACK_WEBHOOK_URL --query CiphertextBlob --output text
```

## Inputs
| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| encrypted_slack_webhook_url | The encrypted URL of Slack webhook | string | - | yes |
| kms_key_arn | ARN of the KMS key used for decrypting slack webhook url | string | - | yes |
| slack_channel | The name of the destination Slack channel | string | - | yes |
| lambda_function_name | The name of the Lambda function to create | string | `codebuild_to_slack` | no |
| slack_emoji | A custom emoji that will appear on Slack messages | string | `:building_construction:` | no |
| slack_username | The username that will appear on Slack messages | string | `CodeBuild` | no |
