# frozen_string_literal: true

# A list of all MessagePack types in the preferred registration order (specific to general)
# NOTE: More specific type should be registered before more general types
#       because MessagePack will use the first registered type that matches
#       MessagePack scans registered type in linear order and first match wins
types = %w[
  uri/uid/type
  signed_global_id/type
  global_id/type
  active_record/base/type
  ruby/scalars/complex
  ruby/scalars/rational
  ruby/scalars/date_time
  ruby/scalars/date
  ruby/scalars/range
  ruby/scalars/regexp
  ruby/composites/set
  ruby/composites/open_struct
  ruby/composites/struct
]

types.each { |type| require_relative "message_pack_types/#{type}.rb" }

UniversalID::MessagePackFactory.create_msgpack_pool
