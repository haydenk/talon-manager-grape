class UrlDownloadRequest
  include DataMapper::Resource
  include DataMapper::Validations

  property :id, Serial
  property :url, Text, :required => true
  property :status, String
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_presence_of :url

  before :save do
    if self.status.nil?
      self.status = 'Pending'
    end
  end

end
