ActiveAdmin.register Event do
  remove_filter :user, :event_props
  permit_params Event.attribute_names.map(&:to_sym) + [event_imgs: []]
  actions :all

  attributes_to_display = Event.new.attributes.keys - %w()
  index do
    selectable_column
    column ("logo_sm") { |item| item.valid_event_imgs.any? ? link_to("<img src='#{ item.get_sm_logo_path }' />".html_safe, admin_event_path(item)) + "<br/>".html_safe + link_to("full", item.get_logo_or_nil) + " Images: #{ item.event_imgs.count }" : link_to("no_logo", admin_event_path(item)) }
    attributes_to_display.each do |attribute|
      column attribute.to_sym
    end
    actions
  end

  show do
    attributes_table do
      row :full do |m|
        indx = 0
        m.valid_event_imgs.map do |img|
          result = img.image_file.attached? ? link_to(image_tag(img.image_file).html_safe, img.image_file).html_safe : "IMG_FILE_NOT_FOUND"
          result += "<a class='admin_show_item_img_del_link' href='#{ dellimage_admin_event_path(resource) }?sm=0&indx=#{ indx }' onclick='return confirm(\"sure?\");' >x</a>".html_safe
          indx += 1
          "<span class='admin_show_item_img_span admin_show_item_img_span_full'>#{ result }</span>".html_safe
        end.join.html_safe
      end
      row :sm do |sm|
        indx = 0
        sm.valid_event_imgs.map do |img|
          result = img.image_file.attached? ? link_to("<img src='#{ img.image_sm_url }' />".html_safe, img.image_sm_url).html_safe : "SM_IMG_FILE_NOT_FOUND"
          result += "<a class='admin_show_item_img_del_link' href='#{ dellimage_admin_event_path(resource) }?sm=1&indx=#{ indx }' onclick='return confirm(\"sure?\");' >x</a>".html_safe
          indx += 1
          "<span class='admin_show_item_img_span admin_show_item_img_span_sm'>#{ result }</span>".html_safe
        end.join.html_safe
      end
    end
    default_main_content

    panel "Event Props Cache" do
      table_for resource.event_props do
        column ("id") { |item| link_to(item.id, admin_event_prop_path(item)) }
        column 'pos', :pos_id
        column 'name', :name
        column ("prop_name_sum") { |item| link_to(item.prop_name_sum, admin_event_props_path(q: { prop_name_sum_equals: item.prop_name_sum })) }
        column ("prop_val_sum") { |item| link_to(item.prop_val_sum, admin_event_props_path(q: { prop_name_sum_equals: item.prop_name_sum, prop_val_sum_equals: item.prop_val_sum })) }
        column 'updated_at', :updated_at
        column 'created_at', :created_at
        column("") { |item| link_to "Edit", edit_admin_event_prop_path(item) }
      end
    end
  end

  member_action :dellimage, method: [:get] do
    indx = Integer(params[:indx])
    resource.event_imgs[indx].destroy!
    redirect_to admin_event_path(resource)
  end

  member_action :addimage, method: [:get, :post, :patch] do
    if request.get?
      render :addimage
    else
      item = resource
      ftmp = params[:event][:img_file]
      processed = ImageProcessing::MiniMagick.source(ftmp.tempfile).resize_to_limit(140, 140).strip.call
      if processed
        event_img = item.event_imgs.create!(name: ftmp.original_filename)
        if event_img.image_file.attach(io: ftmp.tempfile, filename: ftmp.original_filename)
          File.delete(processed.path) if File.exist?(processed.path)
        else
          item.errors.add(:image_file, "Can not attach")
        end
      end
      redirect_to admin_event_path(item)
    end
  end

  action_item(:add_image_to_event, only: :show) do
    link_to "Add image", addimage_admin_event_path(resource), :method => :get
  end

end
