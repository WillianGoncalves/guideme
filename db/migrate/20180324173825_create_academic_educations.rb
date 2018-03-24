class CreateAcademicEducations < ActiveRecord::Migration[5.1]
  def change
    create_table :academic_educations do |t|
      t.string :course, null: false
      t.string :institution, null: false
      t.date :finished_in
      t.integer :level, null: false, default: 0
      t.references :guide, null: false

      t.timestamps
    end
  end
end
