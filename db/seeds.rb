# SPDX-License-Identifier: GPL-3.0-or-later

# frozen_string_literal: true

# Clear existing data (careful in production!)
puts '🗑️  Clearing existing data...'
[UserAchievement, Achievement, LessonProgress, QuizAnswer, QuizAttempt, QuizQuestion,
 Enrollment, Lesson, CourseModule, Quiz, QuestionOption, Question, Course, Category,
 Profile, User].each(&:destroy_all)

puts '👥 Creating users...'

# Create admin user
admin = User.create!(
  email: 'admin@candycrash.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :admin
)
admin.profile.update(
  first_name: 'Admin',
  last_name: 'User',
  phone: '+44 20 1234 5678'
)

# Create instructors
instructor1 = User.create!(
  email: 'john.smith@candycrash.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :instructor
)
instructor1.profile.update(
  first_name: 'John',
  last_name: 'Smith',
  phone: '+44 20 1234 5679',
  date_of_birth: 35.years.ago
)

instructor2 = User.create!(
  email: 'sarah.jones@candycrash.com',
  password: 'password123',
  password_confirmation: 'password123',
  role: :instructor
)
instructor2.profile.update(
  first_name: 'Sarah',
  last_name: 'Jones',
  phone: '+44 20 1234 5680',
  date_of_birth: 42.years.ago
)

# Create students
students = []
5.times do |i|
  student = User.create!(
    email: "student#{i + 1}@example.com",
    password: 'password123',
    password_confirmation: 'password123',
    role: :student
  )
  student.profile.update(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    phone: Faker::PhoneNumber.phone_number,
    date_of_birth: rand(18..60).years.ago
  )
  students << student
end

puts "✅ Created #{User.count} users (#{User.admins.count} admin, #{User.instructors.count} instructors, #{User.students.count} students)"

puts '📚 Creating categories...'
Category.create!([
  { name: 'Road Signs & Markings', description: 'UK road signs and markings', position: 1 },
  { name: 'Road Safety & Rules', description: 'Essential safety rules', position: 2 },
  { name: 'Hazard Awareness', description: 'Identifying hazards', position: 3 }
])

puts "✅ Created #{Category.count} categories"

cat = Category.first

puts '🎓 Creating course...'
course = Course.create!(
  title: 'UK Driving Theory - Complete Course',
  description: 'Master UK driving theory test',
  category: cat,
  instructor: instructor1,
  price: 29.99,
  duration_hours: 20,
  level: 'beginner',
  published: true
)

mod = CourseModule.create!(course: course, title: 'Introduction', position: 1, published: true)
3.times do |i|
  Lesson.create!(
    course_module: mod,
    title: "Lesson #{i+1}: Driving Basics",
    content: "<h2>Lesson Content</h2><p>Essential driving knowledge...</p>",
    lesson_type: 'text',
    position: i+1,
    duration_minutes: 20,
    published: true
  )
end

puts "✅ Created course with #{course.lessons.count} lessons"

puts '❓ Creating questions...'
10.times do |i|
  q = Question.create!(
    content: "What is rule #{i+1} of the Highway Code?",
    explanation: "This rule covers important safety information.",
    category: cat,
    question_type: 'multiple_choice',
    difficulty: rand(1..5)
  )

  4.times do |j|
    QuestionOption.create!(
      question: q,
      content: "Answer option #{j+1}",
      is_correct: (j == 0),
      position: j+1
    )
  end
end

puts "✅ Created #{Question.count} questions"

puts '📝 Creating quiz...'
quiz = Quiz.create!(
  title: 'Theory Test Practice',
  description: 'Practice quiz',
  course: course,
  passing_score: 80,
  time_limit_minutes: 30,
  quiz_type: 'practice',
  published: true
)

Question.limit(5).each_with_index do |q, i|
  QuizQuestion.create!(quiz: quiz, question: q, position: i+1)
end

puts '🎯 Creating achievements...'
Achievement.create!([
  { title: 'First Steps', description: 'Complete first lesson', badge_type: 'bronze', points: 10 },
  { title: 'Quiz Master', description: 'Pass first quiz', badge_type: 'silver', points: 25 },
  { title: 'Perfect Score', description: 'Get 100%', badge_type: 'gold', points: 100 }
])

puts '📊 Creating enrollments...'
students.each { |s| Enrollment.create!(user: s, course: course) }

puts "\n✅ SEED COMPLETE!"
puts "=" * 60
puts "Login credentials:"
puts "  Admin: admin@candycrash.com / password123"
puts "  Instructor: john.smith@candycrash.com / password123"
puts "  Student: student1@example.com / password123"
puts "=" * 60
