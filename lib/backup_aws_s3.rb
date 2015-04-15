require "backup_aws_s3/version"

require 'open3'
require 'manage_s3_bucket'
require 'fileutils'
require 'yaml'

# no docs
class BackupS3
  def initialize(opt = {})
    unless ENV['S3S3MIRROR_PATH'] && ENV['S3_ACCESS_KEY_ID'] && ENV['S3_SECRET_KEY_ID']
      fail 'Not found any of these enviroment variables: S3_ACCESS_KEY_ID, S3_SECRET_KEY_ID, S3S3MIRROR_PATH'
    end
    create opt
  end

  def create(opt = {})
    name   = opt[:name]
    dest   = opt[:dest]
    source = opt[:source]
    keep   = opt[:keep]
    fail 'Missing any of these parameters: name, dest, source or keep' unless name && dest && source && keep
    p "Creating backup: #{name} in #{dest} "
    Open3.popen3('nroff -man') do |stdin, stdout, stderr|
      system "cd #{ENV['S3S3MIRROR_PATH']} && ./s3s3mirror.sh #{source} #{dest}"
      p "Created backup: #{name} in #{dest} "
      BackupS3::Cycler.new(name).cycle!(path: dest, keep: keep)
    end
  end

  # no docs
  class Cycler
    def initialize(name)
      @name = name
    end

    def remove!(directory)
      p "Removing old backup: #{directory}"
      s3 = Manage::S3::new(ENV['S3_ACCESS_KEY_ID'], ENV['S3_SECRET_KEY_ID'])
      s3.remove_path(directory)
      p "Removed old backup: #{directory}"
    end

    def cycle!(opt = {})
      backups = yaml_load.unshift(
        path: opt[:path],
        time: Time.now.strftime('%Y.%m.%d.%H.%M.%S')
      )
      excess = backups.count - opt[:keep].to_i
      if excess > 0
        backups.pop(excess).each do |backup|
          begin
            remove!(backup[:path])
          rescue => err
            p "Error removing old backups: #{err}"
          end
        end
      end
      yaml_save(backups)
    end

    # Returns path to the YAML data file.
    def yaml_file
      @yaml_file ||= begin
        home_path = File.expand_path('~')
        File.join(home_path, 'backup_aws_s3', "#{ @name }.yml")
      end
    end

    # Returns stored Package objects, sorted by #time descending (oldest last).
    def yaml_load
      if File.exist?(yaml_file) && !File.zero?(yaml_file)
        # raise YAML.load_file(yaml_file).inspect
        YAML.load_file(yaml_file).sort_by!{|b| b[:time]}.reverse!
      else
        []
      end
    end

    # Stores the given package objects to the YAML data file.
    def yaml_save(backups)
      FileUtils.mkdir_p(File.dirname(yaml_file))
      File.open(yaml_file, 'w') do |file|
        file.write(backups.to_yaml)
      end
    end
  end
end
