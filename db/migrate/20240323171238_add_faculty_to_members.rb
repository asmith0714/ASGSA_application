class AddFacultyToMembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :faculty, :string
  end
end
