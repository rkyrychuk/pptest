module PostsHelper
  def alert_class(key)
    map = {
      notice: "success",
      success: "success",
      warn: "danger",
      error: "danger"
    }
    "alert-#{map[key]}"
  end
end
