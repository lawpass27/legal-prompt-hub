class AddDescriptionToLegalPrompts < ActiveRecord::Migration[8.0]
  def change
    add_column :legal_prompts, :description, :text
  end
end
