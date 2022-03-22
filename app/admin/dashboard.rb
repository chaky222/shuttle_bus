ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: proc { I18n.t("active_admin.dashboard") }

  content title: proc { I18n.t("active_admin.dashboard") } do
    columns do
      column do
        extend ActiveAdmin::EventHelper

        if Event.published.exists?
          panel "Events stats" do

            table do
              thead do
                tr do
                  %w[Minimun_Price Maximum_Price Average_Price].each &method(:th)
                end
              end
              tbody do
                tr do
                  td do
                    minimum_event_price
                  end
                  td do
                    maximum_event_price
                  end
                  td do
                    average_event_price
                  end
                end
              end
            end

            table do
              thead do
                tr do
                  %w[not_published_events published_events canceled_events finished_events].each &method(:th)
                end
              end
              tbody do
                tr do
                  td do
                    not_published_events
                  end
                  td do
                    published_events
                  end
                  td do
                    canceled_events
                  end
                  td do
                    finished_events
                  end
                end
              end
            end

            table do
              thead do
                tr do
                  %w[location quantity].each &method(:th)
                end
              end
              tbody do
                groupped_events_by_geography.each do |g_str, g_hash|
                  tr do
                    td do
                      g_str
                    end
                    td do
                      g_hash.size
                    end
                  end
                end
              end
            end
          end
        end
      end

      column do
        extend ActiveAdmin::UserHelper

        if User.active.exists?
          panel "Users stats" do

            table do
              thead do
                tr do
                  %w[Minimun_Age Maximum_Age Average_Age].each &method(:th)
                end
              end
              tbody do
                tr do
                  td do
                    minimum_user_age
                  end
                  td do
                    maximum_user_age
                  end
                  td do
                    average_user_age
                  end
                end
              end
            end

          end
        end
      end
    end
  end
end
