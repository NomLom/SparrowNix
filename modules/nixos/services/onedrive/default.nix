{ config, lib, ... }:
# https://nixos.wiki/wiki/OneDrive
{
services.onedrive.enable = true;
}
#systemctl --user enable onedrive@onedrive.service
#systemctl --user start onedrive@onedrive.service
