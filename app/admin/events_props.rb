ActiveAdmin.register EventProp do
  remove_filter :event
  permit_params EventProp.attribute_names.map(&:to_sym) + [:event_id, :event]
  actions :all

  attributes_to_display = EventProp.new.attributes.keys - %w(full_sum prop_pref)
  index do
    selectable_column
    column ("EventLink") { |item| link_to(item.event_id.to_s, admin_event_path(item.event_id)) }
    attributes_to_display.each do |attribute|
      column attribute.to_sym
    end
    actions
  end


  form do |f|
    inputs 'Events_props NOT EDIT FROM HERE! This items will fill auto from the event description/rules/other fields!!!!!!!!!!!!' do
      input :event_id
      input :pos_id
    end
    f.inputs
    # Other inputs here
    f.actions
  end

end
