class AddYearsToEmails < ActiveRecord::Migration[7.1]
  def change
    add_column :emails, :start_year, :integer
    add_column :emails, :end_year, :integer
  end
end
