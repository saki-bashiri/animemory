class ChangeColumnThreadId < ActiveRecord::Migration
  def up
    rename_column :summaries, :anime_thread_id, :thread_log_id
  end

  def down
  end
end
