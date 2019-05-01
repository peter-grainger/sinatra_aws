# frozen_string_literal: true

require 'aws-sdk-rdsdataservice'

class GetImageList
  def call
    client = Aws::RDS::RDSDataService.new(region: ENV.fetch('AWS_REGION'))
    client.execute_sql(
      aws_secret_store_arn: ENV.fetch('SECRET_STORE'),
      db_cluster_or_instance_arn: ENV.fetch('DATABASE_CLUSTER'),
      sql_statements: 'select * from images'
    )
  end
end
