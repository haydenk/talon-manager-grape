require 'aws-sdk-cloudwatchevents'

class ScheduledRequest
  include DataMapper::Resource
  include DataMapper::Validations

  property :id, Serial
  property :base_uri, Text, :required => true
  property :auth_type, String
  property :slug_name, String
  property :uri_safe_slug_name, String

  has n, :paths, 'ScheduledRequestPath'
  has 1, :credentials, 'AuthenticatedRequest'

  after :update do
    if auth_type == 'none' and credentials
      credentials.destroy
    end
  end

  def create_aws_events
    begin
      puts "start aws event"
      cwe = Aws::CloudWatchEvents::Client.new
      sqs = Aws::SQS::Client.new
      queue_url = sqs.get_queue_url({ queue_name: 'url-download-requests' })

      rule_name = "#{uri_safe_slug_name}-scheduled-event".downcase.gsub(/\s/, '-')
      rule = cwe.put_rule({
                       name: rule_name,
                       schedule_expression: "rate(5 minutes)",
                       state: "ENABLED",
                       description: rule_name,
                   })
      rule_arn = rule[:rule_arn]
      cwe.put_targets({
                          rule: rule_name,
                          targets: generate_targets('arn:aws:sqs:us-east-1:686695453355:url-download-requests')
                      })
      # cwe.put_permission({
      #     action: 'events:PutEvents',
      #     principal: '*',
      #     statement_id: "AWSEvents_#{rule_name}",
      # })
      sqs.add_permission({
          queue_url: queue_url.queue_url.to_s,
          aws_account_ids: ['events.amazonaws.com'],
          label: "AWS Event #{rule_name}",
          actions: ['SendMessage']
                         })

    rescue Aws::CloudWatchEvents::Errors::ServiceError => e
      puts e.message
    end
  end

  def rule_name(path)
    path = path.gsub(/[\/\s]/, '')
    "#{slug_name}-#{path}scheduled-event".downcase.gsub(/[\s.]/, '-')
  end

  def generate_targets(arn)
    targets = []
    input = {
        uri: base_uri,
        auth_type: auth_type,
        slug_name: slug_name
    }
    targets.push({id: id.to_s, arn: arn, input: input.to_json})
    targets
  end
end
