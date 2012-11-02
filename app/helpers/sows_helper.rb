module SowsHelper
  def sow_status_class(sow)
    case sow.state.to_sym
    when :editing
      'alert-info'
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
    if user.nil?
      sow = Sow
      user_counts = @sow_counts ||= {}
    else
      @sow_counts ||= []
      @sow_counts[user.id] ||= {}
      user_counts = @sow_counts[user.id]
    
      sow = Sow.owner(current_user) 
    end
    
    case state.to_sym
    when :active
      user_counts[:active] ||= sow.count
    when :unsubmitted
      user_counts[:unsubmitted] ||= sow.unsubmitted.count
    when :submitted
      user_counts[:submitted] ||= sow.submitted.count
    when :accepted
      user_counts[:accepted] ||= sow.accepted.count
    when :rejected
      user_counts[:rejected] ||= sow.rejected.count
    end
  end
  
  def sow_count_badge(count)
    if count > 0
      content_tag(:span, count, class: 'badge badge-info pull-right')
    else
      content_tag(:span, count, class: 'badge pull-right')
    end
  end
  
  def award_group_options(sow)
    # groups = sorted_group_list(Group.top)
    # groups = groups.reject { |g| g.parent.nil? }
    option_groups_from_collection_for_select(Group.top, :all_children, :name, :id, :name_path, { selected: sow.group.try(:id) })
  end
end
