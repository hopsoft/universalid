# frozen_string_literal: true

# TODO:
#   prepack:
#     [x] exclude: []
#     [x] include: []
#     [x] include_blank: true
#
#     database:
#       [x] include_keys: true
#       [x] include_timestamps: true
#       [x] include_unsaved_changes: false
#       [ ] include_descendants: false
#       [ ] descendant_depth: 0
class UniversalID::ActiveRecordBasePacker
  using UniversalID::Refinements::HashRefinement

  HAS_MANY_ASSOCIATIONS = [
    ActiveRecord::Reflection::HasOneReflection,
    ActiveRecord::Reflection::HasManyReflection,
    ActiveRecord::Reflection::HasAndBelongsToManyReflection
  ]

  attr_reader :record

  def initialize(record)
    @record = record
  end

  def pack_with(packer)
    packer.write record.class.name
    packer.write packable_attributes
  end

  def prepack_options
    options = record.instance_variable_get(:@_uid_prepack_options)
    options = UniversalID::PrepackOptions.new unless options.is_a?(UniversalID::PrepackOptions)
    options
  end

  def prepack_database_options
    prepack_options.database_options
  end

  private

  def packable_attributes
    return record.attributes.slice(record.class.primary_key) if id_only?(prepack_database_options)

    hash = record.attributes
    reject_database_keys! hash if prepack_database_options.exclude_keys?
    reject_timestamps! hash if prepack_database_options.exclude_timestamps?
    discard_unsaved_changes! hash if prepack_database_options.exclude_unsaved_changes?

    # TODO: move a helper method
    if prepack_database_options.include_descendants?
      loaded_descendants.each do |name, descendants|
        binding.pry
      end
    end

    hash.prepack prepack_options
  end

  # helpers ..................................................................................................
  def id_only?(prepack_database_options)
    return false if record.new_record?
    return false if prepack_database_options.include_descendants?
    prepack_database_options.exclude_unsaved_changes?
  end

  # attribute mutators .......................................................................................

  def reject_database_keys!(hash)
    hash.delete record.class.primary_key
    foreign_key_column_names.each { |key| hash.delete key }
  end

  def reject_timestamps!(hash)
    timestamp_column_names.each { |key| hash.delete key }
  end

  def discard_unsaved_changes!(hash)
    record.changes_to_save.each do |key, (original_value, _)|
      hash[key] = original_value
    end
  end

  # active record helpers ....................................................................................

  def timestamp_column_names
    record.class.all_timestamp_attributes_in_model
  end

  def foreign_key_column_names
    record.class.reflections
      .each_with_object([]) do |(name, reflection), memo|
        memo << reflection.foreign_key if reflection.macro == :belongs_to
      end
  end

  def associations
    record.class.reflect_on_all_associations
  end

  def has_many_associations
    associations.select { |a| HAS_MANY_ASSOCIATIONS.include? a.class }
  end

  def loaded_has_many_associations
    has_many_associations.select { |a| record.public_send(a.name)&.loaded? }
  end

  def loaded_has_many_association_names
    loaded_has_many_associations.map(&:name)
  end

  def loaded_descendants
    loaded_has_many_association_names.each_with_object({}) do |name, memo|
      descendants = record.public_send(name).to_a
      memo[name] = UniversalID::Prepacker.prepack(descendants, prepack_options)
    end
  end
end

# ============================================================================================================
# Example form submit payloads for HAS_MANY_ASSOCIATIONS
# ============================================================================================================
#
# ------------------------------------------------------------------------------------------------------------
# ActiveRecord::Reflection::HasManyReflection
# ------------------------------------------------------------------------------------------------------------
# class Campaign < ApplicationRecord
#   has_many :emails, dependent: :destroy
#   accepts_nested_attributes_for :emails
# end
# ------------------------------------------------------------------------------------------------------------
# {
#   "campaign" => {
#     "name" => "Summer Sale Campaign",
#     "description" => "Updated description for our big summer sale!",
#     "trigger" => "summer_sale_start",
#     "emails_attributes" => {
#       "0" => {
#         "id" => "1", # Assuming the ID of the existing email is 1
#         "subject" => "Sale Starts Now - Updated",
#         "body" => "Our Summer Sale is starting, don't miss out on new deals!",
#         "wait" => "0"
#       },
#       "1" => {
#         "id" => "2", # Assuming the ID of the existing email is 2
#         "subject" => "Reminder: Sale Still On",
#         "body" => "The Summer Sale is halfway through - check out what's left!",
#         "wait" => "24"
#       },
#       "2" => {
#         # No ID since this is a new email
#         "subject" => "Final Call for Summer Sale",
#         "body" => "Last chance to grab your favorites before the sale ends!",
#         "wait" => "72"
#       }
#     }
#   }
# }
#
# ------------------------------------------------------------------------------------------------------------
# ActiveRecord::Reflection::HasOneReflection
# ------------------------------------------------------------------------------------------------------------
# class Campaign < ApplicationRecord
#   has_one :email, dependent: :destroy
#   accepts_nested_attributes_for :email
# end
# ------------------------------------------------------------------------------------------------------------
# {
#   "campaign" => {
#     "name" => "Summer Sale Campaign",
#     "description" => "Description for our big summer sale!",
#     "trigger" => "summer_sale_start",
#     "email_attributes" => {
#       "id" => "1", # Assuming the ID of the existing email is 1
#       "subject" => "Sale Starts Now",
#       "body" => "Our Summer Sale is starting, don't miss out on the deals!",
#       "wait" => "0"
#     }
#   }
# }
#
# ------------------------------------------------------------------------------------------------------------
# ActiveRecord::Reflection::HasAndBelongsToManyReflection
# ------------------------------------------------------------------------------------------------------------
# class Campaign < ActiveRecord::Base
#   has_and_belongs_to_many :emails
# end
# ------------------------------------------------------------------------------------------------------------
# NOTE: habtm associations do not support `accepts_nested_attributes_for`,
#       but here's one way this could be represented (i.e. matching the `has_many` example above)
#       Implementation of handling this payload for HABTM associations would require
#       custom implementation logic
# ------------------------------------------------------------------------------------------------------------
# {
#   "campaign" => {
#     "name" => "Summer Sale Campaign",
#     "description" => "Our biggest sale of the year!",
#     "trigger" => "summer_sale",
#     "emails_attributes" => {
#       "0" => {
#         "id" => "1", # Assuming the ID of the existing email is 1
#         "subject" => "Sale Starts Now - Updated",
#         "body" => "Our Summer Sale is starting, don't miss out on new deals!",
#         "wait" => "0"
#       },
#       "1" => {
#         "id" => "2", # Assuming the ID of the existing email is 2
#         "subject" => "Reminder: Sale Still On",
#         "body" => "The Summer Sale is halfway through - check out what's left!",
#         "wait" => "24"
#       },
#       "2" => {
#         # No ID since this is a new email
#         "subject" => "Final Call for Summer Sale",
#         "body" => "Last chance to grab your favorites before the sale ends!",
#         "wait" => "72"
#       }
#     }
#   }
# }
