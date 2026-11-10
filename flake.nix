{
  description = "An upgrade-safe engineering workflow distribution for Haskell Agent";

  inputs = {
    haskell-agent.url = "github:digitallyinduced/haskell-agent";
    # Use the runtime's tested package set, not an independently drifting pin.
    nixpkgs.follows = "haskell-agent/nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
      haskell-agent,
      ...
    }:
    let
      # Expand only when there is evidence for another deployment target.
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" ];
    in
    {
      packages = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = self.packages.${system}.info;
          info = pkgs.writeShellApplication {
            name = "agent-workflow";
            text = ''
              printf '%s\n' \
                'agent-workflow: bootstrap skeleton; no workflow tools or profile enforcement yet.' \
                'Upstream Haskell Agent revision: ${haskell-agent.rev or "unversioned"}' \
                'Plan: https://github.com/BeaudanBrown/agent-workflow/issues' \
                'Explicit raw runtime: nix run .#upstream-agent -- --help' \
                'This command does not start an agent or modify user configuration.'
            '';
          };
          resources = pkgs.runCommand "agent-workflow-resources" { } ''
            mkdir -p "$out/share/agent-workflow"
            cp ${./README.md} "$out/share/agent-workflow/README.md"
            cp ${./CONTEXT.md} "$out/share/agent-workflow/CONTEXT.md"
            cp -R ${./docs} "$out/share/agent-workflow/docs"
          '';
          # An explicit escape hatch, not the future configured trial launcher.
          upstream-agent = haskell-agent.packages.${system}.default;
        }
      );

      apps = forAllSystems (system: {
        default = {
          type = "app";
          program = "${self.packages.${system}.info}/bin/agent-workflow";
          meta.description = "Describe the bootstrap without starting an agent";
        };
        upstream-agent = {
          type = "app";
          program = "${self.packages.${system}.upstream-agent}/bin/agent-cli";
          meta.description = "Run unmodified upstream Haskell Agent (no workflow integration)";
        };
      });

      checks = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          docs = pkgs.runCommand "agent-workflow-docs-check" { nativeBuildInputs = [ pkgs.python3 ]; } ''
            python3 ${./scripts/check-docs.py} ${self}
            python3 -m unittest discover -s ${self}/tests
            touch "$out"
          '';
          format = pkgs.runCommand "agent-workflow-format-check" { nativeBuildInputs = [ pkgs.nixfmt ]; } ''
            nixfmt --check ${./flake.nix}
            touch "$out"
          '';
          smoke = pkgs.runCommand "agent-workflow-info-check" { } ''
            ${self.packages.${system}.info}/bin/agent-workflow > info.txt
            grep -F 'bootstrap skeleton' info.txt
            touch "$out"
          '';
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShellNoCC {
            packages = [
              pkgs.git
              pkgs.gh
              pkgs.python3
              pkgs.nixfmt
            ];
          };
        }
      );

      formatter = forAllSystems (system: nixpkgs.legacyPackages.${system}.nixfmt);
    };
}
