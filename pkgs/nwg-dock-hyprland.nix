{
  lib,
  buildGoModule,
  fetchFromGitHub,
  cairo,
  gobject-introspection,
  gtk3,
  gtk-layer-shell,
  pkg-config,
  wrapGAppsHook,
  xdg-utils,
}:
buildGoModule rec {
  pname = "nwg-dock-hyprland";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "nwg-piotr";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5RPp/CZgEkQDg+xn1xQDpLOCzfgWWdTl12aE+SRRPvE=";
  };

  vendorHash = "sha256-GhcrIVnZRbiGTfeUAWvslOVWDZmoL0ZRnjgTtQgxe2Q=";

  ldflags = ["-s" "-w"];

  nativeBuildInputs = [pkg-config wrapGAppsHook];
  buildInputs = [gtk-layer-shell];

  preInstall = ''
    mkdir -p $out/share/nwg-dock
    cp -r images $out/share/nwg-dock
    cp config/* $out/share/nwg-dock
  '';

  preFixup = ''
    # make xdg-open overrideable at runtime
    gappsWrapperArgs+=(
      --suffix PATH : ${xdg-utils}/bin
      --prefix XDG_DATA_DIRS : $out/share
    )
  '';

  meta = with lib; {
    description = "GTK3-based dock for Hyprland";
    homepage = "https://github.com/nwg-piotr/nwg-dock-hyprland";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [aleksana];
  };
}
