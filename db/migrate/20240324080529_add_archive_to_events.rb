class AddArchiveToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :archive, :boolean
  end
end
