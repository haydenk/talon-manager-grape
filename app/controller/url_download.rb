module MySinatraApp
  class UrlDownloadRequestController < Grape::API
    resource :'url-download' do
      desc 'Return a list of url download requests'
      get do
        urls = UrlDownloadRequest.all(:order => [ :id.desc ], :limit => 20)
        present urls, with: Entities::UrlDownloadRequests, type: :default
      end

      desc 'Return a single URL Download Request'
      params do
        requires :id, type: Integer, desc: 'Request ID'
      end
      route_param :id do
        get do
          url = UrlDownloadRequest.get(params[:id])
          unless url
            error!("Item not found with ID: #{params[:id]}", 404)
          end
          present url, with: Entities::UrlDownloadRequest, type: :default
        end
      end

      desc 'Create a new URL Download Request'
      params do
        requires :url, type: String, desc: 'URL to download'
      end
      post do
        url = UrlDownloadRequest.first_or_create(params)
        unless url.saved?
          error!('Unable to save url request', 409)
        end
        redirect "/url-download/#{url.id}", permanent: true
      end

    end
  end
end
