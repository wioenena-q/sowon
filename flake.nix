{
  description = "Tsoding sowon project";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: 
  let
  supportedSystems = [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"];
  forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
  nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });

  in{
    packages = forAllSystems (system:
    let pkgs = nixpkgsFor.${system};
    in {
      sowon = pkgs.stdenv.mkDerivation {
        name = "sowon";
	src = ./.

	buildInputs = with pkgs; [SDL2 pkg-config];

	buildPhase = ''
	  make
	'';

	installPhase = ''
	  mkdir -p $out/bin
	  mv sowon $out/bin
	'';
      };
    });

    defaultPackage = forAllSystems (system: self.packages.${system}.sowon);
  };
}
