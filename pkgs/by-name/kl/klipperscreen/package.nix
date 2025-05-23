{
  lib,
  python3,
  fetchFromGitHub,
  wrapGAppsHook3,
  gobject-introspection,
  gitUpdater,
}:
python3.pkgs.buildPythonApplication rec {
  pname = "KlipperScreen";
  version = "0.4.5";
  format = "other";

  src = fetchFromGitHub {
    owner = "KlipperScreen";
    repo = "KlipperScreen";
    rev = "v${version}";
    hash = "sha256-lKGMz5N4lKSqA614wjJiUfP5fUY+WqFDPxeX/Iyp2TQ=";
  };

  nativeBuildInputs = [
    gobject-introspection
    wrapGAppsHook3
  ];

  pythonPath = with python3.pkgs; [
    jinja2
    netifaces
    requests
    websocket-client
    pycairo
    pygobject3
    mpv
    six
    dbus-python
    sdbus-networkmanager
  ];

  dontWrapGApps = true;

  preFixup = ''
    mkdir -p $out/bin
    cp -r . $out/dist
    gappsWrapperArgs+=(--set PYTHONPATH "$PYTHONPATH")
    wrapGApp $out/dist/screen.py
    ln -s $out/dist/screen.py $out/bin/KlipperScreen
  '';

  passthru.updateScript = gitUpdater { url = meta.homepage; };

  meta = with lib; {
    description = "Touchscreen GUI for the Klipper 3D printer firmware";
    homepage = "https://github.com/jordanruthe/KlipperScreen";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [
      cab404
      saturn745
    ];
    mainProgram = "KlipperScreen";
  };
}
