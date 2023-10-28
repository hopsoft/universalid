# frozen_string_literal: true

require_relative "uid"

URI.register_scheme("UID", UniversalID::UID) unless URI.scheme_list.include?("UID")
