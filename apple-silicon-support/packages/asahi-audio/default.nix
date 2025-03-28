{ stdenv
, lib
, fetchFromGitHub
, lsp-plugins
, bankstown-lv2
, triforce-lv2
}:

stdenv.mkDerivation rec {
  pname = "asahi-audio";
  # tracking: https://src.fedoraproject.org/rpms/asahi-audio
  version = "3.1";

  src = fetchFromGitHub {
    owner = "AsahiLinux";
    repo = "asahi-audio";
    rev = "v${version}";
    hash = "sha256-oIL++8752duVassv/xtIiNqOEIBjntWxERxkLSxlE2Y=";
  };

  preBuild = ''
    export PREFIX=$out

    readarray -t configs < <(\
          find . \
                -name '*.conf' -or \
                -name '*.json' -or \
                -name '*.lua'
    )

    substituteInPlace "''${configs[@]}" --replace \
          "/usr/share/asahi-audio" \
          "$out/asahi-audio"
  '';

  postInstall = ''
    # no need to link the asahi-audio dir globally
    mv $out/share/asahi-audio $out
  '';

  passthru.requiredLv2Packages = [
    lsp-plugins
    bankstown-lv2
    triforce-lv2
  ];
}
