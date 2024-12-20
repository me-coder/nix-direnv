with (import (fetchTarball https://github.com/NixOS/nixpkgs/tarball/nixos-24.11-small) {});
let
  basePackages = with pkgs; [
    gitMinimal
  ];
  localPath = ./.nix/local.nix;
  inputs = basePackages
    ++ lib.optional (builtins.pathExists localPath) (import localPath {}).inputs;

  baseHooks = ''
    alias gs="git status"
  '';
  customHooks = baseHooks
    + lib.optionalString (builtins.pathExists localPath) (import localPath {}).hooks;

in mkShellNoCC {
  buildInputs = inputs;
  shellHook = customHooks;
}
