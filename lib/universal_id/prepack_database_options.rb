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
    !!@settings.include_descendants
  end

  def exclude_descentants?
    !include_descendants?
  end

  def descendant_depth
    @descendant_depth.to_i
  end
end
