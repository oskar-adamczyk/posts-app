# frozen_string_literal: true

class DenormalizeOriginIpsToUser < ActiveRecord::Migration[6.1]
  def change
    create_table :origin_ips, id: :uuid do |t|
      t.string :address, null: false, limit: 45
      t.json :authors, null: false, default: []

      t.datetime :deleted_at
      t.timestamps null: false
    end

    add_index :origin_ips, "address", unique: true, where: "deleted_at IS NULL"
  end
end
