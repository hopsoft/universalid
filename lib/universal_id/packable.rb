# frozen_string_literal: true

module UniversalID::Packable
  extend ActiveSupport::Concern

  class_methods do
    # Finds a UniversalID::Packable instance
    #
    # @param id [UniversalID::Packable, GlobalID, SignedGlobalID, String] the ID to find
    # @param options [Hash] options for the GlobalID or SignedGlobalID parse method
    #                       ignored if the id is not a GlobalID or SignedGlobalID string
    # @return [UniversalID::Packable, nil] the found UniversalID object or nil if no object was found.
    # @raise [UniversalID::LocatorError] if the id cannot be found
    # @raise [UniversalID::NotImplementedError]
    def find(id, options = {})
      new UniversalID::PackableObject.find(id, options)
    end
  end

  # Add GlobalID::Identification `to_*` conversion methods
  # All `to_*` methods are delegated to the UniversalID::PackableObject returned by `to_packable`
  # Each GID method accepts the same options as the corresponding GlobalID::Identification method
  # with the addition of a `packable_options: {}` keypair which is passed to `to_packable`
  GlobalID::Identification.public_instance_methods(false).each do |name|
    next if method_defined?(name)
    next unless name.to_s.start_with?("to_")

    method = GlobalID::Identification.instance_method(name)
    args = method.parameters
    next unless args.length == 1
    next unless args.first&.first == :opt

    define_method name do |packable_options: {}, **options|
      to_packable(packable_options).send(name, **options)
    end
  end

  # Converts an object to a UniversalID::PackableObject
  #
  # @param options [Hash] Options for the conversion process
  # @return [UniversalID::PackableObject]
  # @raise [NotImplementedError]
  def to_packable(options = {})
    raise NotImplementedError
  end
end
