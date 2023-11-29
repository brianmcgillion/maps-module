# maps-module
nix module for maps interaction. This is an implementation of the tutorial from [nix.dev](https://nix.dev/)


[Module system deep dive](https://nix.dev/tutorials/module-system/module-system.html)


You need to download ``geocode`` and ``map`` from the site and also have a google-api key setup.

All errors are my own.

Building
``nix-build eval.nix -A config.scripts.output``

Running
``./result/bin/map``
