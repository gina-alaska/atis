class UserObserver < ActiveRecord::Observer
  def after_create(user)
    Activity.record(user, 'registered')
  end
end
