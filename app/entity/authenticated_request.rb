require_relative 'scheduled_request_path'
module Entities
  class AuthenticatedRequest < Grape::Entity
    expose :id
    expose :location
    expose :field
    expose :value
  end
  class AuthenticatedRequests < Grape::Entity
    present_collection true
    expose :items, using: Entities::AuthenticatedRequest
  end
end
