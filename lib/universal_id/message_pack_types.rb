# frozen_string_literal: true

# A list of all MessagePack types in the preferred registration order (specific to general)
# NOTE: More specific type should be registered before more general types
#       because MessagePack will use the first registered type that matches
#       MessagePack scans registered type in linear order and first match wins
types = %w[
  universal_id/uri/uid
  global_id/signed_global_id
  global_id/global_id
  global_id/identification
  ruby/complex
  ruby/rational
  ruby/date_time
  ruby/date
  ruby/time
  ruby/range
  ruby/regexp
  ruby/set
  ruby/open_struct
  ruby/struct
]

types.each { |type| require_relative "message_pack_types/#{type}.rb" }
