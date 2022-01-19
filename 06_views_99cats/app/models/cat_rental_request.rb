class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :does_not_overlap_approved_requests

  belongs_to :cat

  def overlapping_requests
    CatRentalRequest
      .where(["NOT((start_date > ?) OR (end_date < ?))", self.end_date, self.start_date])
      .where(cat_id: self.cat_id)
      .where.not(id: self.id)
  end

  def overlapping_approved_requests
    overlapping_requests
      .where(status: 'APPROVED')
  end

  def overlapping_pending_requests
    overlapping_requests
      .where(status: 'PENDING')
  end

  def approve!
    CatRentalRequest.transaction do 
      self.status = "APPROVED"
      self.overlapping_pending_requests.each { |request| request.deny! }
      self.save
    end
    self
  end

  def deny!
    self.status = "DENIED"
    self.save
  end

  def pending?
    self.status == "PENDING"
  end

  def does_not_overlap_approved_requests
    if overlapping_approved_requests.exists?
      errors[:dates] << "overlap existing approved rental request."
    else
      return true
    end
  end
end

# cr1 = CatRentalRequest.new(cat_id: 1, start_date: '2022-01-01', end_date: '2022-02-01')
