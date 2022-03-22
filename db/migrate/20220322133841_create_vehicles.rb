class CreateVehicles < ActiveRecord::Migration[6.0]
  def change
    create_table :vehicles, { options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci" } do |t|
      t.string :name, null: false, default: "", limit: 240
      t.references :user, foreign_key: true, null: false, index: true
      t.text :vehicle_description_text
      t.text :vehicle_props_text
      t.datetime :deleted_at
      t.timestamps null: false
    end

    create_table :vehicle_imgs, { options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci" } do |t|
      t.references :vehicle, null: false, foreign_key: true, index: true
      t.integer :prio, limit: 4, null: false, default: 0
      t.text :name
      t.datetime :deleted_at
      t.timestamps null: false
    end

    create_table :user_stations, { options: "ENGINE=MyISAM DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci" } do |t|
      t.string :name, null: false, default: "", limit: 240
      t.references :user, foreign_key: true, null: false, index: true
      t.text :station_description_text
      t.text :station_props_text
      t.integer :station_lat, limit: 4, null: false, default: 0
      t.integer :station_lng, limit: 4, null: false, default: 0
      t.datetime :deleted_at
      t.timestamps null: false
    end

    create_table :user_station_imgs, { options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci" } do |t|
      t.references :user_station, null: false, foreign_key: true, index: true
      t.integer :prio, limit: 4, null: false, default: 0
      t.text :name
      t.datetime :deleted_at
      t.timestamps null: false
    end

    create_table :user_routes, { options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci" } do |t|
      t.string :name, null: false, default: "", limit: 240
      t.references :user, foreign_key: true, null: false, index: true
      t.references :vehicle, foreign_key: true, null: false, index: true
      t.integer :published, limit: 1, null: false, default: 0
      t.text :route_props_text
      t.text :search_text
      t.bigint :starts_at_unix, null: false, default: 0
      t.datetime :deleted_at
      t.timestamps null: false
    end

    create_table :user_route_points, { options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci" } do |t|
      t.references :user_route, null: false, foreign_key: true, index: true
      t.references :user_station, null: false, foreign_key: true, index: true
      t.integer :after_start_planned_seconds, limit: 4, null: false, default: 0
      t.integer :station_stay_seconds, limit: 4, null: false, default: 0
      t.integer :tickets_cnt, limit: 4, null: false, default: 0
      t.datetime :deleted_at
      t.timestamps null: false
    end
  end
end
