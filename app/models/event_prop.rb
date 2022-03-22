class EventProp < ApplicationRecord
  has_one :event

  before_validation :refill_prop_cache_sums
  validates :prop_pref, presence: true
  validates :pos_id, :numericality => { :greater_than_or_equal_to => 0 }
  validates :full_sum, :numericality => { :greater_than_or_equal_to => 1 }
  validates :prop_name_sum, :numericality => { :greater_than_or_equal_to => 1 }
  validates :prop_val_sum, :numericality => { :greater_than_or_equal_to => 1 }

  def refill_prop_cache_sums
    write_attribute(:prop_pref,  name.prop_prefix)
    write_attribute(:name, name.strip.strip_prop_prefix)
    write_attribute(:prop_name, name.first_level_prop_text)
    write_attribute(:prop_val,  name.second_level_prop_text)
    write_attribute(:full_sum, name.to_props_text_sum)
    write_attribute(:prop_name_sum, prop_name.to_props_text_sum)
    write_attribute(:prop_val_sum, prop_val.to_props_text_sum)
  end
end
