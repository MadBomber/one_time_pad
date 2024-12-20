# frozen_string_literal: true

require_relative "lib/one_time_pad"

Gem::Specification.new do |spec|
  spec.name     = "one_time_pad"
  spec.version  = OneTimePad::VERSION
  spec.authors  = ["Dewayne VanHoozer"]
  spec.email    = ["dvanhoozer@gmail.com"]

  spec.summary  = "A One-Time Pad encryption method for messages."
  spec.description  = <<~DESC
                        This gem provides a casually secure (you will never beat 
                        the pros) implementation of the One-Time Pad 
                        encryption technique, using multiple substitution 
                        cyphers suitable for educational and practical use.
                        Knowing the code, you still have approximately
                        4.3 billion randon seeds to choose from to decode an
                        unknown message.
                      DESC

  spec.homepage = "https://github.com/MadBomber/one_time_pad"
  spec.license  = "MIT"
  spec.required_ruby_version = ">= 3.3"

  spec.metadata = {
    "allowed_push_host" => "https://rubygems.org",
    "homepage_uri"      => spec.homepage,
    "source_code_uri"   => "https://github.com/MadBomber/one_time_pad",
    "changelog_uri"     => "https://github.com/MadBomber/one_time_pad/blob/main/CHANGELOG.md"
  }

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  gemspec     = File.basename(__FILE__)
  spec.files  = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end

  spec.require_paths = ["lib"]
end
