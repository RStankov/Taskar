class AddProjectIdToComments < ActiveRecord::Migration
  def self.up
    add_column :comments, :project_id, :integer
    
    if Comment.count > 0
      Comment.all.each do |comment|
        execute "UPDATE comments SET project_id = #{comment.task.project_id} WHERE id = #{comment.id}"
      end
    end
  end

  def self.down
    remove_column :comments, :project_id
  end
end
