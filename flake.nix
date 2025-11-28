{
  description = "Candy Crash - UK Driving Licence Preparation Platform";

  # SPDX-License-Identifier: GPL-3.0-or-later

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    flake-utils.url = "github:numtide/flake-utils";

    # Ruby environment
    bundix = {
      url = "github:nix-community/bundix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, bundix }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = false; # FOSS only
        };

        # Ruby version must match .ruby-version
        ruby = pkgs.ruby_3_3;

        # Node.js for asset compilation
        nodejs = pkgs.nodejs_20;

        # System dependencies for Rails
        systemDeps = with pkgs; [
          # Database
          sqlite
          postgresql_16

          # Build tools
          gcc
          gnumake
          pkg-config

          # Image processing (Active Storage)
          imagemagick
          libvips

          # JavaScript runtime
          nodejs
          yarn

          # Additional utilities
          git
          just

          # Security tools
          brakeman

          # Nix tools
          bundix
        ];

        # Ruby gems bundled via Bundler
        gems = pkgs.bundlerEnv {
          name = "candy-crash-gems";
          inherit ruby;
          gemdir = ./.;
          # Note: Run `bundix` to generate gemset.nix from Gemfile.lock
        };

      in
      {
        # Development shell
        devShells.default = pkgs.mkShell {
          buildInputs = systemDeps ++ [ ruby gems ];

          shellHook = ''
            echo "🍬 Candy Crash Development Environment"
            echo "======================================"
            echo "Ruby: ${ruby.version}"
            echo "Rails: $(bundle exec rails -v 2>/dev/null || echo 'Run: bundle install')"
            echo "Node: ${nodejs.version}"
            echo ""
            echo "Quick commands:"
            echo "  just serve       - Start development server"
            echo "  just test        - Run test suite"
            echo "  just db-setup    - Initialize database"
            echo "  just validate    - Run all checks"
            echo ""

            # Set up environment variables
            export GEM_HOME="$PWD/.gems"
            export GEM_PATH="$GEM_HOME:${gems}"
            export PATH="$GEM_HOME/bin:$PATH"
            export BUNDLE_PATH="$GEM_HOME"

            # Rails environment
            export RAILS_ENV=development
            export RACK_ENV=development

            # Database configuration
            export DATABASE_URL="sqlite3:db/development.sqlite3"

            # Disable analytics
            export RAILS_TELEMETRY_OPT_OUT=1

            # Set locale
            export LANG=en_US.UTF-8
            export LC_ALL=en_US.UTF-8
          '';
        };

        # Production build (containerized)
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "candy-crash";
          version = "1.0.0";
          src = ./.;

          buildInputs = systemDeps ++ [ ruby gems ];

          buildPhase = ''
            export HOME=$TMPDIR
            export GEM_HOME=$HOME/.gems
            export GEM_PATH=$GEM_HOME:${gems}
            export PATH=$GEM_HOME/bin:$PATH

            # Install dependencies
            bundle config set --local deployment true
            bundle install

            # Precompile assets
            RAILS_ENV=production bundle exec rails assets:precompile

            # Compile bootsnap cache
            bundle exec bootsnap precompile --gemfile app/ lib/
          '';

          installPhase = ''
            mkdir -p $out
            cp -r . $out/

            # Remove development files
            rm -rf $out/spec $out/test $out/tmp $out/log

            # Create necessary directories
            mkdir -p $out/tmp $out/log $out/public/uploads
          '';

          meta = with pkgs.lib; {
            description = "UK Driving Licence Preparation Platform based on PRIMROSE protocol";
            homepage = "https://github.com/Hyperpolymath/candy-crash";
            license = licenses.gpl3Plus;
            platforms = platforms.linux ++ platforms.darwin;
            maintainers = [ ];
          };
        };

        # Container image (Podman/OCI compliant)
        packages.container = pkgs.dockerTools.buildLayeredImage {
          name = "candy-crash";
          tag = "latest";

          contents = [ self.packages.${system}.default pkgs.coreutils ];

          config = {
            Cmd = [ "${self.packages.${system}.default}/bin/rails" "server" "-b" "0.0.0.0" ];
            ExposedPorts = {
              "3000/tcp" = {};
            };
            Env = [
              "RAILS_ENV=production"
              "RACK_ENV=production"
              "RAILS_LOG_TO_STDOUT=1"
              "RAILS_SERVE_STATIC_FILES=1"
            ];
            WorkingDir = "${self.packages.${system}.default}";
          };
        };

        # Checks (run via: nix flake check)
        checks = {
          # Test suite
          tests = pkgs.stdenv.mkDerivation {
            name = "candy-crash-tests";
            src = ./.;
            buildInputs = systemDeps ++ [ ruby gems ];

            buildPhase = ''
              export HOME=$TMPDIR
              bundle config set --local deployment true
              bundle install

              # Setup test database
              RAILS_ENV=test bundle exec rails db:setup

              # Run tests
              bundle exec rspec
            '';

            installPhase = ''
              mkdir -p $out
              echo "Tests passed" > $out/result
            '';
          };

          # Security audit
          security = pkgs.stdenv.mkDerivation {
            name = "candy-crash-security";
            src = ./.;
            buildInputs = systemDeps ++ [ ruby gems pkgs.brakeman ];

            buildPhase = ''
              bundle install
              brakeman --run-all-checks --exit-on-warn .
            '';

            installPhase = ''
              mkdir -p $out
              echo "Security checks passed" > $out/result
            '';
          };
        };

        # Formatter
        formatter = pkgs.nixpkgs-fmt;

        # Apps
        apps.default = {
          type = "app";
          program = "${self.packages.${system}.default}/bin/rails";
        };

        apps.console = {
          type = "app";
          program = pkgs.writeScript "rails-console" ''
            #!${pkgs.bash}/bin/bash
            cd ${self.packages.${system}.default}
            ${ruby}/bin/bundle exec rails console
          '';
        };
      }
    );
}
