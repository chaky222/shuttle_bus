class Profile::MyEvents::MyEventsController < Profile::MyEvents::MyEventsBaseController
  skip_before_action :set_current_my_event, only: %w{index new create}

  def index
    per_page = 12
    ids_sql = ::PubPartiesSearchHelper.get_search_where_sql(params[:search].to_s, true)
    @items = current_user.events.where(ids_sql).page(params_page).per(per_page)
  end

  def new
    @item = current_user.events.new
    add_breadcrumb "New", new_profile_my_event_path
  end

  def create
    @item = current_user.events.create(params.require(:event).permit(:name).merge({ visibility_status: :not_published }))
    unless @item.errors.any?
      return success_redirect('Created', edit_profile_my_event_path(@item.id))
    end
    render action: :new
  end

  def show
    @item = @current_my_event
    @item.validate!
  end

  def edit
    @item = @current_my_event
    add_breadcrumb "Edit", edit_profile_my_event_path(@item.id)
  end

  def update
    @item = @current_my_event
    new_event_start_time  = Time.strptime(params[:event_start_time ], "%F %H:%M").localtime
    new_event_finish_time = Time.strptime(params[:event_finish_time], "%F %H:%M").localtime
    # puts "\n\n\n params[:event_start_time]=[#{ params[:event_start_time] }] new_event_start_time=[#{ new_event_start_time }] \n\n\n"
    tattrs = { event_start_time: new_event_start_time, event_finish_time: new_event_finish_time }
    tattrs[:visibility_status] = :published if (params[:run_publish_chk] || '0'.to_i.positive?)
    if @item.can_owner_edit_this_event?
      if @item.update(params.require('event').permit(:name, :description).merge(tattrs))
        # if (params[:run_publish_chk] || '0'.to_i.positive?)
        #   if (@item.can_owner_publish_this_event? && self.class.try_publish_the_event!(@item.id))
        #     flash2(:success, 'Event published successfully')
        #   else
        #     flash2(:alert, 'Event not published. Some errors found.')
        #   end
        # end
        return success_redirect('Saved', profile_my_event_path(@item.id))
      end
    else
      @item.errors.add(:edit, "can not edit this event")
    end
    flash2 :alert, "Errors found"
    render action: :edit
  end

  def my_chat
    @new_msg = EventChatMsg.new
    @items = load_my_chat_msgs_list
    @unread_ids = load_unreaded_msgs_ids_and_mark_them_readed(@items)
  end

  def load_my_chat_msgs_list
    main_data[:title] = "My chat"
    per_page = 30
    add_breadcrumb main_data[:title], my_chat_profile_my_event_path(@current_my_event.id)
    EventChatMsg.where(event: @current_my_event).order(id: :DESC).page(params_page).per(per_page)
  end

  def load_unreaded_msgs_ids_and_mark_them_readed(msgs)
    result = []
    EventChatMsgUnread.where(user: current_user).where(event_chat_msg_id: msgs.map(&:id)).each do |umsg|
      result.push(umsg.event_chat_msg_id)
      # umsg.destroy! # We will not remove unreads for owner - this need for debug
    end
    result
  end

  def my_chat_add_msg
    @new_msg = EventChatMsg.new
    new_html = params[:msg_text].strip.gsub(/[\r]+/, "").text_to_html
    if new_html.size_positive?
      new_attrs = { user: current_user, msg_html: new_html }
      @new_msg = @current_my_event.event_chat_msgs.create!(new_attrs)
      if @new_msg.id && @new_msg.id.positive?
        return redirect_to my_chat_profile_my_event_path(@current_my_event.id)
      end
    else
      @new_msg.errors.add(:text, 'empty')
    end
    @items = load_my_chat_msgs_list
    @unread_ids = load_unreaded_msgs_ids_and_mark_them_readed(@items)
    flash2 :alert, "Errors found"
    render action: :my_chat
  end

  def payout
    add_breadcrumb "Payout", payout_profile_my_event_path(@current_my_event.id)
  end

  def payout_run
    add_breadcrumb "Payout", payout_profile_my_event_path(@current_my_event.id)
    # transfer = Stripe::Transfer.create({
    #   amount: 10,
    #   currency: "eur",
    #   destination: "{{CONNECTED_STRIPE_ACCOUNT_ID}}",
    # })
    flash2 :alert, "Errors found"
    render action: :payout
  end

  def images
    @item = @current_my_event
    add_breadcrumb "Images", images_profile_my_event_path(@item.id)
  end

  def choose_image_as_logo
    @item = @current_my_event
    params.to_enum.to_h.each do |k, val|
      if k.starts_with?('delete_item_')
        indx_for_del = k.gsub(/^delete_item_/, '').to_i || -1
        unless indx_for_del.negative?
          if @item.event_was_published?
            @item.valid_event_imgs[indx_for_del].update!(deleted_at: Time.now().localtime)
          else
            @item.valid_event_imgs[indx_for_del].destroy!
          end
          return success_redirect('Image deleted', images_profile_my_event_path(@item.id))
        end
      end
    end
    indx = params.require('event').permit(:logo_img_index)[:logo_img_index].to_i || -1
    logo_img = @item.valid_event_imgs[indx]
    if logo_img
      @item.valid_event_imgs.each_with_index { |x, i| x.update!(prio: x.id.eql?(logo_img.id) ? 0 : i + 1) }
      return success_redirect('Logo choosed', images_profile_my_event_path(@item.id))
    end
    flash2 :alert, "Errors found"
    render action: :images
  end

  def create_image_attachment
    @item = @current_my_event
    add_breadcrumb "Images", images_profile_my_event_path(@item.id)
    if @item.can_owner_attach_image?
      if params[:img_file].tempfile.size > 4.megabyte
        item.errors.add(:event_images, "is too big. Max 4MB for image.")
      else
        processed = ImageProcessing::MiniMagick.source(params[:img_file].tempfile).resize_to_limit(140, 140).strip.call
        if processed
          acceptable_types = ["image/jpeg", "image/png"]
          if acceptable_types.include?(MIME::Types.type_for(processed.path).first.content_type)
            new_img = @item.event_imgs.create!(name: params[:img_file].original_filename, prio: @item.event_imgs.count + 1)
            if new_img.image_file.attach(io: params[:img_file].tempfile, filename: params[:img_file].original_filename)
              # if new_img.image_file_sm.attach(io: processed, filename: 'sm_' + params[:img_file].original_filename)
                File.delete(processed.path) if File.exist?(processed.path)
                return success_redirect('Image added', images_profile_my_event_path(@item.id))
              # else
              #   @item.errors.add(:event_images_sm, "Can not attach event_image_sm")
              # end
            else
              @item.errors.add(:event_images, "Can not attach event_image")
            end
          else
            errors.add(:event_images, "must be a JPEG or PNG")
          end
        end
      end
    else
      @item.errors.add(:event_images, "You can not attach image")
    end
    flash2 :alert, "Errors found"
    render action: :images
  end

  def change_event_status
    @item = @current_my_event
    params.to_enum.to_h.each do |k, val|
      if k.starts_with?('to_status_')
        if k.str_eq?('to_status_returned_for_edit')
          @item.update!(visibility_status: :unpublished)
          return success_redirect('Unpublished successfully', profile_my_event_path(@item.id))
        elsif k.str_eq?('to_status_decline_this_event')
          # if @item.can_owner_decline_this_event?
          #   wsql2 = "UPDATE events SET status=55 WHERE ((id=#{ @item.id }) AND (status BETWEEN 10 AND 50))"
          #   if (ActiveRecord::Base.connection.update(wsql2) || 0).positive?
          #     return success_redirect('Event declined successfully', edit_profile_my_event_path(@item.id))
          #   end
          #   return alert_redirect('Event NOT declined. Some errors found.', edit_profile_my_event_path(@item.id))
          # end
          # return alert_redirect("Event can NOT be declined. Status: [#{ @item.status }].", edit_profile_my_event_path(@item.id))
          @item.update!(visibility_status: :canceled)
          return success_redirect('Canceled successfully', profile_my_event_path(@item.id))
        elsif k.str_eq?('to_status_publish_this_event')
          # if @item.can_owner_publish_this_event?
          #   if self.class.try_publish_the_event!(@item.id)
          #     return success_redirect('Event published successfully', profile_my_event_path(@item.id))
          #   end
          #   return alert_redirect('Event NOT published. Some errors found.', profile_my_event_path(@item.id))
          # end
          # return alert_redirect("Event can NOT be published. Status: [#{ @item.status }].", profile_my_event_path(@item.id))
          unless @item.have_tickets_for_sale?
            return alert_redirect('No tickets', profile_my_event_path(@item.id))
          end

          if @item.update(visibility_status: :published)
            return success_redirect('Published successfully', profile_my_event_path(@item.id))
          end
          flash2 :alert, "Errors found"
          return render action: :edit
          # return alert_redirect("Event can NOT be published. Errors found.", profile_my_event_path(@item.id))
        elsif k.str_eq?('to_status_copy_this_event')
          return alert_redirect("Copy action is not done by chaky yet :(... Sorry please.", edit_profile_my_event_path(@item.id))
        else
          raise("ERROR 34343223443234. Wrong new event status[#{ k }].")
        end
      end
    end
    raise("ERROR 343432244232322. Not found new event status in params.")
  end

  def self.try_publish_the_event!(event_id)
    wsql2 = "UPDATE events SET status=10 WHERE ((id=#{ event_id }) AND (status BETWEEN 0 AND 9))"
    (ActiveRecord::Base.connection.update(wsql2) || 0).positive?
  end
end
