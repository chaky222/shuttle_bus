ActiveAdmin.register EventsFilterField do
  # remove_filter :user
  permit_params EventsFilterField.attribute_names.map(&:to_sym) - [:eff_name_sum]
  actions :all

  attributes_to_display = EventsFilterField.new.attributes.keys - %w()
  index do
    selectable_column
    attributes_to_display.each do |attribute|
      if attribute.to_sym == :eff_name_sum
        column ("Eff Name Sum") { |item| link_to(item.eff_name_sum, admin_event_props_path(q: { prop_name_sum_equals: item.eff_name_sum })) }
      else
        column attribute.to_sym
      end
    end
    actions
  end


end
