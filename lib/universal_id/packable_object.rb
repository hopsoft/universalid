# frozen_string_literal: true

class UniversalID::PackableObject
  extend ActiveSupport::Concern
  include GlobalID::Identification

  class << self
    # Finds a UniversalID::Packable instance
    #
    # @param id [UniversalID::Packable, GlobalID, SignedGlobalID, String] the ID to find
    # @param options [Hash] options for the GlobalID or SignedGlobalID parse method
    #                       ignored if the id is not a GlobalID or SignedGlobalID string
    # @return [UniversalID::Packable, nil] the found UniversalID object or nil if no object was found.
    # @raise [UniversalID::LocatorError] if the id cannot be found
    def find(id, options = {})
      value = id if id.is_a?(UniversalID::PackableObject)

      if UniversalID.possible_gid_string?(id)
        gid = GlobalID.parse(id, options) || SignedGlobalID.parse(id, options)
        value = gid&.find
      end

      value || UniversalID::Marshal.load(id)
    end
  end

  attr_reader :object

  def initialize(object)
    @object = object
  end

  # Returns a UniversalID string
  #
  # @return [String] the Universal ID of the object.
  def id
    UniversalID::Marshal.dump object
  end

  # Generates a unique cache key for the object based on its ID
  #
  # @return [String] A string that uniquely identifies the object for caching purposes
  def cache_key
    "#{self.class.name}/#{Digest::MD5.hexdigest(id)}"
  end
end
