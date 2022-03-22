class EventsFilterField < ApplicationRecord
  before_save :refill_eff_name_sum

  enum show_for_client: {
    hidden_for_client: 0,
    visible_for_client: 1
  }

  def refill_eff_name_sum
    write_attribute(:eff_name_sum, name.to_props_text_sum)
  end

end
