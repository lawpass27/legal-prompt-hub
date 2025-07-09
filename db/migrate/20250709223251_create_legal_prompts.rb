class CreateLegalPrompts < ActiveRecord::Migration[8.0]
  def change
    create_table :legal_prompts do |t|
      t.string :title
      t.integer :category
      t.text :content
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
