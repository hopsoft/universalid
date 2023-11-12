# frozen_string_literal: true

module UniversalID::Contrib; end

# A list of all MessagePack types in the preferred registration order
#
# IMPORTANT: More specific types should be registered before more general types
#            because MessagePack will use the first registered type that matches
#            MessagePack scans registered type in linear order and first match wins

require_relative "../../contrib/signed_global_id"
require_relative "../../contrib/global_id"
require_relative "../../contrib/active_record"
