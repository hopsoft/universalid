# frozen_string_literal: true

# NOTE: MessagePack scans registered type in linear order and first match wins

# scalars
require_relative "message_pack_types/ruby/scalars/bigdecimal"
require_relative "message_pack_types/ruby/scalars/complex"
require_relative "message_pack_types/ruby/scalars/rational"
require_relative "message_pack_types/ruby/scalars/date_time"
require_relative "message_pack_types/ruby/scalars/date"
require_relative "message_pack_types/ruby/scalars/range"
require_relative "message_pack_types/ruby/scalars/regexp"

# composites
require_relative "message_pack_types/ruby/composites/module"
require_relative "message_pack_types/ruby/composites/open_struct"
require_relative "message_pack_types/ruby/composites/struct"
require_relative "message_pack_types/ruby/composites/set"

# contribs
Dir["#{__dir__}/contrib/**/*message_pack_type.rb"].each { |f| require f }

UniversalID::MessagePackFactory.create_msgpack_pool
