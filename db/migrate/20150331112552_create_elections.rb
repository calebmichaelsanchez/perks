class CreateElections < ActiveRecord::Migration
  def change
    create_table :elections do |t|
      t.integer :month
      t.integer :year
      t.timestamps null: false
    end
  end
end
