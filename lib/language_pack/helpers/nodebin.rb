require "json"

class LanguagePack::Helpers::Nodebin
  DEFAULT_NODE_VERSION = "24.13.0"
  YARN_VERSION = "1.22.22"

  NODE_LTS_VERSIONS = {
    "20" => "20.20.2",
    "22" => "22.16.0",
    "24" => "24.13.0",
  }.freeze

  def self.resolve_node_version
    return ENV["NODE_VERSION"] if ENV["NODE_VERSION"]

    if File.exist?("package.json")
      pkg = JSON.parse(File.read("package.json")) rescue {}
      constraint = pkg.dig("engines", "node")
      if constraint
        major = constraint.match(/(\d+)/)&.[](1)
        return NODE_LTS_VERSIONS[major] if major && NODE_LTS_VERSIONS.key?(major)
      end
    end

    DEFAULT_NODE_VERSION
  end

  def self.hardcoded_node_lts(arch:)
    version = resolve_node_version
    arch = "x64" if arch == "amd64"
    {
      "number" => version,
      "url" => "https://nodejs.org/download/release/v#{version}/node-v#{version}-linux-#{arch}.tar.gz"
    }
  end

  def self.hardcoded_yarn
    {
      "number" => YARN_VERSION,
      "url" => "https://heroku-nodebin.s3.dualstack.us-east-1.amazonaws.com/yarn/release/yarn-v#{YARN_VERSION}.tar.gz"
    }
  end

  def self.node_lts(arch:)
    hardcoded_node_lts(arch: arch)
  end

  def self.yarn
    hardcoded_yarn
  end
end
