# frozen_string_literal: true

module UniversalID
  def self.config
    @config ||= begin
      options = ActiveSupport::OrderedOptions.new

      # Default options for UniversalID::Hash ................................................................
      options.hash = {
        allow_blank: false,
        allow_list: nil, # applied before block_list when set
        block_list: [
          "id",
          "created_at",
          "updated_at"
        ]
      }

      # Default options for UniversalID::Identification ......................................................
      options.identification = {
        gid: {app: name},
        sgid: {
          app: name,
          expires_in: nil,
          verifier: GlobalID::Verifier.new(
            ENV.fetch("SECRET_KEY_BASE", ENV.fetch("UNIVERSALID_SECRET", name))
          )
        }
      }

      options
    end
  end
end
