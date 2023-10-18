# frozen_string_literal: true

module UniversalID::Hydration
  def dehydrate(hash, options)
    include_list = options[:only] || []
    exclude_list = options[:except] || []
    hash.each_with_object({}) do |(key, value), memo|
      key = key.to_s
      next if include_list.any? && include_list.none?(key)
      next if exclude_list.any?(key)
      deep_dehydrate(value, options: options) { |val| memo[key] = val }
    end
  end

  alias_method :deep_transform, :dehydrate
  UniversalID.deprecator.deprecate_methods self, :deep_transform, deep_transform: "Use `dehydrate` instead."

  def hydrate(hash)
    hash.each_with_object({}) do |(key, value), memo|
      deep_hydrate(value) { |val| memo[key] = val }
    end
  end

  private

  def deep_dehydrate(value, options:)
    value = if implements_gid?(value)
      value.to_gid_param
    elsif defined?(ActiveRecord) && value.is_a?(ActiveRecord::Associations::CollectionProxy)
      # fall back to target relation
      deep_dehydrate(value.scope, options: options)
    elsif defined?(ActiveRecord) && value.is_a?(ActiveRecord::Relation)
      value.class.include(UniversalID::RelationIdentification)
      deep_dehydrate(value, options: options)
    else
      case value
      when Array then value.map { |val| deep_dehydrate(val, options: options) }
      when Hash then dehydrate(value, options)
      else value
      end
    end

    if block_given?
      yield value if value.present? || options[:allow_blank]
    end

    value
  end

  def deep_hydrate(value)
    value = if possible_gid_string?(value)
      parse_gid(value) || value
    else
      case value
      when Array then value.map { |val| deep_hydrate(val) }
      when Hash then hydrate(value)
      else value
      end
    end

    value.model_class.extend(UniversalID::RelationIdentification) if value.is_a?(GlobalID) && value.model_class.ancestors.include?(ActiveRecord::Relation)
    value = value.find if value.is_a?(GlobalID)
    yield value if block_given?
    value
  end

  def implements_gid?(value)
    value.respond_to? :to_gid_param
  end
end
