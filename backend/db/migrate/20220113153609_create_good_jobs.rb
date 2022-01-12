# frozen_string_literal: true

class CreateGoodJobs < ActiveRecord::Migration[6.1]
  def change
    create_table :good_jobs, id: :uuid do |t|
      t.uuid :active_job_id
      t.text :error
      t.timestamp :finished_at
      t.timestamp :performed_at
      t.integer :priority
      t.text :queue_name
      t.timestamp :scheduled_at
      t.jsonb :serialized_params

      t.timestamps null: false
    end

    add_index :good_jobs, :scheduled_at, where: "(finished_at IS NULL)"
    add_index :good_jobs, %i[queue_name scheduled_at], where: "(finished_at IS NULL)"
  end
end
