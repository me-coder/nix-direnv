{ pkgs ? import <nixpkgs> {} }:
{
  inputs = with pkgs; [
    direnv
  ];
  hooks = ''
    alias ll="ls -Al"
    mkdir -p ~/.config/direnv
    cp ./.direnv/direnv.toml ~/.config/direnv/direnv.toml
    eval "$(direnv hook bash)"
  '';
}