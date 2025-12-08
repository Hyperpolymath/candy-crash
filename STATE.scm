;; SPDX-FileCopyrightText: 2025 Hyperpolymath
;; SPDX-License-Identifier: GPL-3.0-or-later
;;
;; STATE.scm - AI Conversation Checkpoint for Candy Crash LMS
;; Format: https://github.com/hyperpolymath/state.scm

;;;; ============================================================
;;;; METADATA
;;;; ============================================================

(define-module (candy-crash state)
  #:export (state))

(define state
  `((metadata
     (format-version . "1.0.0")
     (created . "2025-12-08")
     (updated . "2025-12-08")
     (project . "candy-crash")
     (repository . "https://github.com/Hyperpolymath/candy-crash"))

;;;; ============================================================
;;;; CURRENT POSITION
;;;; ============================================================

    (current-position
     (summary . "Production-ready LMS with complete student experience; instructor/admin UI pending")
     (version . "1.0.0")
     (release-date . "2025-01-22")
     (completion-percentage . 65)
     (phase . "post-mvp-expansion")

     (what-works
      ((feature . "User Authentication")
       (status . complete)
       (details . "Devise with email/password, 3 roles (student/instructor/admin)"))
      ((feature . "Student Dashboard")
       (status . complete)
       (details . "Enrollments, progress tracking, quiz history, achievements display"))
      ((feature . "Course Catalog")
       (status . complete)
       (details . "Browse, search (Ransack), filter by category/difficulty, pagination"))
      ((feature . "Course Structure")
       (status . complete)
       (details . "Category -> Course -> Module -> Lesson hierarchy fully implemented"))
      ((feature . "Lesson System")
       (status . complete)
       (details . "Multiple types (video/text/quiz/interactive), completion tracking, time logging"))
      ((feature . "Quiz Engine")
       (status . complete)
       (details . "Multiple choice, timed attempts, scoring, pass/fail, history"))
      ((feature . "Achievement System")
       (status . complete)
       (details . "Badge-based gamification, auto-awarding via AchievementService"))
      ((feature . "Progress Tracking")
       (status . complete)
       (details . "Enrollment progress 0-100%, lesson completion, time spent"))
      ((feature . "Instructor Dashboard")
       (status . partial)
       (details . "Basic view exists, course management UI not implemented"))
      ((feature . "Admin Dashboard")
       (status . partial)
       (details . "Analytics view exists, resource management UI not implemented"))
      ((feature . "CI/CD Pipeline")
       (status . complete)
       (details . "GitHub Actions: tests, linting, security scans, container builds"))
      ((feature . "Container Support")
       (status . complete)
       (details . "Podman/Chainguard Wolfi, rootless, production-ready"))
      ((feature . "Documentation")
       (status . complete)
       (details . "RSR Gold tier 94%, comprehensive AsciiDoc docs")))

     (what-doesnt-work
      ((feature . "Instructor Course Management")
       (reason . "Routes exist but views/controllers not implemented"))
      ((feature . "Admin Resource Management")
       (reason . "Routes exist but full CRUD views not implemented"))
      ((feature . "Email Notifications")
       (reason . "ApplicationMailer configured but no mailers implemented"))
      ((feature . "Video Playback Tracking")
       (reason . "Not started"))
      ((feature . "Discussion Forums")
       (reason . "Not started"))
      ((feature . "Payment Integration")
       (reason . "Not started"))
      ((feature . "Certificate Generation")
       (reason . "Not started"))))

;;;; ============================================================
;;;; ROUTE TO MVP V1 (Next Milestone)
;;;; ============================================================

    (route-to-mvp-v1
     (milestone-name . "Complete Platform MVP")
     (target-completion . 85)
     (current-completion . 65)

     (phases
      ((phase . 1)
       (name . "Instructor Course Management")
       (priority . high)
       (tasks
        ("Implement InstructorCoursesController with full CRUD"
         "Create course creation/edit forms with Bootstrap UI"
         "Add module management within courses"
         "Implement lesson editor with rich text support"
         "Add quiz builder with question selection"
         "Create question bank management interface")))

      ((phase . 2)
       (name . "Admin Platform Management")
       (priority . high)
       (tasks
        ("Implement AdminUsersController for user management"
         "Create user listing with search/filter/pagination"
         "Add role assignment interface"
         "Implement course approval workflow"
         "Create category management CRUD"
         "Add achievement configuration UI"
         "Build platform analytics dashboard")))

      ((phase . 3)
       (name . "Communication & Notifications")
       (priority . medium)
       (tasks
        ("Implement enrollment confirmation emails"
         "Add course completion notifications"
         "Create quiz result emails"
         "Implement achievement earned notifications"
         "Add admin alerts for new enrollments")))

      ((phase . 4)
       (name . "Polish & Testing")
       (priority . medium)
       (tasks
        ("Increase test coverage to 90%"
         "Add integration tests for instructor flows"
         "Add integration tests for admin flows"
         "Performance optimization for dashboard queries"
         "Accessibility audit and fixes"
         "Mobile responsiveness review")))))

;;;; ============================================================
;;;; KNOWN ISSUES
;;;; ============================================================

    (issues
     ((id . 1)
      (severity . low)
      (type . technical-debt)
      (description . "Instructor namespace controllers need implementation")
      (affected-files
       "app/controllers/instructor/"
       "app/views/instructor/")
      (workaround . "Instructors must use rails console or admin panel for course management"))

     ((id . 2)
      (severity . low)
      (type . technical-debt)
      (description . "Admin namespace views incomplete")
      (affected-files
       "app/controllers/admin/"
       "app/views/admin/")
      (workaround . "Admins can use rails console for data management"))

     ((id . 3)
      (severity . low)
      (type . feature-gap)
      (description . "No email delivery configured")
      (affected-files "app/mailers/")
      (workaround . "Users must check dashboard manually for updates"))

     ((id . 4)
      (severity . info)
      (type . enhancement)
      (description . "Video lessons don't track watch progress")
      (affected-files "app/models/lesson_progress.rb")
      (workaround . "Manual lesson completion marking"))

     ((id . 5)
      (severity . info)
      (type . enhancement)
      (description . "No course certificate generation")
      (affected-files . none)
      (workaround . "Course completion recorded but no PDF certificate")))

;;;; ============================================================
;;;; QUESTIONS FOR STAKEHOLDER
;;;; ============================================================

    (questions
     ((id . 1)
      (topic . "Instructor Workflow Priority")
      (question . "Should instructors be able to create courses from scratch, or only modify existing course templates?")
      (options
       ("Full course creation from blank slate"
        "Template-based course creation only"
        "Both options with template recommendations"))
      (impact . "Determines complexity of instructor course creation UI"))

     ((id . 2)
      (topic . "Payment Integration")
      (question . "Which payment provider should be integrated for course purchases?")
      (options
       ("Stripe"
        "PayPal"
        "Both"
        "Defer to later phase"))
      (impact . "Affects monetization timeline and implementation complexity"))

     ((id . 3)
      (topic . "Video Hosting")
      (question . "Where should lesson videos be hosted?")
      (options
       ("Active Storage (local/S3)"
        "YouTube embeds"
        "Vimeo embeds"
        "Custom video CDN"))
      (impact . "Affects storage costs, playback tracking, and DRM requirements"))

     ((id . 4)
      (topic . "User Growth")
      (question . "What is the expected user scale for the first year?")
      (options
       ("< 1,000 students"
        "1,000 - 10,000 students"
        "10,000 - 100,000 students"
        "> 100,000 students"))
      (impact . "Affects database optimization, caching strategy, and infrastructure decisions"))

     ((id . 5)
      (topic . "Mobile Strategy")
      (question . "Is a mobile app required, or is responsive web sufficient?")
      (options
       ("Responsive web only"
        "React Native / Flutter app"
        "Progressive Web App (PWA)"
        "Native iOS/Android apps"))
      (impact . "Determines need for API development and mobile investment"))

     ((id . 6)
      (topic . "Multi-tenancy")
      (question . "Should the platform support multiple driving schools as separate tenants?")
      (options
       ("Single organization only"
        "Multi-tenant with shared courses"
        "White-label per organization"))
      (impact . "Major architectural decision affecting data isolation and branding")))

;;;; ============================================================
;;;; LONG-TERM ROADMAP
;;;; ============================================================

    (roadmap
     ((version . "1.1.0")
      (name . "Instructor Empowerment")
      (status . planned)
      (features
       ("Complete instructor course creation UI"
        "Question bank management"
        "Student performance analytics per instructor"
        "Bulk import questions from CSV/Excel")))

     ((version . "1.2.0")
      (name . "Admin Control Center")
      (status . planned)
      (features
       ("Full admin resource management"
        "Platform-wide analytics dashboard"
        "User management with bulk operations"
        "Content moderation tools"
        "System health monitoring")))

     ((version . "1.3.0")
      (name . "Communication Hub")
      (status . planned)
      (features
       ("Email notification system"
        "In-app notifications (ActionCable)"
        "Announcement system"
        "Student-instructor messaging")))

     ((version . "2.0.0")
      (name . "Monetization")
      (status . planned)
      (features
       ("Stripe payment integration"
        "Course pricing and discounts"
        "Subscription plans"
        "Refund handling"
        "Revenue analytics")))

     ((version . "2.1.0")
      (name . "Certification")
      (status . planned)
      (features
       ("PDF certificate generation"
        "Verifiable certificate URLs"
        "LinkedIn integration"
        "Badge sharing")))

     ((version . "2.2.0")
      (name . "Community")
      (status . planned)
      (features
       ("Discussion forums per course"
        "Study groups"
        "Peer-to-peer messaging"
        "Leaderboards")))

     ((version . "3.0.0")
      (name . "Mobile & API")
      (status . planned)
      (features
       ("RESTful API with versioning"
        "API authentication (JWT)"
        "Progressive Web App"
        "Offline lesson access"
        "Push notifications")))

     ((version . "3.1.0")
      (name . "Advanced Learning")
      (status . planned)
      (features
       ("Adaptive learning paths"
        "Spaced repetition for quiz review"
        "AI-powered question generation"
        "Personalized study recommendations")))

     ((version . "future")
      (name . "Enterprise & Scale")
      (status . planned)
      (features
       ("Multi-tenancy / white-label"
        "SSO integration (SAML/OIDC)"
        "Advanced reporting & exports"
        "API rate limiting & monetization"
        "Internationalization (i18n)"))))

;;;; ============================================================
;;;; TECH STACK SUMMARY
;;;; ============================================================

    (tech-stack
     (backend
      (framework . "Ruby on Rails 7.2.3")
      (language . "Ruby 3.3.6")
      (database . "SQLite (dev) / PostgreSQL (prod)"))
     (authentication
      (library . "Devise")
      (authorization . "Pundit"))
     (frontend
      (framework . "Bootstrap 5")
      (interactivity . "Hotwire (Turbo + Stimulus)"))
     (testing
      (framework . "RSpec")
      (coverage . "SimpleCov (80% target)")
      (factories . "FactoryBot"))
     (devops
      (ci . "GitHub Actions")
      (container . "Podman (Chainguard Wolfi)")
      (automation . "Just (60+ recipes)")
      (environment . "Nix Flakes")))

;;;; ============================================================
;;;; DATABASE MODELS
;;;; ============================================================

    (models
     (count . 18)
     (entities
      ("User" "Profile" "Category" "Course" "CourseModule" "Lesson"
       "Question" "QuestionOption" "Quiz" "QuizQuestion"
       "QuizAttempt" "QuizAnswer" "Enrollment" "LessonProgress"
       "Achievement" "UserAchievement"
       "ActiveStorage::Blob" "ActiveStorage::Attachment")))

;;;; ============================================================
;;;; QUALITY METRICS
;;;; ============================================================

    (quality
     (rsr-compliance . "Gold 94%")
     (test-files . 40)
     (test-coverage-target . "80%")
     (linting . "RuboCop Rails")
     (security-scanning . ("Brakeman" "Bundler Audit" "CodeQL"))
     (documentation-files . 12))))

;;;; ============================================================
;;;; END STATE
;;;; ============================================================
