# frozen_string_literal: true

if defined? ActiveRecord

  class UniversalID::Contrib::ActiveRecordBaseUnpacker
    class << self
      def unpack_with(unpacker)
        class_name = unpacker.read
        attributes = unpacker.read || {}
        create_instance class_name, attributes
      end

      private

      def create_instance(class_name, attributes)
        klass = Object.const_get(class_name) if Object.const_defined?(class_name)
        return nil unless klass

        record = if attributes[klass.primary_key]
          klass.find_by(klass.primary_key => attributes[klass.primary_key])
        end
        record ||= klass.new

        assign_attributes record, attributes.except("marked_for_destruction")
        record.mark_for_destruction if attributes["marked_for_destruction"]
        assign_descendants record, attributes

        record
      end

      def assign_attributes(record, attributes)
        attributes.each do |key, value|
          record.public_send :"#{key}=", value if record.respond_to? :"#{key}="
        end
      end

      def assign_descendants(record, attributes)
        descendants = attributes[UniversalID::Contrib::ActiveRecordBasePacker::DESCENDANTS_KEY] || {}
        descendants.each do |name, list|
          next unless record.respond_to?(name) && record.respond_to?(:"#{name}=")

          models = list.map { |packed| UniversalID::MessagePackFactory.msgpack_pool.load(packed) }
          models.compact!
          next unless models.any?

          new_models = models.select(&:new_record?)
          models -= new_models

          # restore persisted models
          # NOTE: ActiveRecord is smart enough to not re-create or re-add
          #       existing records for has_many associations
          record.public_send :"#{name}=", models if models.any?

          # restore new unsaved models
          record.public_send(name).target.concat new_models if new_models.any?
        end
      end
    end
  end

end
