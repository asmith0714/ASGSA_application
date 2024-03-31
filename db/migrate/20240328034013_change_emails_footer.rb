class ChangeEmailsFooter < ActiveRecord::Migration[7.1]
  def change
    remove_column :emails, :footer, :string
    add_column :emails, :president, :string
    add_column :emails, :vice_president, :string
    add_column :emails, :secretary, :string
    add_column :emails, :treasurer, :string
    add_column :emails, :public_relations, :string
    add_column :emails, :members_at_large, :string
    add_column :emails, :org_email, :string
  end
end
