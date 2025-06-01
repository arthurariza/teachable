class CreateCourses < ActiveRecord::Migration[8.0]
  def change
    create_table :courses do |t|
      t.string :name
      t.string :heading
      t.integer :external_id, null: false, index: { unique: true }
      t.boolean :is_published, default: false

      t.timestamps
    end
  end
end
