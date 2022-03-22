class Profile::MyPayoutOptions::MyPayoutOptionsController < Profile::MyPayoutOptions::MyPayoutOptionsBaseController
  skip_before_action :set_current_my_payout_option_item, only: %w{index new create}

  def index
    @items = current_user.payout_options
  end

  def new
    add_breadcrumb "New", new_profile_my_payout_option_path
    @item = current_user.payout_options.new
  end

  def create
    add_breadcrumb "New", new_profile_my_payout_option_path
    @item = current_user.payout_options.new
    if @item.update(params.require(:payout_option).permit(:bank_code_name, :bank_account_number))
      return success_redirect('Saved', profile_my_payout_option_path(@item.id))
    end
    flash2 :alert, "Errors found"
    render action: :new
  end

  def show
  end

  def edit
    @item = @current_my_payout_option_item
    add_breadcrumb "Edit", edit_profile_my_payout_option_path(@item.id)
  end

  def update
    @item = @current_my_payout_option_item
    add_breadcrumb "Save", edit_profile_my_payout_option_path(@item.id)
    if @item.update(params.require(:payout_option).permit(:bank_code_name, :bank_account_number))
      return success_redirect('Saved', profile_my_payout_option_path(@item.id))
    end
    flash2 :alert, "Errors found"
    render action: :edit
  end


end
