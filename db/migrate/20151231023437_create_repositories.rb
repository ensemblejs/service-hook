class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :name
      t.references :users
    end

    add_reference :webhooks, :repository, index: true
  end
end
