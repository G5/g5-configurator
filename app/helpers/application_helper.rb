module ApplicationHelper
  def computer_readable_time(time)
    time.utc.strftime("%Y-%m-%dT%H:%M:%SZ")
  end
  
  def human_readable_time(time)
    time.strftime("%I:%M%P on %B %e, %Y")
  end
end
