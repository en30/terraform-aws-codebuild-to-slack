variable "lambda_function_name" {
  description = "The name of the Lambda function to create"
  default     = "codebuild_to_slack"
}

variable "encrypted_slack_webhook_url" {
  description = "The URL of Slack webhook which is encrypted using the KMS key"
}

variable "slack_channel" {
  description = "The name of the channel in Slack for notifications"
}

variable "slack_username" {
  description = "The username that will appear on Slack messages"
  default = "CodeBuild"
}

variable "slack_emoji" {
  description = "A custom emoji that will appear on Slack messages"
  default     = ":building_construction:"
}

variable "kms_key_arn" {
  description = "ARN of the KMS key used for decrypting slack webhook url"
}
