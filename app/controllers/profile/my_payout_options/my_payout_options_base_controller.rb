class Profile::MyPayoutOptions::MyPayoutOptionsBaseController < FrontProfileController
  add_breadcrumb "My payout options", :profile_my_tickets_path
  before_action :set_current_my_payout_option_item

  def set_current_my_payout_option_item
    return @current_my_payout_option_item if @current_my_payout_option_item
    id = params[:poption_id] || params[:poption_poption_id]
    result = current_user.payout_options.find(Integer(id))
    unless result
      raise ActionController::RoutingError.new("PayoutOption #{ id } not found in your profile")
    end
    add_breadcrumb "PayoutOption \##{ result.id }", profile_my_payout_option_path(result.id)
    @current_my_payout_option_item = result
    result
  end

end
