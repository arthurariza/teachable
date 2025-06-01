class CreateEnrollments < ActiveRecord::Migration[8.0]
  def change
    create_table :enrollments do |t|
      t.integer :course_external_id, null: false
      t.integer :user_external_id, null: false

      t.timestamps
    end

    add_index :enrollments, [:course_external_id, :user_external_id], unique: true
  end
end
