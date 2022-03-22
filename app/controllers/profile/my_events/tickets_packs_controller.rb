class Profile::MyEvents::TicketsPacksController < Profile::MyEvents::MyEventsBaseController
  add_breadcrumb "TicketsPacks", :profile_my_event_tickets_packs_path
  before_action :set_current_my_event_tpack, except: %w{index new create}

  def set_current_my_event_tpack
    return @current_event_tpack if @current_event_tpack
    id = params[:tpack_id] || params[:my_event_tpack_id]
    result = @current_my_event.event_ticket_packs.detect { |x| x.id.eql?(id.to_i || 0) }
    unless result
      raise ActionController::RoutingError.new("TicketsPack #{ id } not found in your profile")
    end
    add_breadcrumb "TicketsPack \##{ result.id }", profile_my_event_tickets_pack_path(@current_my_event.id, result.id)
    @current_event_tpack = result
    result
  end

  def index
    @items = @current_my_event.event_ticket_packs
  end

  def new
    @item = @current_my_event.event_ticket_packs.new
    @item.event_ticket_pack_sale_rule = :simple_sale
    @item.pack_capacity = 1
    add_breadcrumb "New", new_profile_my_event_tickets_pack_path
  end

  def create
    @item = @current_my_event.event_ticket_packs.create(tpack_create_params.merge({ event_ticket_pack_sale_rule: 1 }))
    unless @item.errors.any?
      return success_redirect('Created', edit_profile_my_event_tickets_pack_path(@current_my_event.id, @item.id))
    end
    main_data[:erorrs_found] = "1"
    add_breadcrumb "New", new_profile_my_event_tickets_pack_path
    render action: :new
  end

  def tpack_create_params
    params.require(:event_ticket_pack).permit(:name, :pack_capacity, :ticket_cost_eur)
  end

  def edit
    @item = @current_event_tpack
    add_breadcrumb "Edit", edit_profile_my_event_tickets_pack_path(@current_my_event.id, @item.id)
    if redirected_in_modal?
      minfo(@item, my_event_tpack_item_row_html(@item), "my_event_tpacks_list_#{ @item.event_id }")
    end
  end

  def update
    @item = @current_event_tpack
    if @item.update(tpack_update_params.merge(tpack_version: (@item.tpack_version + 1)))
      return success_redirect('Saved', edit_profile_my_event_tickets_pack_path(@current_my_event.id, @item.id))
    end
    main_data[:erorrs_found] = "1"
    flash2 :alert, "Errors found"
    render action: :edit
  end

  def tpack_update_params
    params.require(:event_ticket_pack).permit(:name, :pack_capacity, :ticket_cost_eur, :event_ticket_pack_sale_rule)
  end

  def show
    @item = @current_event_tpack
    if redirected_in_modal?
      minfo(@item, my_event_tpack_item_row_html(@item), "my_event_tpacks_list_#{ @item.event_id }")
    end
  end

end
