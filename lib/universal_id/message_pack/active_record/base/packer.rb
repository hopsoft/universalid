# frozen_string_literal: true

class UniversalID::ActiveRecordBasePacker
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
