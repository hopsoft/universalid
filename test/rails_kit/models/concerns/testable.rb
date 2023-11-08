# frozen_string_literal: true

module Testable
  extend ActiveSupport::Concern

  class_methods do
    def test(**attributes)
      yield new(generate_attributes.merge(attributes))
    end

    def test!(**attributes)
      test(**attributes) do |record|
        record.save!
        yield record
      ensure
        record&.destroy
      end
    end

    private

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
        next if column.name.in?(foreign_key_column_names)

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
