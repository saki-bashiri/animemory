# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20140427155807) do

  create_table "amazon_products", :force => true do |t|
    t.string   "asin",                          :null => false
    t.boolean  "top_ad_flg", :default => false, :null => false
    t.boolean  "lst_ad_flg", :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "amazon_products", ["asin"], :name => "asin"
  add_index "amazon_products", ["lst_ad_flg"], :name => "lst_ad_flg"
  add_index "amazon_products", ["top_ad_flg"], :name => "top_ad_flg"

  create_table "anime_amazon_advertises", :force => true do |t|
    t.integer "anime_id",          :null => false
    t.integer "amazon_product_id", :null => false
  end

  add_index "anime_amazon_advertises", ["amazon_product_id"], :name => "amazon_product_id"
  add_index "anime_amazon_advertises", ["anime_id"], :name => "anime_id"

  create_table "anime_counts", :force => true do |t|
    t.integer  "anime_id",                             :null => false
    t.integer  "favorite_count",                       :null => false
    t.integer  "watch_count",           :default => 0, :null => false
    t.integer  "comment_count",         :default => 0, :null => false
    t.integer  "total_pv_count",        :default => 0, :null => false
    t.integer  "story_fav_count",       :default => 0, :null => false
    t.integer  "voice_fav_count",       :default => 0, :null => false
    t.integer  "chara_fav_count",       :default => 0, :null => false
    t.integer  "animation_fav_count",   :default => 0, :null => false
    t.integer  "performance_fav_count", :default => 0, :null => false
    t.integer  "sound_fav_count",       :default => 0, :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  add_index "anime_counts", ["anime_id"], :name => "index_anime_counts_on_anime_id"
  add_index "anime_counts", ["anime_id"], :name => "unique_index_anime_id", :unique => true

  create_table "anime_histories", :force => true do |t|
    t.integer  "anime_id"
    t.string   "title",                              :null => false
    t.string   "other_title"
    t.string   "kana",                               :null => false
    t.text     "outline"
    t.date     "started_on"
    t.date     "finished_on"
    t.integer  "total_episode"
    t.boolean  "movie_flg",       :default => false, :null => false
    t.boolean  "tokusatsu_flg",   :default => false, :null => false
    t.integer  "status",          :default => 1,     :null => false
    t.integer  "production_id"
    t.integer  "fastest_weekday"
    t.integer  "mylist_count",    :default => 0,     :null => false
    t.integer  "user_id",                            :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "revision_id",     :default => 0,     :null => false
    t.string   "comment",         :default => "",    :null => false
  end

  add_index "anime_histories", ["anime_id"], :name => "index_anime_histories_on_anime_id"
  add_index "anime_histories", ["revision_id"], :name => "index_anime_histories_on_revision_id"
  add_index "anime_histories", ["user_id"], :name => "index_anime_histories_on_user_id"

  create_table "anime_image_revisions", :force => true do |t|
    t.integer  "anime_image_id", :default => 0, :null => false
    t.integer  "user_id",        :default => 0, :null => false
    t.integer  "draft_flg",      :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "anime_image_revisions", ["anime_image_id"], :name => "anime_image_id"
  add_index "anime_image_revisions", ["user_id"], :name => "user_id"

  create_table "anime_images", :force => true do |t|
    t.integer  "anime_id",                  :default => 0,     :null => false
    t.integer  "user_id",                   :default => 0,     :null => false
    t.string   "comment",    :limit => 200, :default => ""
    t.integer  "image_type",                :default => 0,     :null => false
    t.integer  "status",                    :default => 1,     :null => false
    t.integer  "sort",                      :default => 1,     :null => false
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
    t.boolean  "draft_flg",                 :default => false, :null => false
  end

  add_index "anime_images", ["anime_id"], :name => "anime_id"
  add_index "anime_images", ["draft_flg"], :name => "draft_flg"
  add_index "anime_images", ["image_type"], :name => "image_type"
  add_index "anime_images", ["sort"], :name => "sort"
  add_index "anime_images", ["status"], :name => "status"
  add_index "anime_images", ["user_id"], :name => "user_id"

  create_table "anime_main_image_revisions", :force => true do |t|
    t.integer  "anime_image_id",   :default => 0, :null => false
    t.integer  "anime_history_id", :default => 0, :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "anime_main_image_revisions", ["anime_history_id"], :name => "anime_history_id", :unique => true
  add_index "anime_main_image_revisions", ["anime_image_id"], :name => "anime_image_id"

  create_table "anime_main_images", :force => true do |t|
    t.integer  "anime_id",       :default => 0, :null => false
    t.integer  "anime_image_id", :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "anime_main_images", ["anime_id"], :name => "anime_id", :unique => true

  create_table "anime_reports", :force => true do |t|
    t.integer  "anime_id",       :null => false
    t.integer  "report_type",    :null => false
    t.datetime "reported_on",    :null => false
    t.integer  "target"
    t.integer  "target_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "anime_image_id"
  end

  add_index "anime_reports", ["anime_id"], :name => "anime_id"
  add_index "anime_reports", ["report_type"], :name => "report_type"
  add_index "anime_reports", ["reported_on"], :name => "reported_on"

  create_table "anime_scores", :force => true do |t|
    t.integer  "anime_id",                      :null => false
    t.integer  "favorite_count", :default => 0, :null => false
    t.integer  "watching_count", :default => 0, :null => false
    t.integer  "watched_count",  :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "anime_scores", ["anime_id"], :name => "index_anime_scores_on_anime_id", :unique => true
  add_index "anime_scores", ["favorite_count"], :name => "index_anime_scores_on_favorite_count"
  add_index "anime_scores", ["watched_count"], :name => "index_anime_scores_on_watched_count"
  add_index "anime_scores", ["watching_count"], :name => "index_anime_scores_on_watching_count"

  create_table "anime_threads", :force => true do |t|
    t.integer  "anime_id",       :default => 0,     :null => false
    t.integer  "user_id",                           :null => false
    t.integer  "episode_id"
    t.string   "title",                             :null => false
    t.integer  "total_comment",  :default => 1,     :null => false
    t.integer  "status",         :default => 1,     :null => false
    t.integer  "favorite_count", :default => 0,     :null => false
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.boolean  "no_episode_flg", :default => false, :null => false
  end

  create_table "animes", :force => true do |t|
    t.string   "title",                                   :null => false
    t.string   "other_title"
    t.string   "kana",                                    :null => false
    t.integer  "shoboi_tid"
    t.text     "outline"
    t.date     "started_on"
    t.date     "finished_on"
    t.boolean  "finish_flg",           :default => false, :null => false
    t.integer  "total_episode"
    t.boolean  "movie_flg",            :default => false, :null => false
    t.boolean  "tokusatsu_flg",        :default => false, :null => false
    t.integer  "status",               :default => 1,     :null => false
    t.integer  "production_id"
    t.string   "production_committee"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  add_index "animes", ["created_at"], :name => "created_at"
  add_index "animes", ["finish_flg"], :name => "finish_flg"
  add_index "animes", ["kana"], :name => "kana"
  add_index "animes", ["other_title"], :name => "other_title"
  add_index "animes", ["shoboi_tid"], :name => "shoboi_tid", :unique => true
  add_index "animes", ["status"], :name => "status"
  add_index "animes", ["title"], :name => "unique_index_title", :unique => true

  create_table "artist_revisions", :force => true do |t|
    t.integer  "artist_id",        :default => 0,  :null => false
    t.string   "name",             :default => "", :null => false
    t.string   "kana",             :default => "", :null => false
    t.string   "nickname",         :default => ""
    t.datetime "birthday"
    t.text     "description"
    t.integer  "unit_flg",         :default => 0,  :null => false
    t.integer  "voice_actor_flg",  :default => 0,  :null => false
    t.integer  "office_id",        :default => 0,  :null => false
    t.integer  "record_office_id", :default => 0,  :null => false
    t.integer  "singer_flg",       :default => 0,  :null => false
    t.integer  "composer_flg",     :default => 0,  :null => false
    t.integer  "songwriter_flg",   :default => 0,  :null => false
    t.integer  "user_id",                          :null => false
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.string   "unit_ids",         :default => ""
  end

  create_table "artists", :force => true do |t|
    t.string   "name",                           :null => false
    t.string   "kana"
    t.string   "nickname"
    t.datetime "birthday"
    t.text     "description"
    t.integer  "unit_flg",        :default => 0, :null => false
    t.integer  "voice_actor_flg", :default => 0, :null => false
    t.integer  "singer_flg",      :default => 0, :null => false
    t.integer  "composer_flg",    :default => 0, :null => false
    t.integer  "songwriter_flg",  :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "artists", ["composer_flg"], :name => "composer_flg"
  add_index "artists", ["kana"], :name => "kana"
  add_index "artists", ["name"], :name => "unique_index_name", :unique => true
  add_index "artists", ["singer_flg"], :name => "singer_flg"
  add_index "artists", ["songwriter_flg"], :name => "songwriter_flg"
  add_index "artists", ["voice_actor_flg"], :name => "voice_actor_flg"

  create_table "boards", :force => true do |t|
    t.string   "sub_domain", :null => false
    t.string   "dir",        :null => false
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "cds", :force => true do |t|
    t.string   "title",       :null => false
    t.integer  "song_id"
    t.integer  "anime_id"
    t.date     "released_on"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "cds", ["anime_id"], :name => "index_cds_on_anime_id"
  add_index "cds", ["song_id"], :name => "index_cds_on_song_id"

  create_table "channel_notifications", :force => true do |t|
    t.integer  "creator_id",     :null => false
    t.integer  "anime_id",       :null => false
    t.integer  "staff_id"
    t.integer  "song_artist_id"
    t.integer  "character_id"
    t.datetime "created_at",     :null => false
  end

  add_index "channel_notifications", ["anime_id"], :name => "anime_id"
  add_index "channel_notifications", ["character_id"], :name => "character_id"
  add_index "channel_notifications", ["created_at"], :name => "created_at"
  add_index "channel_notifications", ["creator_id"], :name => "creator_id"
  add_index "channel_notifications", ["song_artist_id"], :name => "song_artist_id"
  add_index "channel_notifications", ["staff_id"], :name => "staff_id"

  create_table "character_revisions", :force => true do |t|
    t.integer  "character_id", :default => 0,  :null => false
    t.integer  "anime_id",     :default => 0,  :null => false
    t.integer  "artist_id",    :default => 0
    t.string   "name",         :default => "", :null => false
    t.string   "kana",         :default => "", :null => false
    t.text     "description",                  :null => false
    t.integer  "status",       :default => 1,  :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  create_table "characters", :force => true do |t|
    t.integer  "anime_id",                   :null => false
    t.integer  "artist_id"
    t.integer  "creator_id",  :default => 0, :null => false
    t.string   "name",                       :null => false
    t.string   "kana"
    t.integer  "chara_sort",  :default => 0, :null => false
    t.text     "description"
    t.integer  "status",      :default => 1, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "characters", ["anime_id", "chara_sort"], :name => "anime_chara_sort"
  add_index "characters", ["anime_id"], :name => "index_characters_on_anime_id"
  add_index "characters", ["artist_id"], :name => "index_characters_on_voice_actor_id"
  add_index "characters", ["name"], :name => "name"

  create_table "comments", :force => true do |t|
    t.integer  "anime_id",                       :null => false
    t.integer  "user_id",                        :null => false
    t.integer  "anime_thread_id", :default => 0, :null => false
    t.text     "comment",                        :null => false
    t.integer  "status",          :default => 1, :null => false
    t.integer  "favorite_count",  :default => 0, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "anchor",          :default => 0, :null => false
  end

  add_index "comments", ["anime_thread_id", "anchor"], :name => "anchor", :unique => true

  create_table "creator_revisions", :force => true do |t|
    t.integer  "creator_id",    :default => 0,  :null => false
    t.string   "name",          :default => "", :null => false
    t.integer  "main_role_id",  :default => 0,  :null => false
    t.integer  "main_anime_id", :default => 0,  :null => false
    t.text     "description"
    t.integer  "user_id",       :default => 0,  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "creators", :force => true do |t|
    t.string   "name",                               :null => false
    t.string   "kana"
    t.text     "description"
    t.boolean  "staff_flg",       :default => false, :null => false
    t.boolean  "production_flg",  :default => false, :null => false
    t.boolean  "unit_flg",        :default => false, :null => false
    t.boolean  "voice_actor_flg", :default => false, :null => false
    t.boolean  "singer_flg",      :default => false, :null => false
    t.boolean  "songwriter_flg",  :default => false, :null => false
    t.boolean  "composer_flg",    :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "creators", ["composer_flg"], :name => "composer_flg"
  add_index "creators", ["name"], :name => "index_creators_on_name", :unique => true
  add_index "creators", ["production_flg"], :name => "production_flg"
  add_index "creators", ["singer_flg"], :name => "singer_flg"
  add_index "creators", ["songwriter_flg"], :name => "songwriter_flg"
  add_index "creators", ["staff_flg"], :name => "staff_flg"
  add_index "creators", ["unit_flg"], :name => "unit_flg"
  add_index "creators", ["voice_actor_flg"], :name => "voice_actor_flg"

  create_table "daily_anime_counts", :force => true do |t|
    t.integer  "anime_id",                      :null => false
    t.date     "day",                           :null => false
    t.integer  "favorite_count", :default => 0, :null => false
    t.integer  "watch_count",    :default => 0, :null => false
    t.integer  "comment_count",  :default => 0, :null => false
    t.integer  "pv_count",       :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "episode_memories", :force => true do |t|
    t.integer  "episode_id",                  :null => false
    t.integer  "anime_id",                    :null => false
    t.integer  "user_id",                     :null => false
    t.integer  "watch_status", :default => 0, :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "episode_memories", ["anime_id"], :name => "index_episode_memories_on_anime_id"
  add_index "episode_memories", ["episode_id", "user_id"], :name => "index_episode_memories_on_episode_id_and_user_id", :unique => true
  add_index "episode_memories", ["updated_at"], :name => "index_episode_memories_on_updated_at"
  add_index "episode_memories", ["user_id"], :name => "index_episode_memories_on_user_id"
  add_index "episode_memories", ["watch_status"], :name => "index_episode_memories_on_watch_status"

  create_table "episodes", :force => true do |t|
    t.integer  "anime_id",      :default => 0, :null => false
    t.integer  "episode"
    t.string   "subtitle"
    t.integer  "watched_count", :default => 0, :null => false
    t.integer  "status",        :default => 1, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "episodes", ["anime_id"], :name => "anime_id"
  add_index "episodes", ["episode"], :name => "episode"
  add_index "episodes", ["status"], :name => "status"
  add_index "episodes", ["watched_count"], :name => "watched_count"

  create_table "ip_comments", :force => true do |t|
    t.integer  "episode_id", :null => false
    t.integer  "anime_id",   :null => false
    t.string   "ip_address", :null => false
    t.text     "content",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "ip_comments", ["anime_id"], :name => "index_ip_comments_on_anime_id", :unique => true
  add_index "ip_comments", ["episode_id"], :name => "index_ip_comments_on_episode_id", :unique => true
  add_index "ip_comments", ["ip_address"], :name => "index_ip_comments_on_ip_address"

  create_table "media", :force => true do |t|
    t.string   "name",                       :null => false
    t.string   "other_name"
    t.integer  "media_type",                 :null => false
    t.string   "hp_url"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "area_id",     :default => 0, :null => false
    t.integer  "shoboi_chid"
  end

  add_index "media", ["area_id"], :name => "area_id"
  add_index "media", ["name"], :name => "unique_index_name", :unique => true
  add_index "media", ["shoboi_chid"], :name => "shoboi_chid", :unique => true

  create_table "my_channels", :force => true do |t|
    t.integer "user_id",    :null => false
    t.integer "creator_id", :null => false
  end

  add_index "my_channels", ["creator_id"], :name => "creator_id"
  add_index "my_channels", ["user_id", "creator_id"], :name => "user_creator_id", :unique => true

  create_table "mymemories", :force => true do |t|
    t.integer  "user_id",                                :null => false
    t.integer  "anime_id",                               :null => false
    t.boolean  "favorite_flg",        :default => false, :null => false
    t.integer  "watch_status",        :default => 0,     :null => false
    t.integer  "myfolder_id"
    t.string   "memo"
    t.integer  "story_fav_flg",       :default => 0
    t.integer  "voice_fav_flg",       :default => 0
    t.integer  "chara_fav_flg",       :default => 0
    t.integer  "animation_fav_flg",   :default => 0
    t.integer  "performance_fav_flg", :default => 0
    t.integer  "sound_fav_flg"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "mymemories", ["anime_id"], :name => "anime_id"
  add_index "mymemories", ["user_id", "anime_id"], :name => "index_mymemories_on_user_id_and_anime_id"

  create_table "on_air_schedules", :force => true do |t|
    t.integer  "episode_id",                     :null => false
    t.integer  "anime_id",                       :null => false
    t.integer  "medium_id",                      :null => false
    t.datetime "on_air_time"
    t.integer  "offset",      :default => 0,     :null => false
    t.integer  "span",        :default => 30,    :null => false
    t.integer  "weekday",                        :null => false
    t.integer  "status",      :default => 1,     :null => false
    t.boolean  "repeat_flg",  :default => false, :null => false
    t.boolean  "new_flg",     :default => false, :null => false
    t.boolean  "last_flg",    :default => false, :null => false
    t.string   "memo"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "on_air_schedules", ["anime_id"], :name => "index_on_air_schedules_on_anime_id"
  add_index "on_air_schedules", ["episode_id"], :name => "episode_id"
  add_index "on_air_schedules", ["last_flg"], :name => "last_flg"
  add_index "on_air_schedules", ["medium_id"], :name => "medium_id"
  add_index "on_air_schedules", ["new_flg"], :name => "new_flg"
  add_index "on_air_schedules", ["weekday"], :name => "weekday"

  create_table "origin_revisions", :force => true do |t|
    t.integer  "origin_id",     :default => 0,  :null => false
    t.string   "title",         :default => "", :null => false
    t.integer  "original_type", :default => 0,  :null => false
    t.text     "description",                   :null => false
    t.integer  "status",        :default => 1,  :null => false
    t.integer  "user_id",       :default => 0,  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "origins", :force => true do |t|
    t.string   "title",                        :null => false
    t.integer  "original_type", :default => 0, :null => false
    t.text     "description"
    t.integer  "status",        :default => 1, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "origins", ["title"], :name => "unique_index_title", :unique => true

  create_table "outside_sites", :force => true do |t|
    t.string   "site_name",                 :null => false
    t.string   "url",                       :null => false
    t.string   "rss_url",                   :null => false
    t.integer  "status",     :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "outside_sites", ["status"], :name => "status"

  create_table "outside_summaries", :force => true do |t|
    t.integer  "site_type",       :null => false
    t.string   "url",             :null => false
    t.string   "title",           :null => false
    t.datetime "posted_at",       :null => false
    t.string   "description"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.integer  "outside_site_id"
  end

  add_index "outside_summaries", ["outside_site_id"], :name => "outside_site_id"
  add_index "outside_summaries", ["posted_at"], :name => "posted_at"
  add_index "outside_summaries", ["site_type"], :name => "site_type"
  add_index "outside_summaries", ["url"], :name => "url"

  create_table "production_revisions", :force => true do |t|
    t.integer  "production_id", :default => 0,  :null => false
    t.string   "name",          :default => "", :null => false
    t.string   "kana",          :default => "", :null => false
    t.text     "description"
    t.integer  "status",        :default => 0,  :null => false
    t.integer  "user_id",       :default => 0,  :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  create_table "productions", :force => true do |t|
    t.string   "name",        :default => "", :null => false
    t.string   "kana",        :default => ""
    t.text     "description"
    t.integer  "status",      :default => 0,  :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "productions", ["name"], :name => "unique_index_name", :unique => true

  create_table "read_channel_notifications", :force => true do |t|
    t.integer "user_id",                 :null => false
    t.integer "channel_notification_id", :null => false
  end

  add_index "read_channel_notifications", ["channel_notification_id"], :name => "channel_notification_id"
  add_index "read_channel_notifications", ["user_id"], :name => "user_id"

  create_table "roles", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.string   "comment",    :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "roles", ["name"], :name => "unique_index_name", :unique => true

  create_table "singer_units", :force => true do |t|
    t.integer  "unit_id"
    t.integer  "singer_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "singer_units", ["singer_id"], :name => "index_singer_units_on_singer_id"
  add_index "singer_units", ["unit_id"], :name => "index_singer_units_on_unit_id"

  create_table "song_artists", :force => true do |t|
    t.integer "song_id",                         :null => false
    t.integer "artist_id"
    t.integer "creator_id",       :default => 0, :null => false
    t.integer "song_artist_type",                :null => false
    t.integer "artist_sort",      :default => 0, :null => false
  end

  add_index "song_artists", ["artist_id"], :name => "artist_id"
  add_index "song_artists", ["song_artist_type"], :name => "song_artist_type"
  add_index "song_artists", ["song_id", "song_artist_type", "artist_id"], :name => "song_artist", :unique => true
  add_index "song_artists", ["song_id", "song_artist_type", "artist_sort"], :name => "song_artist_sort"

  create_table "song_histories", :force => true do |t|
    t.integer  "song_id",                      :null => false
    t.integer  "anime_id"
    t.string   "title",                        :null => false
    t.integer  "singer_id"
    t.integer  "composer_id"
    t.integer  "songwriter_id"
    t.integer  "song_type"
    t.text     "description"
    t.integer  "status"
    t.integer  "editor_id",                    :null => false
    t.integer  "revision_id",   :default => 0, :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "song_histories", ["editor_id"], :name => "index_song_histories_on_editor_id"
  add_index "song_histories", ["revision_id"], :name => "index_song_histories_on_revision_id"
  add_index "song_histories", ["song_id"], :name => "index_song_histories_on_song_id"

  create_table "songs", :force => true do |t|
    t.integer  "anime_id"
    t.string   "title",       :null => false
    t.integer  "song_type"
    t.text     "description"
    t.integer  "status"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "songs", ["anime_id"], :name => "index_songs_on_anime_id"

  create_table "staffs", :force => true do |t|
    t.integer  "anime_id",     :default => 0,  :null => false
    t.integer  "creator_id",   :default => 0,  :null => false
    t.integer  "role_id",      :default => 0
    t.integer  "creator_sort", :default => 0,  :null => false
    t.string   "special_role", :default => ""
    t.integer  "status",       :default => 1,  :null => false
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
  end

  add_index "staffs", ["anime_id", "role_id", "creator_id"], :name => "anime_staffs", :unique => true
  add_index "staffs", ["creator_id"], :name => "creator_id"
  add_index "staffs", ["creator_sort"], :name => "creator_sort"
  add_index "staffs", ["role_id"], :name => "role_id"

  create_table "summaries", :force => true do |t|
    t.integer  "user_id",                        :null => false
    t.string   "title",          :default => "", :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "thread_log_id"
    t.integer  "anime_image_id"
    t.integer  "anime_id",       :default => 0,  :null => false
    t.integer  "episode_id"
    t.string   "description"
  end

  add_index "summaries", ["anime_id"], :name => "anime_id"
  add_index "summaries", ["created_at"], :name => "created_at"
  add_index "summaries", ["episode_id"], :name => "episode_id"
  add_index "summaries", ["thread_log_id"], :name => "anime_thread_id"
  add_index "summaries", ["user_id"], :name => "user_id"

  create_table "summary_comments", :force => true do |t|
    t.integer  "summary_id",         :null => false
    t.integer  "comment_number",     :null => false
    t.text     "content",            :null => false
    t.integer  "summary_content_id"
    t.integer  "content_res_number"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "summary_comments", ["created_at"], :name => "created_at"
  add_index "summary_comments", ["summary_content_id", "content_res_number"], :name => "summary_content_res", :unique => true
  add_index "summary_comments", ["summary_id", "comment_number"], :name => "summary_res", :unique => true

  create_table "summary_contents", :force => true do |t|
    t.integer  "summary_id",                             :null => false
    t.integer  "sort",                    :default => 0, :null => false
    t.text     "content",                                :null => false
    t.integer  "anchor"
    t.string   "post_cd",    :limit => 9
    t.string   "name"
    t.datetime "posted_at"
  end

  add_index "summary_contents", ["summary_id", "sort"], :name => "summary_id_sort", :unique => true

  create_table "summary_images", :force => true do |t|
    t.integer "summary_id",                        :null => false
    t.integer "summary_content_id"
    t.integer "anime_image_id",                    :null => false
    t.integer "image_sort",         :default => 0, :null => false
  end

  add_index "summary_images", ["summary_content_id", "image_sort"], :name => "summary_content_sort"
  add_index "summary_images", ["summary_id"], :name => "summary_id"

  create_table "summary_responses", :force => true do |t|
    t.integer  "summary_id", :null => false
    t.integer  "res_sort",   :null => false
    t.text     "content",    :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "summary_responses", ["created_at"], :name => "created_at"
  add_index "summary_responses", ["summary_id", "res_sort"], :name => "summary_res", :unique => true

  create_table "tag_groups", :force => true do |t|
    t.integer  "anime_id",   :null => false
    t.integer  "tag_id",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tag_groups", ["anime_id", "tag_id"], :name => "unique_anime_tag", :unique => true
  add_index "tag_groups", ["tag_id"], :name => "tag_id"

  create_table "tags", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "tags", ["name"], :name => "unique_index_name", :unique => true

  create_table "test", :id => false, :force => true do |t|
    t.integer "id", :null => false
  end

  create_table "thread_logs", :force => true do |t|
    t.integer  "board_id",                      :null => false
    t.integer  "dat_cd",                        :null => false
    t.string   "subject",                       :null => false
    t.integer  "count",      :default => 0,     :null => false
    t.integer  "anime_id"
    t.boolean  "drop_flg",   :default => false, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "thread_logs", ["anime_id"], :name => "anime_id"
  add_index "thread_logs", ["dat_cd"], :name => "dat_cd", :unique => true

  create_table "thread_responses", :force => true do |t|
    t.integer  "thread_log_id",                                    :null => false
    t.integer  "anchor",                                           :null => false
    t.string   "post_cd",       :limit => 9,    :default => "",    :null => false
    t.string   "name"
    t.string   "content",       :limit => 4096, :default => "",    :null => false
    t.datetime "posted_at",                                        :null => false
    t.integer  "anime_id"
    t.boolean  "delete_flg",                    :default => false, :null => false
  end

  add_index "thread_responses", ["anime_id"], :name => "anime_id"
  add_index "thread_responses", ["thread_log_id"], :name => "thread_log_id"

  create_table "units", :force => true do |t|
    t.integer "unit_id",    :default => 0, :null => false
    t.integer "artist_id",  :default => 0
    t.integer "creator_id", :default => 0, :null => false
    t.integer "unit_sort",  :default => 0, :null => false
  end

  add_index "units", ["artist_id"], :name => "artist_id"
  add_index "units", ["unit_id"], :name => "unit_id"

  create_table "user_counts", :force => true do |t|
    t.integer  "user_id",                       :null => false
    t.integer  "favorite_count", :default => 0, :null => false
    t.integer  "watching_count", :default => 0, :null => false
    t.integer  "watched_count",  :default => 0, :null => false
    t.integer  "access_count",   :default => 0, :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "user_counts", ["user_id"], :name => "user_id"

  create_table "user_infos", :force => true do |t|
    t.integer  "user_id",                     :null => false
    t.string   "mail_address", :limit => 200, :null => false
    t.string   "password",     :limit => 20,  :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "user_infos", ["mail_address"], :name => "mail_address", :unique => true
  add_index "user_infos", ["user_id"], :name => "user_id", :unique => true

  create_table "user_media", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "medium_id",  :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_media", ["user_id", "medium_id"], :name => "user_unique_medium_id", :unique => true

  create_table "users", :force => true do |t|
    t.string   "nickname",                                                 :null => false
    t.integer  "register_type",                                            :null => false
    t.integer  "twitter_cd",                   :limit => 8, :default => 0, :null => false
    t.string   "profile_image_url"
    t.string   "profile_background_image_url"
    t.integer  "status",                                                   :null => false
    t.integer  "admin_status",                              :default => 0, :null => false
    t.datetime "created_at",                                               :null => false
    t.datetime "updated_at",                                               :null => false
  end

  add_index "users", ["admin_status"], :name => "admin_status"

  create_table "with_origin_animes", :force => true do |t|
    t.integer  "origin_id",  :default => 0, :null => false
    t.integer  "anime_id",   :default => 0, :null => false
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "with_origin_animes", ["anime_id"], :name => "index_with_origin_animes_on_anime_id"
  add_index "with_origin_animes", ["origin_id"], :name => "index_with_origin_animes_on_origin_id"

end
