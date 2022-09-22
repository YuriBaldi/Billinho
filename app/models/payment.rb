class Payment < ApplicationRecord
    validates_presence_of :value, :due_date, :enrollment_id, :status
    validates :status, inclusion: { in: ["open", "delayed", "paid"], message: "Status must be open, delayed or paid"}
end
