# frozen_string_literal: true

require "forwardable"
require "active_record"
require "faker"

module ActiveRecordForge
  def self.included(klass)
    klass.define_singleton_method(:foundry) { @foundry ||= ActiveRecordForge::Foundry.new(self) }
    klass.define_singleton_method(:forge) { |*args, **kwargs| foundry.forge(*args, **kwargs) }
    klass.define_singleton_method(:forge!) { |*args, **kwargs| foundry.forge!(*args, **kwargs) }
  end

  class Foundry
    extend Forwardable

    attr_reader :klass

    def initialize(klass)
      @klass = klass
    end

    def forge(count = 1, **options)
      options = options.stringify_keys
      attribute_options = options.slice(*column_names)
      association_options = options.slice(*association_names)

      records = count.times.map { klass.build generate_attributes.merge(attribute_options) }

      records.each_with_index do |record, i|
        association_options.each do |association_name, association_count|
          association_count.times do
            association_record = association(association_name).klass.forge(**options)
            record.public_send(association_name) << association_record
          end
        end
      end

      # binding.pry if $nate && klass == Campaign
      (records.size == 1) ? records.first : records
    end

    def forge!(...)
      forge(...).tap { |forged| forged.is_a?(Array) ? forged.each(&:save!) : forged.save! }
    end

    private

    def_delegators :klass, :columns, :column_names, :primary_key, :reflections, :reflect_on_all_associations

    def association(name)
      associations.find { |a| a.name.to_s == name.to_s }
    end

    def associations(macro: nil)
      list = reflect_on_all_associations
      list = list.select { |a| a.macro == macro.to_sym } if macro
      list
    end

    def association_names(macro: nil)
      associations(macro: macro).map { |a| a.name.to_s }
    end

    def foreign_key_column_names
      reflections.each_with_object([]) do |(name, reflection), memo|
        memo << reflection.foreign_key if reflection.macro == :belongs_to
      end
    end

    def generate_attributes
      attributes = {}

      columns.each do |column|
        next if column.default
        next if column.name == primary_key
        next if foreign_key_column_names.include?(column.name)

        case column.type
        when :string
          options = [
            Faker::Commerce.product_name,
            Faker::Company.bs,
            Faker::Company.catch_phrase,
            Faker::Company.department,
            Faker::Company.industry,
            Faker::Company.name,
            Faker::Marketing.buzzwords
          ]
          attributes[column.name] = options.sample(rand(1..2)).join(" ")
        when :text
          options = [
            Faker::Movies::Hackers.quote,
            Faker::Movies::Lebowski.quote,
            Faker::Movies::PrincessBride.quote,
            Faker::Movies::StarWars.quote,
            Faker::TvShows::MichaelScott.quote,
            Faker::TvShows::RickAndMorty.quote,
            Faker::TvShows::SiliconValley.quote
          ]
          attributes[column.name] = options.sample(rand(2..5)).join(" ")
        end
      end

      attributes.with_indifferent_access
    end
  end
end
