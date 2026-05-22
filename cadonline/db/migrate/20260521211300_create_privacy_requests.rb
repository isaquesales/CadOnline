class CreatePrivacyRequests < ActiveRecord::Migration[8.1]
  def change
    create_table :privacy_requests do |t|
      t.references :user, null: false, foreign_key: true
      t.string :request_type, null: false
      t.string :status, null: false, default: "pending"
      t.text :notes

      t.timestamps
    end

    add_index :privacy_requests, [ :user_id, :request_type, :created_at ]
  end
end
