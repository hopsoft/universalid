# frozen_string_literal: true

class UniversalID::PortableHash < Hash
  include UniversalID::Portable
  extend UniversalID::Hydration

  class << self
    def config
      super.portable_hash.with_indifferent_access
    end

    def find(id)
      compressed_json = Base64.urlsafe_decode64(id)
      hydrate JSON.parse(Zlib::Inflate.inflate(compressed_json))
    rescue => error
      raise UniversalID::LocatorError.new(id, error)
    end
  end

  delegate :config, to: :"self.class"
  attr_reader :options

  def initialize(hash)
    @options = merge_options!(extract_options!(hash))
    merge! self.class.dehydrate(hash, options)
  end

  def id
    compressed_json = Zlib::Deflate.deflate(to_json, Zlib::BEST_COMPRESSION)
    Base64.urlsafe_encode64 compressed_json, padding: false
  end

  private

  def extract_options!(hash)
    options = hash.delete(:portable_hash_options) || hash.delete("portable_hash_options") || {}
    options = options.each_with_object({}) do |(key, val), memo|
      memo[key.to_sym] = val.is_a?(Array) ? val.map(&:to_s) : val
    end
    options.with_indifferent_access
  end

  def merge_options!(options)
    config.each do |key, val|
      default = config[key]
      custom = options[key]

      if default.is_a?(Array)
        custom = [] if custom.nil?
        custom = custom.is_a?(Array) ? custom : [custom]
        options[key] = (default + custom).uniq
      else
        options[key] = custom || default
      end
    end

    options
  end
end
