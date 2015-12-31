class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.references :user
      t.string :repo_name
      t.timestamps null: false
    end
  end
end
