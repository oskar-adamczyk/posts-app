# frozen_string_literal: true

class CreateFeedbacks < ActiveRecord::Migration[6.1]
  def change
    create_table :feedbacks, id: :uuid do |t|
      t.string :comment
      t.uuid :commentable_id
      t.string :commentable_type

      t.references :user, type: :uuid, index: true, foreign_key: true, null: false

      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :feedbacks, %i[commentable_id commentable_type]
    add_index :feedbacks, %i[commentable_id commentable_type user_id], name: :index_feedbacks_commentable_user,
                                                                       unique: true, where: "deleted_at IS NULL"
  end
end
