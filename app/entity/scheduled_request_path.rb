module Entities
  class ScheduledRequestPath < Grape::Entity
    expose :id
    expose :path
    expose :interval
  end
  class ScheduledRequestPaths < Grape::Entity
    present_collection true
    expose :items, using: Entities::ScheduledRequestPath
  end
end
