Setup (I think can be done in live enviroment of Minimal NixOS image)
nix-shell -p git
git clone https://github.com/mrscallion90/nixos-config .
nixos-rebuild --upgrade switch -I nixos-config=/home/user/nixos-config/configuration.nix

[TODO] Command tree, explaining what each file does etc

[INFO]
nix-collect-garbage -d is only for the machine/system level
user level/home manager level is separate, needs to be cleaned as well

TODO:
[ ] Put disko for disk volumes as well
[ ] Setup secure boot
[x] Fix mic, noise cancellation and dB overboost
[ ] Home manager, or at least user wide configs
	- [ ] Port fish,tmux, neovim and user packages into Home Manager + plus KDE plasma as well
	- [ ] Configure plasma shell taskbar
	- [ ] Configure plasma theme
	- [ ] Tmux + TPM
		[ ] Continuum + Resurrect
		[ ] Yank mode
		[ ] floax (floating window)
		[ ] Tmuxifier (saves panes/session preset)
	- [ ] Try nvim with NixOS
		[ ] Try to make Helix keybinds
		[ ] Try to make Helix editing modal
[ ] Fish commands
	[ ] NixOS fish alias "nixos-rebuild-shortcut" doesnt work, maybe home manager related fix/issue
	[ ] doas nixos-rebuild $(echo "switch \n boot \n dry-activate" | fzf) --flake ./configuration.nix
		- or xargs?

[x] Progress bar for nixos-rebuild (nix-output-monitor)
[x] Spoof MAC Address on WiFi per connection
[ ] Spoof hostname as well on each boot
[x] Battery
[x] Bluetooth
[ ] Mouse Acceleration Disable
[x] Natural Scrolling

[ ] Wine setup for (maybe scripts at best)
	- [ ] Cisco Packet Tracer
	- [ ] Davinci Look Timetable

Programs to install/setup:
[x] Mullvad VPN GUI
[x] Bitwarden

FYP SETUP (flake)
[ ] Godot
[ ] Blender
