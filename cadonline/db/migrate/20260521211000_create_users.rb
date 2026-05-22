class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :email, null: false
      t.string :password_digest, null: false
      t.string :full_name, null: false
      t.boolean :accepted_terms, null: false, default: false
      t.datetime :accepted_terms_at
      t.datetime :last_sign_in_at

      t.timestamps
    end

    add_index :users, :email, unique: true
  end
end
