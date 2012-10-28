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
end
