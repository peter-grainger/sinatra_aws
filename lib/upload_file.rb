require 'aws-sdk-s3'  # v2: require 'aws-sdk'
require 'aws-sdk-dynamodb'  # v2: require 'aws-sdk'


# https://docs.aws.amazon.com/sdk-for-ruby/v3/developer-guide/hello.html
class UploadFile
  def call(file)
    bucket_name = ENV.fetch('BUCKET_NAME')
    s3 = Aws::S3::Resource.new(region: ENV.fetch('AWS_REGION', 'eu-west-2'))
    name = File.basename(file.fetch('filename'))
    obj = s3.bucket(bucket_name).object(name)
    obj.upload_file(file.fetch('tempfile'))
    save_to_dynamo(bucket_name, name)
  end

  def save_to_dynamo(bucket_name, file_name)
    dynamodb = Aws::DynamoDB::Client.new(region: ENV.fetch('AWS_REGION', 'eu-west-2'))
    item = {
      bucket: bucket_name,
      Name: file_name
    }

    params = {
      table_name: 'Files',
      item: item
    }

    begin
      dynamodb.put_item(params)
      puts 'Added File reference: ' + bucket_name + ' - ' + file_name
    rescue  Aws::DynamoDB::Errors::ServiceError => error
      puts 'Unable to add file:'
      puts error.message
    end
  end
end
