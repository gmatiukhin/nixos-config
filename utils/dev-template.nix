# https://ryantm.github.io/nixpkgs/builders/special/fhs-environments/
{ pkgs ? import <nixpkgs> {} }:
(pkgs.buildFHSUserEnv {
  name = "%name%";
  targetPkgs = pkgs: (with pkgs; []);
  runScript = "fish";
}).env
