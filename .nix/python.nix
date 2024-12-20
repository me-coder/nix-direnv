with (import <nixpkgs> {});
let
  ws-python-packages = python-packages: with python-packages; [
    pip
    # other python packages you want
  ];
  python-with-my-packages = python3.withPackages ws-python-packages;
in
mkShellNoCC {
  buildInputs = [
    pkgs.python313
    python-with-my-packages
  ];
}