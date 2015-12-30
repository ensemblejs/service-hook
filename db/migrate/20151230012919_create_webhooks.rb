class CreateWebhooks < ActiveRecord::Migration
  def change
    create_table :webhooks do |t|
      t.references :user
      t.string :repo_name
      t.string :url
      t.string :test_url
      t.string :ping_url
      t.boolean :active
      t.timestamps null: false
    end
  end
end
