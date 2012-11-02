module GroupsHelper
  def parent_group_options(group)
    groups = sorted_group_list(Group.top)
    options_for_select(groups, { disabled: @group.try(:id), selected: group.parent.try(:id) })
  end
  
  def sorted_group_list(groups, depth = 0)
    opts = []
    groups.each do |group|
      opts << [group.name, group.id]
      opts += sorted_group_list(group.children, depth+1) unless group.children.empty?
    end
    
    opts
  end
end
