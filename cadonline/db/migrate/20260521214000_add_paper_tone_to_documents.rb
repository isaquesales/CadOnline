class AddPaperToneToDocuments < ActiveRecord::Migration[8.1]
  def change
    add_column :documents, :paper_tone, :string, null: false, default: "default"
  end
end
