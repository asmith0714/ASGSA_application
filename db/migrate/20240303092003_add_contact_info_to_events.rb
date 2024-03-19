class AddContactInfoToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :contact_info, :string
  end
end
