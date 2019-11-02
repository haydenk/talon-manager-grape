module Entities
  class UrlDownloadRequest < Grape::Entity
    expose :id
    expose :url
    expose :status
    expose :created_at
    expose :updated_at
  end
  class UrlDownloadRequests < Grape::Entity
    present_collection true
    expose :items, using: Entities::UrlDownloadRequest
  end
end
