class MergeUsersWithSameEmails < ActiveRecord::Migration
  def self.up
    User.group(:email).each do |user|
      p "merge - #{user.email} (#{user.id})"

      # AccountUser#account_id is attr_protected, so AccountUser.create is not option
      account = AccountUser.new
      account.account_id = user.account_id
      account.user_id = user.id
      account.save

      User.where(:email => user.email).where("id != ?", user.id).each do |duplicate|
        duplicate.events.update_all                   :user_id => user.id
        duplicate.comments.update_all                 :user_id => user.id
        duplicate.tasks.update_all                    :user_id => user.id
        duplicate.statuses.update_all                 :user_id => user.id
        duplicate.project_participations.update_all   :user_id => user.id
        duplicate.responsibilities.update_all         :responsible_party_id => user.id

        if duplicate.owned_account
          duplicate.owned_account.update_attribute :owner_id, user.id
        end

         # AccountUser#account_id is attr_protected, so AccountUser.create is not option
        account = AccountUser.new
        account.account_id = duplicate.account_id
        account.user_id = user.id
        account.save

        duplicate.destroy

        p "clean - #{duplicate.id}"
      end

    end
  end

  def self.down
  end
end
