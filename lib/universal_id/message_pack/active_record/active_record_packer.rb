# frozen_string_literal: true

require_relative "../global_id/configurable"

class UniversalID::ActiveRecordPacker
  extend Forwardable
  include UniversalID::GlobalIDConfigurable

  class << self
    def config
      @config ||= ::UniversalID.config.message_pack.active_record
    end
  end

  def_delegators :"self.class", :config
  attr_reader :record

  def initialize(record = nil)
    @record = record
  end

  # Packs the object using a MessagePack::Packer
  def pack_with(packer)
    packer.write record.class.name
    packer.write prepare_for_packing(record)
  end

  private

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

  def prepare_for_packing(record)
    record.attributes
  end

  def prepare_attributes_for_packing(attributes)
    attributes.each_with_object({}) do |(key, val), memo|
      key = key.to_s
      next if excludes[key]
      next if !includes.empty? && includes[key]
      next if exclude_blank? && val.nil? || val.respond_to?(:empty?) && val.empty?

      val = record.changes_to_save[key].first if discard_unsaved_changes?
      memo[key] = val.is_a?(::Hash) ? prepare_for_packing(val) : val
    end
  end
end
