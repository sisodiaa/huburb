class NullStorage
  attr_reader :uploader

  def initialize(uploader)
    @uploader = uploader
  end

  def identifier
    uploader.filename
  end

  def store!(_file)
    true
  end

  def retrieve!(_identifier)
    file = Rails.root.join('test', 'fixtures', 'files', 'valid.jpg')
    tmp = Rails.root.join('tmp', 'valid_tmp.jpg')
    FileUtils.cp(file, tmp)
    CarrierWave::SanitizedFile.new(tmp)
  end
end

if Rails.env.test? or Rails.env.cucumber?
  CarrierWave.configure do |config|
    config.enable_processing = false
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      # Configuration for Amazon S3
      region: "ap-south-1",
      provider: "AWS",
      aws_access_key_id: "",
      aws_secret_access_key: ""
    }

    config.fog_directory = "huburb-com"
  end
end
