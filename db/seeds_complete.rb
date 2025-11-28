# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

# This is comprehensive seed data - run with: rails db:seed

require 'faker'

puts '=== CANDY CRASH SEED DATA ==='

# Clear data
[UserAchievement, Achievement, LessonProgress, QuizAnswer, QuizAttempt, QuizQuestion,
 Enrollment, Lesson, CourseModule, Quiz, QuestionOption, Question, Course, Category].each(&:destroy_all)

# Users
admin = User.find_or_create_by!(email: 'admin@candycrash.com') do |u|
  u.password = 'password123'
  u.role = :admin
end

instructor = User.find_or_create_by!(email: 'instructor@candycrash.com') do |u|
  u.password = 'password123'
  u.role = :instructor
end

student = User.find_or_create_by!(email: 'student@candycrash.com') do |u|
  u.password = 'password123'
  u.role = :student
end

# Category
cat = Category.create!(name: 'Driving Theory', description: 'UK Driving Theory', position: 1)

# Course
course = Course.create!(
  title: 'UK Driving Theory Complete',
  description: 'Master UK driving theory',
  category: cat,
  instructor: instructor,
  price: 29.99,
  level: 'beginner',
  published: true
)

# Module
mod = CourseModule.create!(course: course, title: 'Road Rules', position: 1, published: true)

# Lessons
3.times do |i|
  Lesson.create!(
    course_module: mod,
    title: "Lesson #{i+1}",
    content: "<h2>Content for lesson #{i+1}</h2>",
    lesson_type: 'text',
    position: i+1,
    published: true
  )
end

# Questions
5.times do |i|
  q = Question.create!(
    content: "Sample question #{i+1}?",
    explanation: "This is the explanation",
    category: cat,
    question_type: 'multiple_choice'
  )
  
  4.times do |j|
    QuestionOption.create!(
      question: q,
      content: "Option #{j+1}",
      is_correct: (j == 0),
      position: j+1
    )
  end
end

puts "✅ Seed complete! Login: student@candycrash.com / password123"
