# frozen_string_literal: true

module Jsonable
  extend ActiveSupport::Concern

  class_methods do
    def nested_attribute_names
      nested_attributes_options.keys.map(&:to_s)
    end

    def parent_attribute_names
      reflections.each_with_object([]) do |(name, reflection), memo|
        memo << reflection.foreign_key if reflection.macro == :belongs_to
      end
    end

    def timestamp_attribute_names
      all_timestamp_attributes_in_model.dup
    end
  end

  def to_json_hash(**options)
    only = (options[:only] || []).map(&:to_s)
    except = (options[:except] || []).map(&:to_s)

    if options[:copy]
      except << primary_key
      except += parent_attribute_names + timestamp_attribute_names
    end

    attributes.each_with_object({}) do |(key, val), memo|
      next if except.any? && except.include?(key)
      next if only.any? && only.exclude?(key)
      memo[key] = val

      append_nested_attributes(memo) if options[:nested_attributes]
    end
  end

  def to_json(...)
    to_json_hash(...).to_json
  end

  protected

  delegate %i[
    nested_attribute_names
    parent_attribute_names
    primary_key
    timestamp_attribute_names
  ], to: :"self.class"

  private

  def append_nested_attributes(hash)
    nested_attribute_names.each do |name|
      hash["#{name}_attributes"] = send(name).map { |child| child.to_json_hash(**options) }
    end
  end
end
