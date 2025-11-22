# Candy Crash LMS - Just Task Runner
# https://github.com/casey/just

# Load environment variables from .env if present
set dotenv-load := true

# Default recipe to display help
default:
    @just --list

# === DEVELOPMENT ===

# Start the Rails development server
serve:
    bin/rails server

# Start Rails console
console:
    bin/rails console

# Generate Rails scaffold/model/controller
generate *ARGS:
    bin/rails generate {{ARGS}}

# Open Rails database console
db-console:
    bin/rails dbconsole

# === DATABASE ===

# Create database
db-create:
    bin/rails db:create

# Run database migrations
db-migrate:
    bin/rails db:migrate

# Rollback last migration
db-rollback:
    bin/rails db:rollback

# Reset database (drop, create, migrate, seed)
db-reset:
    bin/rails db:drop db:create db:migrate db:seed

# Seed database with sample data
db-seed:
    bin/rails db:seed

# Setup database (create + migrate + seed)
db-setup:
    bin/rails db:setup

# Show database migration status
db-status:
    bin/rails db:migrate:status

# === TESTING ===

# Run all RSpec tests
test:
    bundle exec rspec

# Run tests with coverage report
test-coverage:
    COVERAGE=true bundle exec rspec

# Run specific test file
test-file FILE:
    bundle exec rspec {{FILE}}

# Run tests matching a pattern
test-grep PATTERN:
    bundle exec rspec --tag {{PATTERN}}

# === CODE QUALITY ===

# Run RuboCop linter
lint:
    bundle exec rubocop

# Auto-fix RuboCop violations
lint-fix:
    bundle exec rubocop -a

# Run Brakeman security scanner
security:
    brakeman --run-all-checks

# Check for vulnerable gem dependencies
audit:
    bundle audit check --update

# Run all quality checks
quality: lint security audit

# === INSTALLATION ===

# Install all dependencies
install:
    bundle install
    npm install

# Update dependencies
update:
    bundle update
    npm update

# Clean dependency caches
clean:
    rm -rf tmp/cache
    rm -rf log/*.log
    rm -rf public/assets
    rm -rf node_modules/.cache

# === BUILD ===

# Precompile assets for production
assets-precompile:
    bin/rails assets:precompile

# Clean precompiled assets
assets-clean:
    bin/rails assets:clobber

# === DOCUMENTATION ===

# Generate annotated models
annotate:
    bundle exec annotate --models --position before

# Generate ERD diagram
erd:
    bundle exec erd --filename=docs/erd --title="Candy Crash ERD"

# Open Rails API docs
docs:
    open https://api.rubyonrails.org/

# === RSR COMPLIANCE ===

# Validate RSR compliance
validate-rsr:
    @echo "🔍 Checking RSR Compliance..."
    @echo ""
    @echo "✅ Documentation:"
    @test -f README.md && echo "  ✓ README.md" || echo "  ✗ README.md missing"
    @test -f LICENSE && echo "  ✓ LICENSE" || echo "  ✗ LICENSE missing"
    @test -f SECURITY.md && echo "  ✓ SECURITY.md" || echo "  ✗ SECURITY.md missing"
    @test -f CONTRIBUTING.md && echo "  ✓ CONTRIBUTING.md" || echo "  ✗ CONTRIBUTING.md missing"
    @test -f CODE_OF_CONDUCT.md && echo "  ✓ CODE_OF_CONDUCT.md" || echo "  ✗ CODE_OF_CONDUCT.md missing"
    @test -f MAINTAINERS.md && echo "  ✓ MAINTAINERS.md" || echo "  ✗ MAINTAINERS.md missing"
    @test -f CHANGELOG.md && echo "  ✓ CHANGELOG.md" || echo "  ✗ CHANGELOG.md missing"
    @test -f CLAUDE.md && echo "  ✓ CLAUDE.md" || echo "  ✗ CLAUDE.md missing"
    @echo ""
    @echo "✅ .well-known Directory:"
    @test -f public/.well-known/security.txt && echo "  ✓ security.txt (RFC 9116)" || echo "  ✗ security.txt missing"
    @test -f public/.well-known/ai.txt && echo "  ✓ ai.txt" || echo "  ✗ ai.txt missing"
    @test -f public/.well-known/humans.txt && echo "  ✓ humans.txt" || echo "  ✗ humans.txt missing"
    @echo ""
    @echo "✅ Build System:"
    @test -f justfile && echo "  ✓ justfile" || echo "  ✗ justfile missing"
    @test -f .github/workflows/ci.yml && echo "  ✓ CI/CD (GitHub Actions)" || echo "  ✗ CI/CD missing"
    @test -f Dockerfile && echo "  ✓ Dockerfile" || echo "  ✗ Dockerfile missing"
    @echo ""
    @echo "✅ Testing:"
    @test -f spec/spec_helper.rb && echo "  ✓ RSpec configured" || echo "  ✗ RSpec not configured"
    @echo "  • Running test suite..."
    @bundle exec rspec --format progress 2>&1 | tail -n 1
    @echo ""
    @echo "✅ Security:"
    @echo "  • Running Brakeman..."
    @brakeman --quiet --no-pager 2>&1 | grep -E "(No warnings|warnings)" || echo "  ! Brakeman not installed"
    @echo "  • Running Bundle Audit..."
    @bundle audit check 2>&1 | grep -E "(No vulnerabilities|Vulnerabilities)" || echo "  ! Bundler Audit not installed"
    @echo ""
    @echo "🎉 RSR Compliance Check Complete!"

# === DEPLOYMENT ===

# Run deployment checks
deploy-check:
    @echo "Running pre-deployment checks..."
    just test
    just quality
    @echo "✅ Ready for deployment!"

# Create new release tag
release VERSION:
    @echo "Creating release {{VERSION}}..."
    git tag -a v{{VERSION}} -m "Release version {{VERSION}}"
    git push origin v{{VERSION}}
    @echo "✅ Release v{{VERSION}} created!"

# === UTILITIES ===

# Show Rails routes
routes:
    bin/rails routes

# Show database schema
schema:
    bin/rails db:schema:dump
    cat db/schema.rb

# Count lines of code
loc:
    @echo "Lines of Code:"
    @find app -name '*.rb' | xargs wc -l | tail -n 1
    @echo ""
    @echo "Test Code:"
    @find spec -name '*.rb' | xargs wc -l | tail -n 1

# Show project statistics
stats:
    bin/rails stats

# === DOCKER ===

# Build Docker image
docker-build:
    docker build -t candy-crash .

# Run Docker container
docker-run:
    docker run -p 3000:3000 candy-crash

# Docker Compose up
docker-up:
    docker-compose up -d

# Docker Compose down
docker-down:
    docker-compose down

# === GIT ===

# Create a feature branch
feature BRANCH:
    git checkout -b feature/{{BRANCH}}

# Create a fix branch
fix BRANCH:
    git checkout -b fix/{{BRANCH}}

# Show git log with nice formatting
log:
    git log --oneline --graph --decorate --all -20

# === HELP ===

# Show detailed help for a recipe
help RECIPE:
    @just --show {{RECIPE}}
