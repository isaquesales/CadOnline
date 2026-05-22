class CreateDocuments < ActiveRecord::Migration[8.1]
  def change
    create_table :documents do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title, null: false, default: "Documento sem titulo"
      t.string :paper_style, null: false, default: "ruled"
      t.json :content, null: false, default: {}
      t.boolean :archived, null: false, default: false

      t.timestamps
    end

    add_index :documents, [ :user_id, :updated_at ]
  end
end
