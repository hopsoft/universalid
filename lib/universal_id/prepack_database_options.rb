# frozen_string_literal: true

class UniversalID::PrepackDatabaseOptions
  def initialize(settings)
    @settings = settings
  end

  def to_h
    @settings.to_h
  end

  def include_keys?
    !!@settings.include_keys
  end

  def exclude_keys?
    !include_keys?
  end

  def include_timestamps?
    !!@settings.include_timestamps
  end

  def exclude_timestamps?
    !include_timestamps?
  end

  def include_unsaved_changes?
    !!@settings.include_unsaved_changes
  end

  def exclude_unsaved_changes?
    !include_unsaved_changes?
  end

  def include_descendants?
    depth = @settings.descendant_depth.to_i
    depth_count = @settings.current_descendant_depth_count.to_i

    return false unless !!@settings.include_descendants
    return false unless depth > 0 && depth_count < depth

    true
  end

  def current_descendant_depth_count
    @settings.current_descendant_depth_count ||= -1
  end

  def increment_current_descendant_depth_count!
    @settings.current_descendant_depth_count ||= -1
    @settings.current_descendant_depth_count += 1
  end

  def exclude_descentants?
    !include_descendants?
  end
end
