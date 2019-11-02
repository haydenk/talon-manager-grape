require 'base64'

class AuthenticatedRequest
  include DataMapper::Resource
  include DataMapper::Validations

  property :id, Serial
  property :location, String
  property :field, String
  property :value, String

  belongs_to :scheduled_request, :model => 'ScheduledRequest'
end
