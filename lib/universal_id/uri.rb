# frozen_string_literal: true

module UniversalID::URI; end
require_relative "uri/uid"
URI.register_scheme("UID", UniversalID::URI::UID) unless URI.scheme_list.include?("UID")
