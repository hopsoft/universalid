# frozen_string_literal: true

# NOTE: MessagePack scans registered type in linear order and first match wins

# scalars
require_relative "message_pack_types/scalars/bigdecimal"
require_relative "message_pack_types/scalars/complex"
require_relative "message_pack_types/scalars/rational"
require_relative "message_pack_types/scalars/date_time"
require_relative "message_pack_types/scalars/date"
require_relative "message_pack_types/scalars/range"
require_relative "message_pack_types/scalars/regexp"

# composites
require_relative "message_pack_types/composites/module"
require_relative "message_pack_types/composites/open_struct"
require_relative "message_pack_types/composites/struct"
require_relative "message_pack_types/composites/set"

# extensions
Dir["#{__dir__}/extensions/**/*.rb"].sort.each { |f| require f }

UniversalID::MessagePackFactory.create_msgpack_pool
