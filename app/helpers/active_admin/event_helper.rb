module ActiveAdmin::EventHelper
  def minimum_event_price
    Event.published.joins(:event_ticket_packs).minimum(:ticket_cost_eur).to_f
  end

  def maximum_event_price
    Event.published.joins(:event_ticket_packs).maximum(:ticket_cost_eur).to_f
  end

  def average_event_price
    Event.published.joins(:event_ticket_packs).average(:ticket_cost_eur).to_f
  end

  def not_published_events
    Event.not_published.count
  end

  def published_events
    Event.published.count
  end

  def canceled_events
    Event.canceled.count
  end

  def finished_events
    Event.finished.count
  end

  def groupped_events_by_geography
    Event.pluck(:geography).each_with_object({}) do |geography, obj|
      next unless geography.present?

      geography_str = "#{geography['country']}#{geography['city']}"
      obj[geography_str] ||= []
      obj[geography_str] << geography
    end
  end
end
