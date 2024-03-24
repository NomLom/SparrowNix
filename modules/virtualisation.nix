{
  config,
  pkgs,
  user,
  ...
}: {
  virtualisation = {
    docker = {
      enable = false;
      storageDriver = "btrfs";
      rootless = {
        enable = true;
        setSocketVariable = true;
      };
    };
    libvirtd.enable = true;

  };
  programs.virt-manager.enable = true;
  environment.systemPackages = with pkgs; [
    docker-compose
  ];

  users.users.leon.extraGroups = ["libvirtd" "docker"];
  users.extraGroups.vboxusers.members = ["user-with-access-to-virtualbox"];
}
