# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_03_22_133841) do

  create_table "active_admin_comments", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type", limit: 50
    t.bigint "resource_id"
    t.string "author_type", limit: 50
    t.bigint "author_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", length: 20
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id"
  end

  create_table "active_storage_attachments", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 140, null: false
    t.string "record_type", limit: 50, null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "key", limit: 30, null: false
    t.string "filename", limit: 200, null: false
    t.string "content_type", limit: 50
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", limit: 50, null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admin_users", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "email", limit: 80, default: "", null: false
    t.string "encrypted_password", limit: 200, default: "", null: false
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", length: 10
  end

  create_table "event_chat_msg_unreads", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "event_chat_msg_id", null: false
    t.bigint "user_id", null: false
    t.index ["event_chat_msg_id"], name: "index_event_chat_msg_unreads_on_event_chat_msg_id"
    t.index ["user_id"], name: "index_event_chat_msg_unreads_on_user_id"
  end

  create_table "event_chat_msgs", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.bigint "user_id", null: false
    t.text "msg_html"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_chat_msgs_on_event_id"
    t.index ["user_id"], name: "index_event_chat_msgs_on_user_id"
  end

  create_table "event_imgs", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "event_id", null: false
    t.integer "prio", default: 0, null: false
    t.text "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_imgs_on_event_id"
  end

  create_table "event_props", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "name"
    t.bigint "event_id", null: false
    t.integer "pos_id", default: 0, null: false, unsigned: true
    t.bigint "full_sum", default: 0, null: false, unsigned: true
    t.string "prop_pref", limit: 1, default: "N", null: false, collation: "cp1251_general_ci"
    t.text "prop_name"
    t.bigint "prop_name_sum", default: 0, null: false, unsigned: true
    t.text "prop_val"
    t.bigint "prop_val_sum", default: 0, null: false, unsigned: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id", "pos_id"], name: "index_event_props_on_event_id_and_pos_id", unique: true
    t.index ["event_id"], name: "index_event_props_on_event_id"
    t.index ["prop_name_sum"], name: "index_event_props_on_prop_name_sum"
    t.index ["prop_val_sum"], name: "index_event_props_on_prop_val_sum"
  end

  create_table "event_ticket_packs", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "name"
    t.bigint "event_id"
    t.integer "pack_capacity", default: 0, null: false
    t.integer "tickets_slotted_cnt", default: 0, null: false
    t.integer "tickets_sold_cnt", default: 0, null: false
    t.integer "tickets_pay_fail_cnt", default: 0, null: false
    t.decimal "ticket_cost_eur", precision: 8, scale: 2, default: "0.0", null: false
    t.integer "event_ticket_pack_type", limit: 1, default: 0, null: false, comment: "0-guest, 10-vip, 20-resident"
    t.integer "event_ticket_pack_sale_rule", limit: 1, default: 0, null: false, comment: "0-stopped_sale, 1-simple_sale, 2-with_confirmation"
    t.integer "tpack_version", default: 0, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_id"], name: "index_event_ticket_packs_on_event_id"
  end

  create_table "events", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "name"
    t.bigint "user_id", null: false
    t.text "description"
    t.text "house_rules"
    t.text "address"
    t.decimal "latitude", precision: 11, scale: 8
    t.decimal "longitude", precision: 11, scale: 8
    t.datetime "event_start_time"
    t.datetime "event_finish_time"
    t.integer "not_payed_slots_cnt", default: 0, null: false
    t.decimal "place_square_meters", precision: 10, scale: 2
    t.datetime "declined_at"
    t.text "search_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "visibility_status", limit: 1, default: 0, null: false
    t.decimal "rating", precision: 3, scale: 2, default: "0.0", null: false
    t.integer "event_rang_pts", default: 0, null: false, unsigned: true
    t.integer "event_version", default: 0, null: false
    t.text "geography", size: :long, collation: "utf8mb4_bin"
    t.index ["latitude", "longitude"], name: "index_events_on_latitude_and_longitude"
    t.index ["user_id"], name: "index_events_on_user_id"
    t.index ["visibility_status"], name: "index_events_on_visibility_status"
  end

  create_table "events_filter_fields", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "name"
    t.integer "show_for_client", limit: 1, default: 0, null: false, unsigned: true
    t.bigint "eff_name_sum", default: 0, null: false, unsigned: true
    t.integer "prio", default: 0, null: false, unsigned: true
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "friend_requests", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "requestor_id", null: false
    t.bigint "receiver_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["receiver_id"], name: "index_friend_requests_on_receiver_id"
    t.index ["requestor_id", "receiver_id"], name: "index_friend_requests_on_requestor_id_and_receiver_id", unique: true
    t.index ["requestor_id"], name: "index_friend_requests_on_requestor_id"
  end

  create_table "reported_users", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "report_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["report_id", "user_id"], name: "index_reported_users_on_report_id_and_user_id", unique: true
    t.index ["report_id"], name: "index_reported_users_on_report_id"
    t.index ["user_id"], name: "index_reported_users_on_user_id"
  end

  create_table "reports", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.integer "kind", default: 0, null: false
    t.bigint "reporter_id", null: false
    t.bigint "event_id", null: false
    t.integer "reason", default: 0, null: false
    t.text "description"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.bigint "admin_user_id"
    t.datetime "take_for_processing_at"
    t.integer "status", default: 0, null: false
    t.index ["event_id"], name: "index_reports_on_event_id"
    t.index ["reporter_id"], name: "index_reports_on_reporter_id"
  end

  create_table "reviews", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "reviewer_id", null: false
    t.string "assessable_type", null: false
    t.bigint "assessable_id", null: false
    t.decimal "rating", precision: 2, scale: 1, default: "0.0", null: false
    t.integer "reason", default: 0
    t.text "comment"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["assessable_type", "assessable_id"], name: "index_reviews_on_assessable_type_and_assessable_id"
    t.index ["reviewer_id"], name: "index_reviews_on_reviewer_id"
  end

  create_table "tickets", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "name"
    t.integer "ticket_status", limit: 1, default: 0, null: false, comment: "0-created, 2-payment_fail, 3-payment_refunded, 5-refund_need, 8-ticket_payed, 9-ticket_used"
    t.bigint "user_id", null: false
    t.bigint "event_ticket_pack_id", null: false
    t.integer "event_version"
    t.datetime "event_starts_at", null: false
    t.datetime "event_finish_at", null: false
    t.integer "cost_eur_cts", default: 0, null: false
    t.integer "payed_to_owner_eur_cts", default: 0, null: false
    t.integer "for_owner_eur_cts", default: 0, null: false
    t.datetime "ticket_checkout_at"
    t.datetime "ticket_payed_at"
    t.datetime "ticket_used_at"
    t.text "search_text"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["event_ticket_pack_id"], name: "index_tickets_on_event_ticket_pack_id"
    t.index ["user_id"], name: "index_tickets_on_user_id"
  end

  create_table "tickets_payments", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.string "gateway_name", limit: 8, null: false
    t.text "gateway_payment_id"
    t.integer "gateway_payment_need_check", limit: 1, default: 0, null: false
    t.integer "amount_cts", null: false
    t.integer "amount_accepted_cts", default: 0, null: false
    t.integer "amount_refunded_cts", default: 0, null: false
    t.integer "application_fee_amount_cts", default: 0, null: false
    t.string "currency", limit: 16, default: "", null: false
    t.string "card_type", limit: 30, default: ""
    t.string "card_last4", limit: 8, default: ""
    t.string "card_exp_month", limit: 4, default: ""
    t.string "card_exp_year", limit: 8, default: ""
    t.text "request_info_json"
    t.text "response_data_json"
    t.datetime "payment_accepted_at"
    t.datetime "payment_refunded_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["ticket_id"], name: "index_tickets_payments_on_ticket_id"
  end

  create_table "user_notifications", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.text "notification_msg_text"
    t.text "notification_data_json", size: :long, collation: "utf8mb4_bin"
    t.datetime "sended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_notifications_on_user_id"
  end

  create_table "user_push_subscriptions", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_id"
    t.text "push_subscription_data_json", size: :long
    t.datetime "last_success_sended_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_push_subscriptions_on_user_id"
  end

  create_table "user_route_points", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_route_id", null: false
    t.bigint "user_station_id", null: false
    t.integer "after_start_planned_seconds", default: 0, null: false
    t.integer "station_stay_seconds", default: 0, null: false
    t.integer "tickets_cnt", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_route_id"], name: "index_user_route_points_on_user_route_id"
    t.index ["user_station_id"], name: "index_user_route_points_on_user_station_id"
  end

  create_table "user_routes", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "name", limit: 240, default: "", null: false
    t.bigint "user_id", null: false
    t.bigint "vehicle_id", null: false
    t.integer "published", limit: 1, default: 0, null: false
    t.text "route_props_text"
    t.text "search_text"
    t.bigint "starts_at_unix", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_routes_on_user_id"
    t.index ["vehicle_id"], name: "index_user_routes_on_vehicle_id"
  end

  create_table "user_station_imgs", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "user_station_id", null: false
    t.integer "prio", default: 0, null: false
    t.text "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_station_id"], name: "index_user_station_imgs_on_user_station_id"
  end

  create_table "user_stations", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 240, default: "", null: false
    t.bigint "user_id", null: false
    t.text "station_description_text"
    t.text "station_props_text"
    t.integer "station_lat", default: 0, null: false
    t.integer "station_lng", default: 0, null: false
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_user_stations_on_user_id"
  end

  create_table "users", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.text "name"
    t.string "email", limit: 150, default: "", null: false
    t.text "last_name"
    t.text "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "password_changed_at"
    t.text "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.text "bio"
    t.text "phone"
    t.text "gender"
    t.text "facebook_link"
    t.text "instagram_link"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.datetime "deleted_at"
    t.text "deleted_with_email"
    t.integer "current_password_unknown", limit: 1, default: 0, null: false
    t.string "encrypted_password", limit: 250, default: "", null: false
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.text "current_sign_in_ip"
    t.text "last_sign_in_ip"
    t.text "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.text "unlock_token"
    t.datetime "locked_at"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", length: 8
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", length: 8
    t.index ["unlock_token"], name: "index_users_on_unlock_token", length: 8
  end

  create_table "vehicle_imgs", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "vehicle_id", null: false
    t.integer "prio", default: 0, null: false
    t.text "name"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["vehicle_id"], name: "index_vehicle_imgs_on_vehicle_id"
  end

  create_table "vehicles", options: "ENGINE=MyISAM DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", limit: 240, default: "", null: false
    t.bigint "user_id", null: false
    t.text "vehicle_description_text"
    t.text "vehicle_props_text"
    t.datetime "deleted_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id"], name: "index_vehicles_on_user_id"
  end

end
