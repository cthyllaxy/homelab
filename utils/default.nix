{
  mkUnraidShare = device: {
    device = "${device}";
    fsType = "virtiofs";
    options = [
      "nofail"
      "rw"
      "relatime"
    ];
  };
}
