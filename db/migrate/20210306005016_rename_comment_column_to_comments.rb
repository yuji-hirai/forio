class RenameCommentColumnToComments < ActiveRecord::Migration[6.1]
  def change
		rename_column :comments, :comment, :content
		#Ex:- rename_column("admin_users", "pasword","hashed_pasword")
  end
end
