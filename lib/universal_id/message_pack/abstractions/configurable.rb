# frozen_string_literal: true

module UniversalID::GlobalIDConfigurable
  protected

  # Indicates if the key should be excluded before packing
  def exclude?(key)
    @excludes ||= config.exclude.to_h { |key| [key, true] }
    @excludes[key]
  end

  # Indicates if the key should be included before packing
  def includes?(key)
    @includes ||= config.include.to_h { |key| [key, true] }
    return true if @includes[:include].empty?
    @includes[:include][key]
  end

  # Indicates if we should remove blank values before packing
  def include_blank?
    return @include_blank[:include_blank] if @include_blank
    @include_blank ||= {include_blank: !!config.include_blank}
  end

  # Indicates if we should exclude blank values before packing
  def exclude_blank?
    !include_blank?
  end

  # Indicates if we should preserve unsaved changes before packing
  # Only applies to ActiveRecord models
  def preserve_unsaved_changes?
    !!config.preserve_unsaved_changes
  end

  # Indicates if we should discard unsaved changes before packing
  # Only applies to ActiveRecord models
  def discard_unsaved_changes?
    !preserve_unsaved_changes?
  end
end
