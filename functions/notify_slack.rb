require "uri"
require "net/http"
require "json"
require "base64"
require "aws-sdk"

COLORS = {
  "SUCCEEDED" => "good",
  "FAILED" => "danger",
  "FAULT" => "danger",
  "TIMED_OUT" => "danger",
  "STOPPED" => "warning",
}.freeze

def decrypt(encrypted_url)
  client = Aws::KMS::Client.new
  client.decrypt(ciphertext_blob: Base64.decode64(encrypted_url)).plaintext
end

def build_url(region, project, slug)
  region, project, slug = [region, project, slug].map(&URI.method(:encode_www_form_component))
  "https://#{region}.console.aws.amazon.com/codesuite/codebuild/projects/#{project}/build/#{slug}/log"
end

def format(event) # rubocop:disable Metrics/MethodLength
  project = event["detail"]["project-name"]
  status = event["detail"]["build-status"]
  slug = event["detail"]["build-id"].split("/").last

  {
    attachments: [
      {
        color: COLORS[status],
        title: slug,
        title_link: build_url(event["region"], project, slug),
        fallback: status,
        fields: [
          {
            title: "Status",
            value: status,
            short: true,
          },
          {
            title: "Initiator",
            value: event["detail"]["additional-information"]["initiator"],
            short: true,
          },
        ],
      },
    ],
  }
end

def notify_slack(slack_url, payload)
  Net::HTTP.post_form(URI.parse(slack_url), payload: JSON.dump(payload))
end

def lambda_handler(event:, context:)
  slack_url = decrypt(ENV["ENCRYPTED_SLACK_WEBHOOK_URL"])

  payload = {
    channel: ENV["SLACK_CHANNEL"],
    username: ENV["SLACK_USERNAME"],
    icon_emoji: ENV["SLACK_EMOJI"],
  }.merge(format(event))

  notify_slack(slack_url, payload)
end
