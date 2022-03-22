# frozen_string_literal: true

ActiveAdmin.register User do
  attributes_to_display = User.new.attributes.keys - %w(id password_digest reset_password_token confirmation_token created_at)
  permit_params attributes_to_display.map(&:to_sym)
  actions :index, :show

  includes :avatar_attachment, :reviews

  index do
    selectable_column
    id_column
    column :avatar_thumb do |user|
      if user.avatar.attached?
        div do
          image_tag(user.avatar_thumb)
        end
        div do
          link_to('full', user.avatar, target: :blank)
        end
      else
        'no_avatar'
      end
    end
    attributes_to_display.each do |attribute|
      column attribute.to_sym
    end
    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :avatar_thumb do |user|
            if user.avatar.attached?
              div do
                image_tag(user.avatar_thumb)
              end
              div do
                link_to('full', user.avatar, target: :blank)
              end
            else
              'no_avatar'
            end
          end
          attributes_to_display.each do |attribute|
            row attribute.to_sym
          end
        end
      end

      column do
        panel 'Created events' do
          table_for resource.events do
            column(:id) { |event| link_to(event.id, admin_event_path(event)) }
            column :name
            column :rating
          end
        end

        panel 'Events were interested' do
          table_for resource.ticketed_events do
            column(:id) { |event| link_to(event.id, admin_event_path(event)) }
            column :name
            column :rating
            column :message do |event|
            end
          end
        end
      end
    end

    columns do
      column do
        panel 'Created reports' do
          table_for resource.created_reports do
            column(:id) { |report| link_to(report.id, admin_report_path(report)) }
            column :status
            column :kind
            column :reason
          end
        end
      end

      column do
        panel 'Reports' do
          table_for resource.reports do
            column(:id) { |report| link_to(report.id, admin_report_path(report)) }
            column :status
            column :kind
            column :reason
          end
        end
      end
    end

    columns do
      column do
        panel 'Reviews' do
          table_for resource.reviews.includes(:assessable) do
            column(:id) { |event| link_to(event.id, admin_event_path(event)) }
            column :assessable
            column :rating
            column :comment
            column :reason
          end
        end
      end
      column do
        panel 'Reviews as reviewer' do
          table_for resource.reviews_as_reviewer.includes(:assessable) do
            column(:id) { |event| link_to(event.id, admin_event_path(event)) }
            column :assessable
            column :rating
            column :comment
            column :reason
          end
        end
      end
    end

    active_admin_comments
  end

  filter :id
  filter :name
  filter :last_name
  filter :email
end
