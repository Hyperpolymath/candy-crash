# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class ApplicationController < ActionController::Base
  include Pundit::Authorization

  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_time_zone

  # Pundit authorization
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  helper_method :current_enrollment

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:role])
    devise_parameter_sanitizer.permit(:account_update, keys: [:role])
  end

  def after_sign_in_path_for(resource)
    case resource.role
    when 'admin'
      admin_dashboard_path
    when 'instructor'
      instructor_dashboard_path
    else
      student_dashboard_path
    end
  end

  def current_enrollment(course = nil)
    return nil unless current_user && course
    @current_enrollment ||= current_user.enrollments.find_by(course: course)
  end

  def require_student!
    redirect_to root_path, alert: 'Access denied' unless current_user&.student?
  end

  def require_instructor!
    redirect_to root_path, alert: 'Access denied' unless current_user&.instructor_or_admin?
  end

  def require_admin!
    redirect_to root_path, alert: 'Access denied' unless current_user&.admin?
  end

  private

  def set_time_zone
    Time.zone = 'London' if Time.zone.name == 'UTC'
  end

  def user_not_authorized
    flash[:alert] = 'You are not authorized to perform this action.'
    redirect_to(request.referrer || root_path)
  end
end
