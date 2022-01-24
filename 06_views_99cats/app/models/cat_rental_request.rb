class CatRentalRequest < ApplicationRecord
  validates :cat_id, :start_date, :end_date, :status, :user_id, presence: true
  validates :status, inclusion: { in: %w(PENDING APPROVED DENIED) }
  validate :does_not_overlap_approved_requests
  validate :end_date_after_start_date

  belongs_to :cat
  belongs_to :renter,
    class_name: 'User',
    primary_key: :id,
    foreign_key: :user_id

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

  private

  def does_not_overlap_approved_requests
    if overlapping_approved_requests.exists?
      errors[:dates] << "overlap existing approved rental request."
    else
      return true
    end
  end

  def end_date_after_start_date
    if self.start_date > end_date
      errors[:end_date] << "cannot be before start date."
    else
      return true
    end
  end
end

# cr1 = CatRentalRequest.new(cat_id: 1, start_date: '2022-01-01', end_date: '2022-02-01')
