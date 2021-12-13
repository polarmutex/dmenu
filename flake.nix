{
  description = "polarmutex customized dmenu";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";

      overlay = final: prev: {
        dmenu = prev.dmenu.overrideAttrs (old: {
          src = builtins.path { path = ./.; name = "dmenu"; };
        });
      };

      pkgs = import nixpkgs {
        inherit system;
      };
    in
    {
      inherit overlay;

      checks.${system}.build = (
        import nixpkgs {
          inherit system;
          overlays = [ overlay ];
        }
      ).dmenu;

      devShell.x86_64-linux = pkgs.mkShell {
        buildInputs = with pkgs; [ xorg.libX11 xorg.libXft xorg.libXinerama gcc ];
      };
    };
}
