# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later

class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  layout "mailer"
end
