README
IF U WANT TO USE THIS CONFIG
BRING ~/misc/ with you for davinci look

one day, u copy this setup:
https://youtu.be/aNgujRXDTdE

flakes?
https://youtu.be/XcRe-XS2nak

Setup (assumes from base of graphical install of plasma)
nix-shell -p git
git clone https://github.com/mrscallion90/nixos-config .
nixos-rebuild --upgrade switch -I ./nixos-config/configuration.nix

afterwards, to edit and rebuild just
nixos-config
nixos-rebuild-shortcut
or
nixos-rebuild-shortcut --upgrade

if seems fine then, save it in on github:
lazygit or lg

to update, just use:
nix-channel --add <link> nixos

to clean, run:
nix-collect-garbage -d

[TODO] Command tree, explaining what each file does etc

[INFO]
nix-collect-garbage -d is only for the machine/system level
user level/home manager level is separate, needs to be cleaned as well

TODO:

new file tree:
configuration.nix
hardware.nix
home-manager/
home-manager/init.nix # import this in configuration.nix
home-manager/dev/neovim.nix
home-manager/dev/fish.nix




[ ] networkmanager config on nixos that reconnects VPN after each wifi connection
[ ] Put disko for disk volumes as well
[ ] Setup secure boot
[ ] Spoof hostname as well on each boot
[ ] Mouse Acceleration Disable

[ ] Home manager, or at least user wide configs
	- [ ] Configure plasma shell taskbar
	- [ ] Configure plasma theme
	- [ ] Tmux + TPM
		[ ] Continuum + Resurrect
		[ ] Yank mode
		[ ] floax (floating window)
		[ ] Tmuxifier (saves panes/session preset)
[ ] Fish alias
	[ ] doas nixos-rebuild $(echo "switch \n boot \n dry-activate" | fzf) --flake ./configuration.nix
		- or xargs?


[DONE]
FYP SETUP (flake) {nobody on my team gonna use flake, better lock it to a version through nixos anyway}
[x] Godot
[x] Blender

[x] Wine setup
	- [x] Cisco Packet Tracer (theres native built version, it works, have to fetch the binaries yourself for nixos)
	- [x] Davinci Look Timetable (wine setup in ~/misc/ which is cursed since its not reproducible but pushing binaries is a nono)

Programs to install/setup:
[x] Mullvad VPN GUI
[x] Bitwarden

[x] Progress bar for nixos-rebuild (nix-output-monitor)
[x] Spoof MAC Address on WiFi per connection
[x] Battery
[x] Bluetooth
[x] Natural Scrolling
[x] Try nvim with NixOS
	[x] Try to make Helix keybinds
	[x] Try to make Helix editing modal
