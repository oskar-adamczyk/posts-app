# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks do |t|
      t.string  :comment
      t.bigint  :commentable_id
      t.string  :commentable_type

      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :feedbacks, %i[commentable_id commentable_type]
  end
end
