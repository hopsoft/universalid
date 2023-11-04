# frozen_string_literal: true

class UniversalID::ActiveRecordPacker
  extend Forwardable

  class << self
    def config
      @config ||= ::UniversalID.config.message_pack.global_id
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

  def prepare_for_packing(record)
    record.attributes
  end
end
