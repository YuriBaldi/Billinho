class Payment < ApplicationRecord
    belongs_to :enrollment
    validates_presence_of :value, :due_date, :enrollment_id, :status
    validates_numericality_of :value, greater_than: 0.0
    validates :status, inclusion: { in: %w[open delayed paid], message: 'must be open, delayed or paid' }
end
