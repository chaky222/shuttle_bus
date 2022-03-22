# frozen_string_literal: true

class PartiesModule::BuyTicketModule::TicketsController < ::PartiesModule::BuyTicketModule::BuyTicketBaseController
  skip_before_action :set_front_side_tickets_pack, only: %w{index new}

  def index
    add_breadcrumb "Tickets", party_tickets_path(@front_side_current_party.id)
  #   add_breadcrumb "Parties", :parties_path
  #   per_page = 24
  #   events_data = ::PubPartiesSearchHelper.get_events_collection(params)
  #   events = events_data[:events]
  #   search_item = { name: 'Search', prop_name: :search }
  #   @filter_items = [search_item] + events_data[:filter_items]
  #   @items = events.page(params_page).per(per_page)
  end

  # def show
  # #   @item = @front_side_current_party
  #   @card = ActiveMerchant::Billing::CreditCard.new()
  #   if Rails.env.development?
  #     @card.number = '4111111111111111'
  #     @card.month = '01'
  #     @card.year = Time.new.year.to_i + 1
  #     @card.verification_value = '123'
  #   end
  # end

  # def create
  #   arr = params[:expiry_date].to_s.split('/')
  #   year = arr[1].to_s.gsub(/\D+/, "")
  #   year = "20#{ year }".to_i if year && (year.to_s.length == 2)
  #   @card = ActiveMerchant::Billing::CreditCard.new(
  #       number:              params[:card_number].to_s.gsub(/\D+/, ""), # 4111111111111111
  #       verification_value:  params[:cvv2].to_s.gsub(/\D+/, ""), # 123
  #       month:               arr[0].to_s.gsub(/\D+/, "").to_i, # 1
  #       year:                year, # 2020
  #       first_name:          current_user.name.to_s.size_positive? ? current_user.name : "No_name", # Bibek
  #       last_name:           current_user.last_name.to_s.size_positive? ? current_user.last_name : "No_last_name", # Sharma
  #       # brand:               credit_card_brand # visa
  #   )
  #   puts "\n\n\n\n valid=[#{ @card.valid? }] y=[#{ year.to_s[2, 3] }] year=[#{ year }] arr=[#{ arr.to_json }] card=[#{ @card.inspect }] \n\n\n\n"
  #   if @card.valid?
  #     tattrs = { user: current_user }
  #     puts "\n\n\n\n tattrs=[#{ tattrs.to_json }] \n\n\n\n"
  #     ticket = @front_side_tickets_pack.tickets.create!(tattrs)
  #     tpattrs = { gateway_name: 'stripe', card_type: @card.type, card_last4: @card.last_digits,
  #                amount_cts: @front_side_tickets_pack.ticket_cost_eur_cts, currency: 'EUR',
  #                card_exp_month: @card.month, card_exp_year: @card.year }
  #     puts "\n\n\n\n tpattrs=[#{ tpattrs.to_json }] \n\n\n\n"
  #     ticket_payment = ticket.tickets_payments.create!(tpattrs)
  #     if ticket_payment.id.positive?

  #     end
  #   end
  #   flash2 :alert, "Errors found"
  #   render action: :show
  # end
end
