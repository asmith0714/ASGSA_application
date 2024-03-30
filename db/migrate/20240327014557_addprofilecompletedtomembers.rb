class Addprofilecompletedtomembers < ActiveRecord::Migration[7.1]
  def change
    add_column :members, :profile_completed, :boolean, default: false
  end
end
