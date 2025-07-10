class CreateJoinTableLegalPromptsTag < ActiveRecord::Migration[8.0]
  def change
    create_join_table :legal_prompts, :tags do |t|
      t.index [:legal_prompt_id, :tag_id]
      t.index [:tag_id, :legal_prompt_id]
    end
  end
end
