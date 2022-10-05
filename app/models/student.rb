class Student < ApplicationRecord
    has_many :enrollments
    validates_presence_of :name, :cpf, :gender, :payment_type
    validates :cpf, numericality: {only_integer: true, message: "CPF must be a number"}
    validates :gender, inclusion: {in: %w{"m", "f"}, message: "Student gender must be 'f' (female) or 'm' (male)"}
    validates :payment_type, inclusion: {in: %w{"m", "f"}, message: "Student gender must be 'boleto' or 'card'"}
end
