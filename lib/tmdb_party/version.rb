require "yaml"
module TMDBParty
  class Version
    def Version.data; YAML.load_file( File.join(File.dirname(__FILE__), "..", "..", "VERSION.yml")); end

    def Version.major; data[:major]; end
    def Version.minor; data[:minor]; end
    def Version.patch; data[:patch]; end
  end

  VERSION = [ Version.major, Version.minor, Version.patch ].join "."
end
