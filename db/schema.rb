# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171026224125) do

  create_table "board_items", force: :cascade do |t|
    t.string   "type"
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.datetime "start_time"
    t.datetime "end_time"
    t.string   "uri"
    t.string   "assignment_type"
    t.integer  "file_limit"
    t.integer  "section_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.string   "document_file_file_name"
    t.string   "document_file_content_type"
    t.integer  "document_file_file_size"
    t.datetime "document_file_updated_at"
    t.index ["section_id"], name: "index_board_items_on_section_id"
  end

  create_table "classrooms", force: :cascade do |t|
    t.string   "name"
    t.string   "password_digest"
    t.boolean  "has_grades"
    t.boolean  "has_attendance"
    t.float    "minimum_grade"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "code_lines", force: :cascade do |t|
    t.integer  "line_number"
    t.text     "content"
    t.integer  "code_submission_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["code_submission_id"], name: "index_code_lines_on_code_submission_id"
  end

  create_table "logs", force: :cascade do |t|
    t.string   "action"
    t.string   "subject"
    t.integer  "subject_id"
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_logs_on_classroom_id"
    t.index ["user_id"], name: "index_logs_on_user_id"
  end

  create_table "sections", force: :cascade do |t|
    t.string   "title"
    t.text     "description"
    t.integer  "position"
    t.integer  "classroom_id"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_sections_on_classroom_id"
  end

  create_table "submissions", force: :cascade do |t|
    t.string   "type"
    t.float    "grade"
    t.string   "language"
    t.text     "content"
    t.string   "assignment_file_file_name"
    t.string   "assignment_file_content_type"
    t.integer  "assignment_file_file_size"
    t.datetime "assignment_file_updated_at"
    t.integer  "assignment_id"
    t.integer  "user_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["assignment_id"], name: "index_submissions_on_assignment_id"
    t.index ["user_id"], name: "index_submissions_on_user_id"
  end

  create_table "subscriptions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "classroom_id"
    t.string   "role"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.index ["classroom_id"], name: "index_subscriptions_on_classroom_id"
    t.index ["user_id"], name: "index_subscriptions_on_user_id"
  end

  create_table "survey_answers", force: :cascade do |t|
    t.string   "answer"
    t.integer  "survey_question_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.index ["survey_question_id"], name: "index_survey_answers_on_survey_question_id"
  end

  create_table "survey_questions", force: :cascade do |t|
    t.string   "question"
    t.boolean  "required"
    t.integer  "survey_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["survey_id"], name: "index_survey_questions_on_survey_id"
  end

  create_table "survey_responses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "survey_answer_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["survey_answer_id"], name: "index_survey_responses_on_survey_answer_id"
    t.index ["user_id"], name: "index_survey_responses_on_user_id"
  end

  create_table "test_alternative_responses", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "test_alternative_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
    t.index ["test_alternative_id"], name: "index_test_alternative_responses_on_test_alternative_id"
    t.index ["user_id"], name: "index_test_alternative_responses_on_user_id"
  end

  create_table "test_alternatives", force: :cascade do |t|
    t.string   "content"
    t.boolean  "correct"
    t.integer  "test_question_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["test_question_id"], name: "index_test_alternatives_on_test_question_id"
  end

  create_table "test_questions", force: :cascade do |t|
    t.text     "question"
    t.string   "question_type"
    t.float    "value"
    t.integer  "test_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["test_id"], name: "index_test_questions_on_test_id"
  end

  create_table "test_text_responses", force: :cascade do |t|
    t.float    "grade"
    t.text     "response"
    t.integer  "user_id"
    t.integer  "test_question_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["test_question_id"], name: "index_test_text_responses_on_test_question_id"
    t.index ["user_id"], name: "index_test_text_responses_on_user_id"
  end

  create_table "text_feedbacks", force: :cascade do |t|
    t.string   "feedback"
    t.integer  "test_text_response_id"
    t.integer  "test_alternative_response_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.index ["test_alternative_response_id"], name: "index_text_feedbacks_on_test_alternative_response_id"
    t.index ["test_text_response_id"], name: "index_text_feedbacks_on_test_text_response_id"
  end

  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.string   "password"
    t.string   "cep"
    t.string   "address"
    t.integer  "number"
    t.string   "complement"
    t.string   "neighborhood"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "photo_name"
    t.string   "language"
    t.string   "timezone"
    t.string   "password_digest"
    t.string   "remember_digest"
    t.string   "activation_digest"
    t.string   "reset_digest"
    t.datetime "reset_sent_at"
    t.boolean  "admin"
    t.boolean  "confirmed"
    t.datetime "confirmed_at"
    t.datetime "last_access"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
  end

end
