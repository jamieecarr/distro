{
  description = "Custom NixOS-based desktop — lightweight macOS-feeling Linux";

  nixConfig = {
    extra-substituters = [
      "https://noctalia.cachix.org"
      "https://cache.numtide.com"
    ];
    extra-trusted-public-keys = [
      "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      "niks3.numtide.com-1:DTx8wZduET09hRmMtKdQDxNNthLQETkc/yaX7M4qK0g="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # llm-agents.nix — daily-updated Nix packages for AI coding agents.
    # Provides claude-code and other AI tools, updated more frequently
    # than nixpkgs.
    llm-agents = {
      url = "github:numtide/llm-agents.nix";
    };
  };

  outputs = { self, nixpkgs, home-manager, noctalia, llm-agents, ... }:
  let
    system = "x86_64-linux";
    specialArgs = { inherit noctalia; };
  in
  {

    # ---------- Main system configuration (for installing to disk) ----------
    nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./hosts/laptop/configuration.nix
        ./hosts/laptop/hardware.nix

        # Apply the llm-agents overlay so claude-code is available as a package
        { nixpkgs.overlays = [ llm-agents.overlays.default ]; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.user = import ./home;
        }
      ];
    };

    # ---------- Live ISO configuration (for booting from USB) ----------
    nixosConfigurations.iso = nixpkgs.lib.nixosSystem {
      inherit system specialArgs;
      modules = [
        ./iso.nix
        ./hosts/laptop/configuration.nix

        { nixpkgs.overlays = [ llm-agents.overlays.default ]; }

        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = specialArgs;
          home-manager.users.user = import ./home;
        }
      ];
    };
  };
}
