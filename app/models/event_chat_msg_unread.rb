# frozen_string_literal: true

class EventChatMsgUnread < ApplicationRecord
  belongs_to :event_chat_msg
  belongs_to :user



end
