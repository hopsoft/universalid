# frozen_string_literal: true

require "monitor"

module UniversalID::Packable
  extend ActiveSupport::Concern
  extend MonitorMixin

  include GlobalID::Identification

  class_methods do
    delegate :config, to: :UniversalID

    # Required to satisfy the GlobalID::Identification interface/protocol
    def find(id)
      UniversalID::Marshal.load id
    end
  end

  delegate :config, to: "self.class"
  delegate :synchronize, to: :"UniversalID::Packable"

  # Override GlobalID::Identification methods.
  # We do this support passing `to_packable` options to GlobalID::Identification methods via the `:uid` key.
  gid_methods = %i[
    to_gid
    to_gid_param
    to_global_id
    to_sgid
    to_sgid_param
    to_signed_global_id
  ]
  gid_methods.each do |name|
    define_method name do |options = {}|
      synchronize do
        options = (options || {}).with_indifferent_access
        # Track the object_id of the first invocation of this method because UniversalID::Packable supports
        # recursion and we need to preserve the `to_packable` options for all recursive invocations.
        @packable_object_id ||= object_id
        @packable_options ||= config.merge(options.delete(:uid) || {}) if object_id == @packable_object_id
        super options
      ensure
        # Cleanup when we're at the end of the line (i.e. the actual implementation and not an alias)
        if %i[to_global_id to_signed_global_id].any?(name)
          remove_instance_variable :@packable_object_id
          remove_instance_variable :@packable_options
        end
      end
    end
  end

  # Required to satisfy the GlobalID::Identification interface/protocol
  def id(**options)
    options = @packable_options || {} if options.blank?
    UniversalID::Marshal.dump to_packable(**options)
  end

  # Abstract method to be implemented by including classes
  # to satisfy the UniversalID::Packable interface/protocol
  def to_packable(**options)
    raise NotImplementedError
  end

  def cache_key(**options)
    "#{self.class.name}/#{Digest::MD5.hexdigest(id(**options))}"
  end
end