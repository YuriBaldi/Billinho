# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_10_10_142457) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enrollments", force: :cascade do |t|
    t.decimal "course_price"
    t.integer "number_payments"
    t.integer "due_day"
    t.string "course_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "institution_id"
    t.integer "student_id"
    t.index ["institution_id"], name: "index_enrollments_on_institution_id"
    t.index ["student_id"], name: "index_enrollments_on_student_id"
  end

  create_table "institutions", force: :cascade do |t|
    t.string "name", null: false
    t.string "cnpj", null: false
    t.string "institution_type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "payments", force: :cascade do |t|
    t.decimal "value"
    t.date "due_date"
    t.string "status", default: "open"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "enrollment_id", null: false
    t.index ["enrollment_id"], name: "index_payments_on_enrollment_id"
  end

  create_table "students", force: :cascade do |t|
    t.string "name"
    t.string "cpf"
    t.date "birth_date"
    t.integer "phone"
    t.string "gender"
    t.string "payment_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "payments", "enrollments"
end
