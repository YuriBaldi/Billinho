class Institution < ApplicationRecord
    has_many :enrollments, dependent: :destroy

    validates_presence_of :name
    validates :name, uniqueness: { message: 'is already in use' }
    validates :cnpj, uniqueness: { message: 'is already in use' }
    validates :cnpj, numericality: { only_integer: true, message: 'must be a number' }
    validates :institution_type, inclusion: { in: %w[university school nursey],
                                              message: 'must be university, school or nursey' }
end
