# frozen_string_literal: true

class PartiesModule::PartiesController < ::PartiesModule::PartiesBaseController
  skip_before_action :set_front_side_current_party, only: %w{index new create}


  def index
    add_breadcrumb "Parties", :parties_path
    per_page = 24
    events_data = ::PubPartiesSearchHelper.get_events_collection(params)
    events = events_data[:events]
    search_item = { name: 'Search', prop_name: :search }
    @filter_items = [search_item] + events_data[:filter_items]
    @items = events.page(params_page).per(per_page)
  end

  def show
    @item = @front_side_current_party
  end

  def choose_ticket

  end

  def chat
    @new_msg = EventChatMsg.new
    @items = load_chat_msgs_list
    @unread_ids = load_unreaded_msgs_ids_and_mark_them_readed(@items)
  end

  def load_chat_msgs_list
    per_page = 30
    main_data[:title] = "Chat"
    add_breadcrumb main_data[:title], chat_party_path(@front_side_current_party.id)
    evs_search_attrs = can_current_user_read_party_chat? ? { event: @front_side_current_party } : { id: 0 }
    EventChatMsg.where(evs_search_attrs).order(id: :DESC).page(params_page).per(per_page)
  end

  def load_unreaded_msgs_ids_and_mark_them_readed(msgs)
    result = []
    EventChatMsgUnread.where(user: current_user).where(event_chat_msg_id: msgs.map(&:id)).includes(:event_chat_msg).each do |umsg|
      result.push(umsg.event_chat_msg_id)
      if (umsg.event_chat_msg.created_at + 5.seconds) < Time.now()
        umsg.destroy!
      end
    end
    result
  end

  def chat_add_msg
    @new_msg = EventChatMsg.new
    new_html = params[:msg_text].strip.gsub(/[\r]+/, "").text_to_html
    if can_current_user_read_party_chat? && new_html.size_positive?
      new_attrs = { user: current_user, msg_html: new_html }
      @new_msg = @front_side_current_party.event_chat_msgs.create!(new_attrs)
      if @new_msg.id && @new_msg.id.positive?
        return redirect_to chat_party_path(@front_side_current_party.id)
      end
    end
    @items = load_chat_msgs_list
    @unread_ids = load_unreaded_msgs_ids_and_mark_them_readed(@items)
    flash2 :alert, "Errors found"
    render action: :chat
  end

end
