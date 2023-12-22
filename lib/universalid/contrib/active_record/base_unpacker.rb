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
        else
          klass.new
        end

        assign_attributes record, attributes
        assign_descendants record, attributes

        record
      end

      def assign_attributes(record, attributes)
        attributes.each do |key, value|
          record.public_send "#{key}=", value if record.respond_to? "#{key}="
        end
      end

      def assign_descendants(record, attributes)
        descendants = attributes[UniversalID::Contrib::ActiveRecordBasePacker::DESCENDANTS_KEY] || {}
        descendants.each do |name, list|
          next unless record.respond_to?(name) && record.respond_to?("#{name}=")

          models = list.map { |packed| UniversalID::MessagePackFactory.msgpack_pool.load(packed) }
          models.compact!
          next unless models.any?

          # NOTE: ActiveRecord is smart enough to not re-create or re-add
          #       existing records for has_many associations
          record.public_send "#{name}=", models
        end
      end
    end
  end

end
