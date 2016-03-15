module RunitSettings
  RunitDir = File::expand_path("~/.config/runit")
  AllServicesDir = File::join(RunitDir, "services")
  RunsvDir = File::join(RunitDir, "runsvdir")
  SvSkelDir = File::join(RunitDir, "skels/sv")
end
