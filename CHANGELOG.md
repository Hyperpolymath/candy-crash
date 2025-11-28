# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- RSR (Rhodium Standard Repository) compliance documentation
- Comprehensive security documentation (SECURITY.md)
- Community guidelines (CODE_OF_CONDUCT.md, CONTRIBUTING.md)
- Maintainer documentation (MAINTAINERS.md)
- .well-known directory for standards compliance

## [1.0.0] - 2025-01-22

### Added
- Initial release of Candy Crash LMS platform
- User authentication with Devise (Student, Instructor, Admin roles)
- Course management system with categories, modules, and lessons
- Quiz engine with multiple-choice questions and automatic scoring
- Progress tracking for lessons and course completion
- Achievement system with badges and points
- Enrollment system with access control
- Role-based dashboards (Student, Instructor, Admin)
- Bootstrap 5 responsive UI with navigation and footer
- Comprehensive database schema (16 models)
- Pundit authorization policies
- Ransack search and Kaminari pagination
- Active Storage for file uploads
- RSpec test framework configuration
- Comprehensive seed data with demo accounts
- CLAUDE.md for AI assistant guidance
- Detailed README with setup instructions

### Backend Features
- **Models**: User, Profile, Category, Course, CourseModule, Lesson, Question, QuestionOption, Quiz, QuizQuestion, QuizAttempt, QuizAnswer, Enrollment, LessonProgress, Achievement, UserAchievement
- **Controllers**: Pages, Courses, Lessons, Quizzes, QuizAttempts, Dashboards
- **Authentication**: Devise with email/password, role-based redirects
- **Authorization**: Pundit policies for dashboard access
- **Database**: SQLite (development), PostgreSQL-ready
- **Validations**: Comprehensive model validations and business logic

### Frontend Features
- **Layout**: Bootstrap 5 responsive design
- **Navigation**: Dynamic navbar with user dropdown and role-based links
- **Home Page**: Hero section, stats display, featured courses
- **Components**: Flash messages, footer, breadcrumbs-ready
- **Icons**: Bootstrap Icons integration
- **Accessibility**: Semantic HTML, ARIA labels

### Security
- CSRF protection enabled
- SQL injection prevention via ActiveRecord
- XSS prevention via Rails HTML escaping
- Bcrypt password hashing
- Strong parameter filtering
- Session management with Devise

### Documentation
- README.md with complete setup guide
- CLAUDE.md with AI assistant instructions
- Code comments throughout models
- Inline documentation for complex logic

### Infrastructure
- Rails 7.1.3 on Ruby 3.3.6
- SQLite3 database
- Bundler dependency management
- Asset pipeline with importmap
- Development-ready Docker configuration

### Developer Experience
- Comprehensive Gemfile with 30+ gems
- Factory Bot for test data
- Faker for seed generation
- RSpec test scaffolding
- Rubocop configuration ready
- Git-friendly .gitignore

## Version History Notes

### Versioning Strategy
- **Major** (X.0.0): Breaking changes, major architecture shifts
- **Minor** (1.X.0): New features, backwards-compatible
- **Patch** (1.0.X): Bug fixes, security patches

### Upgrade Guides
For breaking changes, see the migration guides in `/docs/upgrades/` (future addition)

### Deprecation Policy
- Features marked deprecated in X.Y.0 will be removed in (X+1).0.0
- Minimum 6 months notice for deprecations
- Security fixes may require immediate breaking changes

---

## Types of Changes

- **Added** - New features
- **Changed** - Changes in existing functionality
- **Deprecated** - Soon-to-be removed features
- **Removed** - Removed features
- **Fixed** - Bug fixes
- **Security** - Security vulnerability fixes

## Links

- [Unreleased]: https://github.com/Hyperpolymath/candy-crash/compare/v1.0.0...HEAD
- [1.0.0]: https://github.com/Hyperpolymath/candy-crash/releases/tag/v1.0.0
