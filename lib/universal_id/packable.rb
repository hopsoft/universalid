# frozen_string_literal: true

require "monitor"

module UniversalID::Packable
  extend ActiveSupport::Concern
  extend MonitorMixin

  include GlobalID::Identification

  class_methods do
    delegate :config, to: :UniversalID

    # Finds a UniversalID::Packable instance
    #
    # @param id [UniversalID::Packable, GlobalID, SignedGlobalID, String] the ID to find
    # @param options [Hash] options for the GlobalID or SignedGlobalID parse method
    #                       ignored if the id is not a GlobalID or SignedGlobalID string
    # @return [UniversalID::Packable, nil] the found UniversalID object or nil if no object was found.
    # @raise [UniversalID::LocatorError] if the id cannot be found
    def find(id, options = {})
      value = if id.is_a?(UniversalID::Packable)
        id
      elsif UniversalID.possible_gid_string?(id)
        gid = GlobalID.parse(id, options) || SignedGlobalID.parse(id, options)
        gid&.find
      end
      value || UniversalID::Marshal.load(id)
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

  # Returns a UniversalID string
  #
  # @param options [Hash] options to pass to the `to_packable` method
  # @return [String] the Universal ID of the object.
  def id(**options)
    options = @packable_options || {} if options.blank?
    UniversalID::Marshal.dump to_packable(**options)
  end

  # Converts an object to a UniversalID::Packable
  #
  # @param options [Hash] Options for the conversion process
  # @return [UniversalID::Packable] The object in packable format
  # @raise [NotImplementedError] If the method is not implemented in a subclass
  def to_packable(**options)
    raise NotImplementedError
  end

  # Generates a unique cache key for the object based on its ID
  #
  # @param options [Hash] A hash of options to be passed to the `id` method
  # @return [String] A string that uniquely identifies the object for caching purposes
  def cache_key(**options)
    "#{self.class.name}/#{Digest::MD5.hexdigest(id(**options))}"
  end
end
