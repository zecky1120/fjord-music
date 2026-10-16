class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :nickname
      t.string :avatar_url
      t.string :uid
      t.string :provider

      t.timestamps
    end
  end
end
