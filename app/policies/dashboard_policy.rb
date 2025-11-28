# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class DashboardPolicy < ApplicationPolicy
  def student?
    user.present? && user.student?
  end

  def instructor?
    user.present? && (user.instructor? || user.admin?)
  end

  def admin?
    user.present? && user.admin?
  end
end
