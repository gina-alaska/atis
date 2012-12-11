class FixSubmittedByAndReviewedByToSows < ActiveRecord::Migration
  def up
    rename_column(:sows, :submitted_by, :submitted_by_id)
    rename_column(:sows, :reviewed_by, :reviewed_by_id)
    rename_column(:sows, :rejection_reason, :review_notes)
  end

  def down
    rename_column(:sows, :submitted_by_id, :submitted_by)
    rename_column(:sows, :reviewed_by_id, :reviewed_by)
    rename_column(:sows, :review_notes, :rejection_reason)
  end
end
