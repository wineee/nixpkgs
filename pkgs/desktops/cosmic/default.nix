{ lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  cosmic-text = callPackage ./cosmic-text { };
})
