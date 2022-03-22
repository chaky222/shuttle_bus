ActiveAdmin.register Report do
  permit_params Report.attribute_names.map(&:to_sym)

  actions :index, :show

  index do
    id_column
    column :status
    column :admin_user

    column :reporter do |r|
      auto_link(r, r.reporter_id)
    end

    column :event
    column :kind
    column :reason
    column :description
    column :reported_users do |r|
      if r.kind_user?
        table_for r.users do
          column :user_id do |user|
            auto_link(user, user.id)
          end

          column :name
          column :email
         end
       end
    end

    actions
  end

  show do
    columns do
      column do
        attributes_table do
          row :id
          row :status
          row :admin_user
          row :reporter do |r|
            auto_link(r, r.reporter_id)
          end
          row :event
          row :kind
          row :reason
          row :description
        end
      end

      column do
        panel 'Users' do
          table_for resource.users do
            column :user_id do |user|
              auto_link(user, user.id)
            end

            column :name
            column :email
          end
        end
      end
    end

    active_admin_comments
  end

  action_item :proc, only: :show, if: -> { resource.status_waiting? } do
    link_to 'Take for processing', take_for_processing_admin_report_path(resource)
  end

  member_action :take_for_processing do
    service = Reports::TakeForProcessing.call(report: resource, admin_user: current_admin_user)

    flash[:notice] = service.success? ? 'You have taken this report.' : service.errors
    redirect_to resource_url
  end

  action_item :close_report, only: :show, if: -> { resource.status_processing? } do
    link_to 'Close the report.', close_admin_report_path(resource)
  end

  member_action :close do
    service = Reports::Close.call(report: resource)

    flash[:notice] = service.success? ? 'The report has been closed.' : service.errors
    redirect_to resource_url
  end
end
