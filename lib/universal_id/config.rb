# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= begin
      options = ActiveSupport::OrderedOptions.new

      # Default options for UniversalID::HashWithGID .........................................................
      options.hash_with_gid = {
        allow_blank: false,
        allow_list: [], # applied before block_list
        block_list: []
      }

      options
    end
  end
end
