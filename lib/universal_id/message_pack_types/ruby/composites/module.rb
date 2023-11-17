# frozen_string_literal: true

using UniversalID::Refinements::KernelRefinement

UniversalID::MessagePackFactory.register(
  type: Module,
  recreate_pool: false,
  packer: ->(obj, packer) { packer.write obj.name },
  unpacker: ->(unpacker) { const_find unpacker.read }
)
