{
  description = "Course Mesh development environment";

  nixConfig = {
    netrc-file = "/etc/nix/netrc";
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    in {
      devShells.${system}.default = pkgs.mkShell {
        name = "course-mesh-dev";

        packages = with pkgs; [
          # Core
          bun
          nodejs_22
          curl
          wget
          unzip

          # Supabase
          supabase-cli

          # Database tools
          postgresql

          # CLI / utilities
          jq
          ripgrep
          fd
          tree
          just

          # TypeScript tooling
          typescript
          typescript-language-server

          # Formatting / linting
          biome

          # Editors
          # vscode

          # Native build deps
          pkg-config
          openssl

          # Misc scripting
          python3
        ];

        # Tells Nix to pass the main system's GIT_ASKPASS or token as a file
        passthru.passAsFiles = [ "GIT_TOKEN" ];
        
        # Pulls the token from your host environment or shellrc
        env = {
          GIT_TOKEN = builtins.getEnv "MY_GIT_TOKEN"; 
        };

        shellHook = ''
          echo ""
          echo "🚀 Course Mesh Dev Environment"
          echo ""

          # Use the passed environment variables inside the flake
          export GIT_AUTHOR_NAME="soupCodez"
          export GIT_AUTHOR_EMAIL="57576747+soupCodez@users.noreply.github.com"
          git config --global user.email "57576747+soupCodez@users.noreply.github.com"
          git config --global user.name "soupCodez"
          export GIT_CONFIG_GLOBAL="$HOME/.gitconfig"

          echo "Bun:  $(bun --version)"
          echo "Node: $(node -v)"
          echo ""

          export NEXT_TELEMETRY_DISABLED=1

          # Disable noisy package manager telemetry/funding
          export npm_config_fund=false
          export npm_config_audit=false

          export BUN_INSTALL="$HOME/.bun"
          export PATH="$BUN_INSTALL/bin:$PATH"

          source ../.bashrc

          echo "Ready to build Course Mesh."
          echo ""
        '';
      };
    };
}
