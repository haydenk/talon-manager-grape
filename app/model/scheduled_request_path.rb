class ScheduledRequestPath
  include DataMapper::Resource
  include DataMapper::Validations

  property :id, Serial
  property :path, Text, :required => true
  property :interval, String

  belongs_to :scheduled_request, :model => 'ScheduledRequest'
end
