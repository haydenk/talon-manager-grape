require_relative 'authenticated_request'
require_relative 'scheduled_request_path'
module Entities
  class ScheduledRequest < Grape::Entity
    expose :id
    expose :base_uri
    expose :auth_type
    expose :slug_name
    expose :uri_safe_slug_name
    expose :paths, using: Entities::ScheduledRequestPath
    expose :credentials, using: Entities::AuthenticatedRequest
  end
  class ScheduledRequests < Grape::Entity
    present_collection true
    expose :items, using: Entities::ScheduledRequest
  end
end
