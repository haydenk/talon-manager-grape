module MySinatraApp
  class ScheduledRequestController < Grape::API
    resource :'scheduled-request' do
      desc 'Return a list of scheduled requests'
      get do
        scheduled_requests = ScheduledRequest.all(:order => [ :id.desc ], :limit => 20)
        present scheduled_requests, with: Entities::ScheduledRequests, type: :default
      end

      desc 'Return a single Scheduled Request'
      params do
        requires :id, type: Integer, desc: 'Request ID'
      end
      route_param :id do
        get do
          scheduled_request = ScheduledRequest.get(params[:id])
          unless scheduled_request
            error!("Item not found with ID: #{params[:id]}", 404)
          end
          present scheduled_request, with: Entities::ScheduledRequest, type: :default
        end
      end

      desc 'Create a new Scheduled Request'
      params do
        requires :base_uri, type: String, desc: 'URL for scheduled request'
        optional :auth_type, type: String, desc: 'Authentication Type, defaults to none'
      end
      post do
        unless params[:auth_type]
          params[:auth_type] = 'none'
        end

        uri = URI.parse(params[:base_uri])
        params[:slug_name] = uri.host
        params[:uri_safe_slug_name] = uri.host.gsub(/[.]/, "-")

        if params[:auth_type].downcase == 'basic'
          credentials = params[:credentials]
          params[:credentials] = create_base64_request(credentials[:username], credentials[:password])
        else
          params.delete('credentials')
        end

        scheduled_request = ScheduledRequest.first_or_create({base_uri: params[:base_uri]}, params)
        unless scheduled_request.saved?
          error!('Unable to save scheduled request', 409)
        end
        if scheduled_request.id
          scheduled_request.update(params)
        end
        scheduled_request.create_aws_events

        redirect "/scheduled-request/#{scheduled_request.id}", permanent: true
      end

      desc 'Edit an existing Scheduled Request'
      params do
        requires :base_uri, type: String, desc: 'URL for scheduled request'
        optional :auth_type, type: String, desc: 'Authentication Type, defaults to none'
      end
      route_param :id do
        put do
          scheduled_request = ScheduledRequest.get(params[:id])
          unless scheduled_request.id
            error!("Unable to find Scheduled Request with ID: #{params[:id]}", 404)
          end

          unless params[:auth_type]
            params[:auth_type] = 'none'
          end

          if params[:auth_type].downcase == 'basic'
            credentials = params[:credentials]
            params[:credentials] = create_base64_request(credentials[:username], credentials[:password])
          else
            params.delete('credentials')
          end

          scheduled_request.update(params)

          unless scheduled_request.saved?
            error!('Unable to save scheduled request', 409)
          end
          redirect "/scheduled-request/#{scheduled_request.id}", permanent: true
        end
      end

    end
  end
end
