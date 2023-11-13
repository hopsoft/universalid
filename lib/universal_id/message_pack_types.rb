# frozen_string_literal: true

# A list of all MessagePack types in the preferred registration order
#
# IMPORTANT: More specific types should be registered before more general types
#            because MessagePack will use the first registered type that matches
#            MessagePack scans registered type in linear order and first match wins

require_relative "contrib"

paths = %w[
  message_pack_types/uri/uid/type.rb
  message_pack_types/ruby/composites/set.rb
  message_pack_types/ruby/composites/open_struct.rb
  message_pack_types/ruby/composites/struct.rb
  message_pack_types/ruby/scalars/complex.rb
  message_pack_types/ruby/scalars/rational.rb
  message_pack_types/ruby/scalars/date_time.rb
  message_pack_types/ruby/scalars/date.rb
  message_pack_types/ruby/scalars/range.rb
  message_pack_types/ruby/scalars/regexp.rb
]

paths.each { |path| require_relative path }

UniversalID::MessagePackFactory.create_msgpack_pool
