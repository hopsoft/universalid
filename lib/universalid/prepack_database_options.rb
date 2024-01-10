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

  def include_changes?
    !!@settings.include_changes
  end

  def exclude_changes?
    !include_changes?
  end

  def descendant_depth
    @settings.descendant_depth ||= 0
  end

  attr_writer :current_depth

  def current_depth
    @settings.current_depth ||= 0
  end

  def increment_current_depth!
    @settings.current_depth ||= 0
    @settings.current_depth = @settings.current_depth += 1
  end

  def decrement_current_depth!
    @settings.current_depth ||= 0
    @settings.current_depth = @settings.current_depth -= 1
  end

  def include_descendants?
    !!@settings.include_descendants
  end

  def exclude_descentants?
    !include_descendants?
  end
end
