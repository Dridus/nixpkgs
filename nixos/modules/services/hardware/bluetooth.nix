{ config, lib, pkgs, ... }:

with lib;
let
  bluez-bluetooth = pkgs.bluez;
in

{

  ###### interface

  options = {

    hardware.bluetooth.enable = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to enable support for Bluetooth.";
    };

  };

  ###### implementation

  config = mkIf config.hardware.bluetooth.enable {

    environment.systemPackages = [ bluez-bluetooth pkgs.openobex pkgs.obexftp ];

    services.udev.packages = [ bluez-bluetooth ];

    services.dbus.packages = [ bluez-bluetooth ];

    systemd.packages = [ bluez-bluetooth ];

    systemd.services.bluetooth = {
      wantedBy = [ "bluetooth.target" ];
      aliases = [ "dbus-org.bluez.service" ];
    };

    systemd.user.services.obex = {
      aliases = [ "dbus-org.bluez.obex.service" ];
    };

  };

}
