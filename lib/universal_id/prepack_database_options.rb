# frozen_string_literal: true

class UniversalID::PrepackDatabaseOptions
  def initialize(*option_groups)
    @options = UniversalID::Settings.default_copy.prepack.database

    supported_keys = @options.keys
    option_groups.each do |optgroup|
      @options.merge! optgroup.to_h.slice(*supported_keys)
    end

    @include_keys = !!@options.include_keys
    @include_timestamps = !!@options.include_timestamps
    @include_unsaved_changes = !!@options.include_unsaved_changes
    @include_descendants = !!@options.include_descendants
    @descendant_depth = @options.descendant_depth.to_i
  end

  def to_h
    @options.to_h
  end

  def include_keys?
    @include_keys
  end

  def exclude_keys?
    !include_keys?
  end

  def include_timestamps?
    !!@include_timestamps
  end

  def exclude_timestamps?
    !include_timestamps?
  end

  def include_unsaved_changes?
    !!@include_unsaved_changes
  end

  def exclude_unsaved_changes?
    !include_unsaved_changes?
  end

  def include_descendants?
    !!@include_descendants
  end

  def exclude_descentants?
    !include_descendants?
  end

  attr_reader :descendant_depth
end
