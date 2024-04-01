class ChangeArchiveDefaultInEvents < ActiveRecord::Migration[7.1]
  def change
    change_column_default :events, :archive, from: nil, to: false
  end
end
