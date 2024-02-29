{inputs, ...}: {
  # This one brings our custom packages from the 'pkgs' directory
  # additions = final: _prev: import ../pkgs {pkgs = final;};

  i3pyblocks = inputs.i3pyblocks.overlay;
  neorg = inputs.neorg-overlay.overlays.default;

  # This one contains whatever you want to overlay
  # You can change versions, add patches, set compilation flags, anything really.
  # https://nixos.wiki/wiki/Overlays
  # See examples here:
  # https://github.com/Misterio77/nix-config/blob/d39c4bfa163ab6ecccf2affded0a3e5ad4b8cc7b/overlays/default.nix
  modifications = final: prev: {
    bazarr = final.unstable.bazarr;
    jackett = final.unstable.jackett;
    navidrome = final.unstable.navidrome;
    # sonarr = final.unstable.sonarr;
    radarr = final.unstable.radarr;
    warp-terminal = prev.pfetch.overrideAttrs (oldAttrs: {
      version = "0.2024.02.20.08.01.stable_02";
      src = final.fetchurl {
        url = "https://releases.warp.dev/stable/v0.2024.02.20.08.01.stable_02/warp-terminal-v0.2024.02.20.08.01.stable_02-1-x86_64.pkg.tar.zst";
        hash = "0000000000000000000000";
      };
    });
  };

  #  comma = final.unstable.comma;

  # # neovim 0.8.1 of nixpkgs-22.11 has some problems with the copilot plugin
  # # Update 2023-06-08:
  # # Disabled this modification after switching to next release (23.05).
  # # Leaving it here for future reference.
  # neovim-unwrapped = final.unstable.neovim-unwrapped;
  # vimPlugins = final.unstable.vimPlugins;

  # When applied, the unstable nixpkgs set (declared in the flake inputs) will
  # be accessible through 'pkgs.unstable'
  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs-unstable {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
