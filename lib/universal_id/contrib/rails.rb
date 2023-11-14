# frozen_string_literal: true

require_relative "active_record" if defined? ActiveRecord
require_relative "active_support" if defined? ActiveSupport
require_relative "global_id" if defined? GlobalID
require_relative "signed_global_id" if defined? SignedGlobalID
