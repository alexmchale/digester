# The ENV key names we expect
access_key_name = "AWS_ACCESS_KEY_ID"
secret_key_name = "AWS_SECRET_ACCESS_KEY"

# Read the AWS credentials
access_key = ENV[access_key_name]
secret_key = ENV[secret_key_name]

# Verify that we received them
if access_key.blank? || secret_key.blank?
  raise("please specify #{ access_key_name } and #{ secret_key_name } in ENV")
end

# Set the S3 details.
$s3_bucket   = "digester-io"
$s3_base_url = "http://#{ $s3_bucket }.s3.amazonaws.com/"

# Instantiate the Fog connection to S3
$s3 =
  Fog::Storage.new({
    :provider                 => 'AWS'      ,
    :aws_access_key_id        => access_key ,
    :aws_secret_access_key    => secret_key ,
  }).directories.get($s3_bucket)
