# BackupAwsS3

Backup s3 folders to another s3

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'backup_aws_s3'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install backup_aws_s3

## Pre-Requisites Installss

### Install s3s3mirror

In your terminal

    $ cd ~
    $ git clone git@github.com:cobbzilla/s3s3mirror.git
    $ sudo apt-get install s3cmd

Insert you aws keys

    $ s3cmd --configure


    $ sudo touch /var/log/s3s3mirror.log
    $ sudo chmod 777 /var/log/s3s3mirror.log

## Create Enviroment Variables in /etc/enviroments

    export S3_BUCKET_BACKUP="xxxxxxxxxxx"
    export S3_ACCESS_KEY_ID="xxxxxxxxxxx"
    export S3_SECRET_KEY_ID="xxxxxxxxxxx"
    export S3S3MIRROR_PATH='/home/USERNAME/s3s3mirror'

## Usage

    $ ruby backup_uploads.rb identification_name source dest keep
    
    source and dest are: bucket_name/folder/subfolder...

### Example

    $ ruby backup_uploads.rb "app1_last_30_days"    "scproduction/" "${S3_BUCKET_BACKUP}/upload_files/app1/$(date +%Y.%m.%d.%H.%M.%S)/" 30
    $ ruby backup_uploads.rb "app1_20_in_20_minuts" "scproduction/" "${S3_BUCKET_BACKUP}/upload_files/erp/$(date +%Y.%m.%d.%H.%M.%S)/" 216

## Feel free to put commands above in crontab

## Contributing

1. Fork it ( https://github.com/[my-github-username]/backup_aws_s3/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
