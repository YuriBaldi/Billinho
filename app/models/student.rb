class Student < ApplicationRecord
    has_many :enrollments, dependent: :destroy
    validates :name, uniqueness: { message: 'already exists!' }
    validates :cpf, uniqueness: { message: 'already exists!' }
    validates_presence_of :name, :cpf, :gender, :payment_type
    validates :cpf, numericality: { only_integer: true, message: 'must be a number' }
    validates :gender, inclusion: { in: %w[m f], message: "must be 'f' (female) or 'm' (male)" }
    validates :payment_type, inclusion: { in: %w[boleto card], message: "must be 'boleto' or 'card'" }
end
