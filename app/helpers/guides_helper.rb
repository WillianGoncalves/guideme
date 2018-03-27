module GuidesHelper
  def awaiting_for_approval_count
    Guide.where("status = ?", Guide.statuses[:awaiting_for_approval]).count
  end
end
