class CreateEventTable < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.column :description, :string
      t.column :location, :string
      t.column :start_dt, :date
      t.column :start_tm, :time
      t.column :end_dt, :date
      t.column :end_tm, :time

      t.timestamps
    end
  end
end
