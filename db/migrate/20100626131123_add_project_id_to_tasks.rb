class AddProjectIdToTasks < ActiveRecord::Migration
  def self.up
    add_column :tasks, :project_id, :integer
    
    Task.all.each do |task|
      execute "UPDATE tasks SET project_id = #{task.section.project_id} WHERE id = #{task.id}"
    end
  end

  def self.down
    remove_column :tasks, :project_id
  end
end
