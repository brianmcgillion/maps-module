{
  pkgs,
  lib,
  config,
  ...
}: {
  imports = [
    ./marker.nix
  ];

  options = {
    scripts.output = lib.mkOption {
      type = lib.types.package;
    };

    scripts.geocode = lib.mkOption {
      type = lib.types.package;
    };

    requestParams = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };

    map = {
      zoom = lib.mkOption {
        type = lib.types.nullOr lib.types.int;
        default = 2;
      };

      center = lib.mkOption {
        type = lib.types.nullOr lib.types.string;
        default = "switzerland";
      };
    };
  };

  config = {
    scripts.output = pkgs.writeShellApplication {
      name = "map";
      runtimeInputs = with pkgs; [curl feh];
      text = ''
        ${./map} ${lib.concatStringsSep " " config.requestParams} | feh -
      '';
    };

    scripts.geocode = pkgs.writeShellApplication {
      name = "geocode";
      runtimeInputs = with pkgs; [curl jq];
      text = ''exec ${./geocode} "$@"'';
    };

    users."alice" = {
      departure = {
        location = "Vancouver";
        style.label = "Z";
      };
      arrival = {
        location = "Paris";
      };
      pathStyle = {
        geodesic = true;
      };
    };
    users."bob" = {
      departure = {
        location = "Zurich";
        style.color = "blue";
      };
      arrival = {
        location = "Helsinki";
        style.color = "black";
      };
      pathStyle = {
        color = "orange";
      };
    };
    users."eve" = {
      departure = {
        location = "New York";
        style.label = "E";
      };
      arrival = {
        location = "Vancouver";
      };
      pathStyle = {
        weight = 15;
        color = "purple";
        geodesic = true;
      };
    };

    requestParams = [
      "size=640x640"
      "scale=2"
      (lib.mkIf (config.map.zoom != null)
        "zoom=${toString config.map.zoom}")
      (lib.mkIf (config.map.center != null)
        "center=\"$(${config.scripts.geocode}/bin/geocode ${lib.escapeShellArg config.map.center})\"")
    ];
  };
}
