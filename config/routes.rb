# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

Rails.application.routes.draw do
  # Devise authentication
  devise_for :users

  # Root path
  root "pages#home"

  # Static pages
  get 'about', to: 'pages#about', as: :about

  # Dashboards
  get 'dashboard', to: 'dashboards#student', as: :student_dashboard
  get 'instructor/dashboard', to: 'dashboards#instructor', as: :instructor_dashboard
  get 'admin/dashboard', to: 'dashboards#admin', as: :admin_dashboard

  # Courses
  resources :courses, only: [:index, :show] do
    member do
      post :enroll
    end

    # Lessons nested under courses
    resources :lessons, only: [:show] do
      member do
        post :complete
      end
    end

    # Quizzes nested under courses
    resources :quizzes, only: [:show] do
      resources :quiz_attempts, only: [:new, :create, :show] do
        member do
          post :submit_answer
          post :complete
        end
      end
    end
  end

  # Namespace for instructors
  namespace :instructor do
    root to: 'dashboards#index'
    resources :courses do
      resources :course_modules do
        resources :lessons
      end
      resources :quizzes do
        resources :questions
      end
    end
    resources :questions
    resources :students, only: [:index, :show]
  end

  # Namespace for admin
  namespace :admin do
    root to: 'dashboards#index'
    resources :users
    resources :courses
    resources :categories
    resources :achievements
    resources :questions
  end

  # Health check
  get "up" => "rails/health#show", as: :rails_health_check
end
