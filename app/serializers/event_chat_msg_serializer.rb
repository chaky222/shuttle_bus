# frozen_string_literal: true

class EventChatMsgSerializer < ActiveModel::Serializer
  attributes :id, :event_id, :user_id, :msg_html, :msg_unreaded, :created_at_unixtime, :updated_at_unixtime
  attr_accessor :msg_unreaded_by_current_user

  def set_msg_unreaded!; @msg_unreaded_by_current_user = true; end
  def msg_unreaded
    @msg_unreaded_by_current_user ? true : false
  end

end
