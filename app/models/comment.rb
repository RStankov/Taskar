class Comment < ActiveRecord::Base
  belongs_to :task, :counter_cache => true
  belongs_to :user, :counter_cache => true, :touch => :last_active_at
  
  validates_presence_of :text
  
  attr_accessible :text
  
  EDITABLE_BY = 15.minutes
  
  def editable_by user
    self.user_id == user.id && updated_at + EDITABLE_BY > Time.now
  end
  
  def editable_for
    if updated_at + EDITABLE_BY > Time.now
      (((updated_at + EDITABLE_BY) - Time.now) / 60).ceil
    else
      0
    end
  end
end
