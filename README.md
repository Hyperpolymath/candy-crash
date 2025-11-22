# Candy Crash - UK Driving Theory Preparation Platform

[![RSR Compliance](https://img.shields.io/badge/RSR-Bronze-cd7f32?style=flat-square)](./RSR_COMPLIANCE.md)
[![Rails](https://img.shields.io/badge/Rails-7.1.3-red?style=flat-square&logo=ruby-on-rails)](https://rubyonrails.org/)
[![Ruby](https://img.shields.io/badge/Ruby-3.3.6-red?style=flat-square&logo=ruby)](https://www.ruby-lang.org/)
[![License](https://img.shields.io/badge/License-See_LICENSE-blue?style=flat-square)](./LICENSE)

A comprehensive Learning Management System (LMS) for UK driving licence preparation, built with Ruby on Rails 7 and based on the PRIMROSE protocol.

## 🏆 RSR Compliance: Bronze Tier

This project adheres to the **Rhodium Standard Repository (RSR)** framework:
- ✅ Complete documentation (README, SECURITY, CONTRIBUTING, CoC, MAINTAINERS, CHANGELOG)
- ✅ RFC 9116 compliant `.well-known/security.txt`
- ✅ Automated testing & CI/CD (GitHub Actions)
- ✅ Security scanning (Brakeman, Bundler Audit)
- ✅ TPCF Perimeter 2 (Open contribution with review)
- ✅ 40+ justfile automation recipes

**Target**: Silver tier (Q2 2025) → See [RSR_COMPLIANCE.md](./RSR_COMPLIANCE.md) for details

## Features

### Core Functionality
- ✅ **User Authentication** - Devise-powered authentication with 3 user roles (Student, Instructor, Admin)
- ✅ **Course Management** - Complete course catalog with categories, modules, and lessons
- ✅ **Quiz Engine** - Interactive quizzes with multiple-choice questions, scoring, and attempts tracking
- ✅ **Progress Tracking** - Student progress monitoring for lessons and courses
- ✅ **Achievement System** - Gamification with badges and points
- ✅ **Enrollment System** - Course enrollment and access control
- ✅ **Role-Based Dashboards** - Separate dashboards for students, instructors, and admins

### Technical Highlights
- **Rails 7.1.3** with modern best practices
- **Bootstrap 5** responsive UI
- **Devise** for authentication
- **Pundit** for authorization
- **Kaminari** for pagination
- **Ransack** for search and filtering
- **RSpec** test framework
- **Active Storage** for file uploads
- **Factory Bot** for test data
- **Faker** for seed data generation

## Database Schema

### Core Models
- **User** - Authentication with roles (student/instructor/admin)
- **Profile** - User profile information
- **Category** - Course categorization
- **Course** - Main course entity with pricing and metadata
- **CourseModule** - Course sections/modules
- **Lesson** - Individual lessons with content and video support
- **Question** - Quiz questions with multiple types
- **QuestionOption** - Answer options for questions
- **Quiz** - Quizzes with timing and passing score
- **QuizAttempt** - Student quiz attempts with scoring
- **QuizAnswer** - Individual question answers
- **Enrollment** - Course enrollment tracking
- **LessonProgress** - Lesson completion tracking
- **Achievement** - Achievement definitions
- **UserAchievement** - Earned achievements

## Installation

### Prerequisites
- Ruby 3.3.6
- Rails 7.1.3
- SQLite3
- Node.js (for asset compilation)

### Setup

```bash
# Clone the repository
git clone https://github.com/Hyperpolymath/candy-crash.git
cd candy-crash

# Install dependencies
bundle install

# Setup database
rails db:create db:migrate db:seed

# Start the server
rails server
```

Visit `http://localhost:3000`

## Seed Data & Demo Accounts

The application comes with comprehensive seed data including:
- 3 categories
- 1 complete course with lessons
- 10 driving theory questions
- Practice quiz
- 3 achievements
- Multiple user accounts for testing

### Login Credentials

**Admin Account:**
- Email: `admin@candycrash.com`
- Password: `password123`

**Instructor Account:**
- Email: `john.smith@candycrash.com`
- Password: `password123`

**Student Account:**
- Email: `student1@example.com`
- Password: `password123`

## Project Structure

```
candy-crash/
├── app/
│   ├── controllers/      # Application controllers
│   │   ├── pages_controller.rb
│   │   ├── courses_controller.rb
│   │   ├── lessons_controller.rb
│   │   ├── quizzes_controller.rb
│   │   ├── quiz_attempts_controller.rb
│   │   └── dashboards_controller.rb
│   ├── models/           # ActiveRecord models
│   │   ├── user.rb
│   │   ├── course.rb
│   │   ├── lesson.rb
│   │   ├── question.rb
│   │   ├── quiz.rb
│   │   └── ... (16 models total)
│   ├── views/            # ERB templates
│   ├── policies/         # Pundit authorization policies
│   └── helpers/          # View helpers
├── config/
│   ├── routes.rb         # Application routes
│   └── ...
├── db/
│   ├── migrate/          # Database migrations
│   ├── seeds.rb          # Seed data
│   └── schema.rb         # Database schema
└── spec/                 # RSpec tests

```

## Key Features Explained

### User Roles

**Student:**
- Browse and enroll in courses
- View lessons and complete them
- Take quizzes and track attempts
- View personal dashboard with progress
- Earn achievements

**Instructor:**
- View instructor dashboard
- See enrolled students
- Access to instructor namespace (ready for course creation)

**Admin:**
- Full platform access
- User management
- Course management
- Platform analytics

### Course Flow

1. Student browses course catalog
2. Student enrolls in a course
3. Student accesses course modules and lessons
4. Student completes lessons (progress tracked)
5. Student takes quizzes to test knowledge
6. System scores quizzes automatically
7. Student earns achievements for milestones

### Quiz System

- Multiple choice questions
- Configurable time limits
- Maximum attempts per quiz
- Automatic scoring
- Pass/fail threshold
- Detailed results and feedback

## Development

### Running Tests

```bash
# Run all tests
rspec

# Run specific test file
rspec spec/models/user_spec.rb

# Run with coverage
COVERAGE=true rspec
```

### Code Quality

```bash
# Run Rubocop
rubocop

# Auto-correct issues
rubocop -a
```

### Database Operations

```bash
# Create a migration
rails generate migration MigrationName

# Run migrations
rails db:migrate

# Rollback last migration
rails db:rollback

# Reset database
rails db:reset

# Re-seed database
rails db:seed:replant
```

## PRIMROSE Protocol

This application is based on the PRIMROSE protocol for driving licence preparation. The protocol emphasizes:
- Structured learning paths
- Progressive difficulty
- Regular assessment
- Practical application
- Achievement-based motivation

## Routes Overview

### Public Routes
- `GET /` - Home page
- `GET /courses` - Course catalog
- `GET /courses/:id` - Course details
- `GET /about` - About page

### Student Routes (Authentication Required)
- `GET /dashboard` - Student dashboard
- `POST /courses/:id/enroll` - Enroll in course
- `GET /courses/:course_id/lessons/:id` - View lesson
- `POST /courses/:course_id/lessons/:id/complete` - Complete lesson
- `GET /courses/:course_id/quizzes/:id` - Quiz overview
- `POST /courses/:course_id/quizzes/:quiz_id/quiz_attempts` - Start quiz
- `GET /courses/:course_id/quizzes/:quiz_id/quiz_attempts/:id` - Take quiz

### Instructor Routes
- `GET /instructor/dashboard` - Instructor dashboard
- `/instructor/courses/*` - Course management (namespaced)

### Admin Routes
- `GET /admin/dashboard` - Admin dashboard
- `/admin/*` - Platform management (namespaced)

## Technology Decisions

### Why These Gems?

- **Devise**: Industry standard for authentication
- **Pundit**: Policy-based authorization, easy to test
- **Kaminari**: Clean pagination with I18n support
- **Ransack**: Powerful search with minimal configuration
- **RSpec**: Better syntax than Minitest for complex tests
- **Factory Bot**: Flexible test data factories
- **Faker**: Realistic seed data generation
- **Simple Form**: DRY form builder with Bootstrap integration

## Future Enhancements

- [ ] Instructor course creation interface
- [ ] Admin panel for platform management
- [ ] Advanced analytics and reporting
- [ ] Email notifications
- [ ] Video lesson playback tracking
- [ ] Discussion forums
- [ ] Mobile app via API
- [ ] Payment integration for course purchases
- [ ] Certificate generation
- [ ] Social features (leaderboards, study groups)

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

This project is licensed under the terms included in the LICENSE file.

## Contact

Project Link: [https://github.com/Hyperpolymath/candy-crash](https://github.com/Hyperpolymath/candy-crash)

---

Built with ❤️ using Ruby on Rails
