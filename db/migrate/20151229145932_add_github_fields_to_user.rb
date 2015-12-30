class AddGithubFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :login, :string
    add_column :users, :avatar_url, :string
  end
end
