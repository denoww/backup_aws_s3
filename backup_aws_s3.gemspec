# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backup_aws_s3/version'

Gem::Specification.new do |spec|
  spec.name          = "backup_aws_s3"
  spec.version       = BackupAwsS3::VERSION
  spec.authors       = ["Rodrigo Mendonca"]
  spec.email         = ["denoww@gmail.com"]
  spec.summary       = %q{Backup folders storaged in aws s3.}
  spec.description   = %q{Backup folders storaged in aws s3.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "manage_s3_bucket"



  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
end
