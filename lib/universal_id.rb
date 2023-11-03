# frozen_string_literal: true

# stdlib
require "base64"
require "cgi"
require "digest/md5"
require "forwardable"
require "monitor"
require "singleton"
require "uri"

# 3rd party gems
require "brotli"
require "msgpack"

# internal
require_relative "universal_id/refinements"
require_relative "universal_id/version"
require_relative "universal_id/config"
require_relative "universal_id/encoder"
require_relative "universal_id/uri/uid"
require_relative "universal_id/message_pack_factory"
require_relative "universal_id/active_record_encoder"

if URI.respond_to? :register_scheme
  URI.register_scheme "UID", UniversalID::URI::UID unless URI.scheme_list.include?("UID")
else
  # shenanigans to support Ruby 3.0.X
  URI::UID = UniversalID::URI::UID
  URI.scheme_list["UID"] = URI::UID
end
