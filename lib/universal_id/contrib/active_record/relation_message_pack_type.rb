# frozen_string_literal: true

# TODO: Revisit ActiveRecord::Relation serialization strategy,
#       and attempt to optimize without falling back to Marshal.dump/load
UniversalID::MessagePackFactory.register(
  type: ActiveRecord::Relation,
  recreate_pool: false,
  packer: ->(obj, packer) do
    # NOTE: packing a relation will reset the loaded state and internal cache of the relation
    #       this ensures minimal payload size
    obj = obj.dup # clear internal cached state (loaded results, etc.)
    obj.reset # dup should clear any internal caching, but we call reset just in case
    packer.write Marshal.dump(obj)
  end,
  unpacker: ->(unpacker) { Marshal.load unpacker.read }
)
