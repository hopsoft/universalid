# frozen_string_literal: true

# NOTE: MessagePack scans registered type in linear order and first match wins

# scalars
require_relative "message_pack_types/ruby/scalars/complex"
require_relative "message_pack_types/ruby/scalars/rational"
require_relative "message_pack_types/ruby/scalars/date_time"
require_relative "message_pack_types/ruby/scalars/date"
require_relative "message_pack_types/ruby/scalars/range"
require_relative "message_pack_types/ruby/scalars/regexp"

# composites
require_relative "message_pack_types/ruby/composites/open_struct"
require_relative "message_pack_types/ruby/composites/struct"
require_relative "message_pack_types/ruby/composites/set"

# uid
require_relative "message_pack_types/uri/uid/type"

# contribs
require_relative "contrib/rails" if defined? Rails

UniversalID::MessagePackFactory.create_msgpack_pool
