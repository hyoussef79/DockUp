# frozen_string_literal: true

module Backends
  class Base
    def verify_prerequisites!
      err = "#{self.class.name.gsub(/^.*::/, '')} backend expects \
#{self.class::PREREQUISITES.join(', ')} as environment variables"
      raise(MissingPrerequisitesError, err) unless prerequisites?
    end

    def upload(path)
      entries = Dir.glob(File.join(path, '**'))
      entries.each do |entry|
        entry.gsub!('./', '')
        upload_file(entry) if File.file?(entry)
        upload(entry) if File.directory?(entry)
      end
    end

    private

    def prerequisites?
      self.class::PREREQUISITES.all? do |prereq|
        ENV[prereq.to_s]
      end
    end
  end
end