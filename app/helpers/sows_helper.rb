module SowsHelper
  def sow_status_class(sow)
    case sow.state.to_sym
    when :created
      'alert-info'
    when :rejected
      'alert-error'
    when :accepted
      'alert-success'
    when :submitted
      'alert-warning'
    end
  end
  
  def sow_counts_for(user, state)
    @sow_counts ||= []
    @sow_counts[user.id] ||= {}
    user_counts = @sow_counts[user.id]
    case state.to_sym
    when :active
      user_counts[:active] ||= Sow.owner(current_user).count
    when :unsubmitted
      user_counts[:unsubmitted] ||= Sow.owner(current_user).unsubmitted.count
    when :submitted
      user_counts[:submitted] ||= Sow.owner(current_user).submitted.count
    when :accepted
      user_counts[:accepted] ||= Sow.owner(current_user).accepted.count
    when :rejected
      user_counts[:rejected] ||= Sow.owner(current_user).rejected.count
    end
  end
  
  def sow_count_badge(count)
    if count > 0
      content_tag(:span, count, class: 'badge badge-info pull-right')
    else
      content_tag(:span, count, class: 'badge pull-right')
    end
  end
end
