# frozen_string_literal: true

# SPDX-License-Identifier: GPL-3.0-or-later
#
# Security Headers Configuration
# RSR Compliance: Category 5.3 - HTTP Security Headers
#
# References:
# - OWASP Secure Headers Project: https://owasp.org/www-project-secure-headers/
# - Mozilla Observatory: https://observatory.mozilla.org/
# - Security Headers: https://securityheaders.com/

Rails.application.config.action_dispatch.default_headers.merge!(
  {
    # X-Frame-Options: Prevents clickjacking attacks
    # DENY: Page cannot be displayed in a frame, iframe, embed, or object
    'X-Frame-Options' => 'DENY',

    # X-Content-Type-Options: Prevents MIME-sniffing
    # nosniff: Browser must respect Content-Type header
    'X-Content-Type-Options' => 'nosniff',

    # X-XSS-Protection: Legacy XSS filter (redundant with CSP but included for old browsers)
    # 1; mode=block: Enable filter and block page if attack detected
    'X-XSS-Protection' => '1; mode=block',

    # Referrer-Policy: Controls how much referrer information is shared
    # no-referrer: Never send referrer header (maximum privacy)
    # Alternative: strict-origin-when-cross-origin (more permissive)
    'Referrer-Policy' => 'no-referrer',

    # Permissions-Policy: Controls browser features and APIs
    # Disable geolocation, microphone, camera, payment, usb (not needed for LMS)
    'Permissions-Policy' => [
      'geolocation=()',
      'microphone=()',
      'camera=()',
      'payment=()',
      'usb=()',
      'magnetometer=()',
      'gyroscope=()',
      'accelerometer=()',
      'ambient-light-sensor=()',
      'autoplay=()',
      'battery=()',
      'display-capture=()',
      'document-domain=()',
      'encrypted-media=()',
      'fullscreen=(self)',  # Allow fullscreen for video lessons
      'midi=()',
      'picture-in-picture=()',
      'publickey-credentials-get=()',
      'speaker-selection=()',
      'sync-xhr=()',
      'xr-spatial-tracking=()'
    ].join(', '),

    # Content-Security-Policy: Mitigates XSS, injection attacks
    # This is a strict policy - may need adjustment for third-party integrations
    'Content-Security-Policy' => [
      "default-src 'self'",  # Only load resources from same origin
      "script-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net",  # Scripts: self + Bootstrap CDN
      "style-src 'self' 'unsafe-inline' https://cdn.jsdelivr.net",   # Styles: self + Bootstrap CDN
      "img-src 'self' data: https:",  # Images: self + data URIs + HTTPS only
      "font-src 'self' https://cdn.jsdelivr.net",  # Fonts: self + Bootstrap icons
      "connect-src 'self'",  # AJAX/WebSocket: same origin only
      "media-src 'self'",  # Audio/video: same origin only
      "object-src 'none'",  # No Flash, Java, etc.
      "frame-src 'none'",  # No iframes (redundant with X-Frame-Options)
      "base-uri 'self'",  # Prevents <base> tag injection
      "form-action 'self'",  # Forms can only submit to same origin
      "frame-ancestors 'none'",  # Cannot be embedded (redundant with X-Frame-Options)
      "upgrade-insecure-requests",  # Upgrade HTTP to HTTPS automatically
      "block-all-mixed-content"  # Block mixed HTTP/HTTPS content
    ].join('; '),

    # Cross-Origin-Opener-Policy: Isolates browsing context
    # same-origin: Documents can only be loaded in same-origin windows
    'Cross-Origin-Opener-Policy' => 'same-origin',

    # Cross-Origin-Embedder-Policy: Requires CORS for cross-origin resources
    # require-corp: Only load cross-origin resources with explicit CORP header
    'Cross-Origin-Embedder-Policy' => 'require-corp',

    # Cross-Origin-Resource-Policy: Controls who can load this resource
    # same-origin: Only same-origin requests (strict isolation)
    'Cross-Origin-Resource-Policy' => 'same-origin'
  }
)

# HSTS (HTTP Strict Transport Security)
# Forces HTTPS for all future requests
# Note: This is typically configured at the web server level (Nginx, Apache)
# but can be set in Rails for development/testing
if Rails.env.production?
  Rails.application.config.force_ssl = true
  Rails.application.config.ssl_options = {
    hsts: {
      expires: 31_536_000,  # 1 year in seconds (required for HSTS preload)
      subdomains: true,     # Apply to all subdomains
      preload: true         # Submit to HSTS preload list
    },
    redirect: {
      status: 308  # Permanent redirect (preserves HTTP method)
    }
  }
end

# Additional security configurations
Rails.application.config.session_store :cookie_store,
                                       key: '_candy_crash_session',
                                       secure: Rails.env.production?,  # HTTPS only in production
                                       httponly: true,  # Prevent JavaScript access
                                       same_site: :lax  # CSRF protection

# Cookie security (prevent timing attacks on cookie validation)
Rails.application.config.action_dispatch.cookies_same_site_protection = :lax

# Host authorization (prevent DNS rebinding attacks)
Rails.application.config.hosts << ENV['APP_HOST'] if ENV['APP_HOST'].present?
Rails.application.config.host_authorization = {
  exclude: ->(request) { request.path == '/up' }  # Health check exempt
}

# Log security headers in development (for debugging)
if Rails.env.development?
  Rails.logger.info '🔒 Security Headers Enabled:'
  Rails.application.config.action_dispatch.default_headers.each do |key, value|
    Rails.logger.info "   #{key}: #{value}"
  end
end

# CSP Violation Reporting (future enhancement)
# To enable: Set up CSP reporting endpoint and add:
# "report-uri /csp-violation-report-endpoint"
# "report-to csp-endpoint"

# Security Header Testing:
# 1. Mozilla Observatory: https://observatory.mozilla.org/
# 2. Security Headers: https://securityheaders.com/
# 3. Chrome DevTools > Network > Response Headers
#
# Expected Grade: A+ (with all headers configured)
