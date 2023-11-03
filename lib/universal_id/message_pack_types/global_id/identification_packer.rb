# frozen_string_literal: true

class UniversalID::GlobalIDIdentificationPacker
  using ::UniversalID::Refinements::Kernel
  using ::UniversalID::Refinements::Hash

  attr_reader :object

  # NOTE: The object is unavailable when unpacking
  def initialize(object = nil)
    @object = object
  end

  def pack_with(packer)
    hash = prepack || {}
    hash.deep_transform_keys!(&:to_s)
    apply_changes! hash
    remove_primary_key! hash

    packer.write object.class.name
    packer.write object.id if active_record?
    packer.write hash
  end

  def unpack_with(unpacker)
    class_name = unpacker.read
    id = unpacker.read
    hash = unpacker.read || {}

    klass = const_find(class_name)
    object = (id && active_record?(klass)) ? klass&.find_by(klass.primary_key.to_sym => id) : klass&.new
    object&.tap do |o|
      hash.each { |key, val| o.public_send "#{key}=", val if o.respond_to?("#{key}=") }
    end
  end

  private

  def options
    UniversalID.config.message_packer.dig :global_id, :identification
  end

  def prepack
    return {} if active_record? && reject_changes?
    object.public_send(prepack_method_name).tap do |hash|
      pattern = Regexp.union(regexp_filters) if regexp_filters.any?
      filters = string_filters
      hash.reject! { |key, _| pattern&.match?(key) || filters.include?(key) }
    end
  end

  def active_record_defined?
    defined? ActiveRecord::Base
  end

  def active_record?(klass = nil)
    return false unless active_record_defined?
    object&.is_a?(::ActiveRecord::Base) || klass&.descends_from?(::ActiveRecord::Base)
  end

  # TODO: add support for composite primary keys
  def primary_key
    return nil unless active_record?
    object.id
  end

  # TODO: add support for composite primary keys
  def remove_primary_key!(hash)
    return unless active_record?
    hash.delete "id"
    hash.delete object.class.primary_key.to_s
  end

  def keep_changes?
    return false unless active_record?
    return false unless object.changed?
    return true if object.new_record?
    !!options.dig(:active_record, :keep_changes)
  end

  def reject_changes?
    !keep_changes?
  end

  def apply_changes!(hash)
    return unless active_record?
    index = reject_changes? ? 0 : 1
    changes = object.changes_to_save.each_with_object({}) do |(attr, changeset), memo|
      memo[attr.to_s] = changeset[index]
    end
    hash.merge! changes
  end

  def prepack_method_name
    options[:prepack_method_name] || :attributes
  end

  def filters
    options[:filters] || []
  end

  def regexp_filters
    filters.select { |f| f.is_a? ::Regexp }
  end

  def string_filters
    filters.reject { |f| f.is_a?(::Regexp) }.map(&:to_s)
  end
end
