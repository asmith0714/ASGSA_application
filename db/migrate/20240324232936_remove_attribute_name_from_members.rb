class RemoveAttributeNameFromMembers < ActiveRecord::Migration[7.1]
  def change
    remove_column :members, :faculty, :string
  end
end
