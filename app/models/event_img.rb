# frozen_string_literal: true

class EventImg < ApplicationRecord
  include Rails.application.routes.url_helpers
  belongs_to :event
  has_one_attached :image_file
  # has_one_attached :image_file_sm

  def image_valid?; deleted_at.nil? && image_file.attached?; end

  def image_file_disk_path; ActiveStorage::Blob.service.send(:path_for, image_file.key); end
  def image_sm_url; "/api/v1/pub/events/eimg/#{ id }"; end
  def image_full_url; rails_blob_path(image_file , only_path: true); end
end
