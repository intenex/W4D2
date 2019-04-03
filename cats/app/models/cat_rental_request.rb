class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, presence: true 
  validates :status, presence: true, inclusion: { in: %w(APPROVED PENDING DENIED), message: "%{value} is not valid" }

  belongs_to :cat

  # private
  def overlapping_requests
    options_hash = {self_id: self.cat_id, self_end_date: self.end_date, self_start_date: self.start_date}
    # you can pass in an options hash into a heredoc and then reference things by the key value with a symbol colon as normal
    CatRentalRequest.select(:start_date, :end_date).where(<<-SQL, options_hash)
    cat_id = :self_id AND 
    ((start_date <= :self_end_date AND start_date >= :self_start_date) OR
    (end_date >= :self_end_date AND start_date <= :self_end_date))
    SQL
  end

  def overlapping_approved_requests
    overlapping_requests.where(status: "APPROVED")
  end

  def does_not_overlap_approved_request
    # overlapping
  end
end
