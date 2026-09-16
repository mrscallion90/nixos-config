Hi future me:

Make sure to put how to install this setup (commands)

Command tree, explaining what each file does etc

TODO:
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
	[ ] doas nixos-rebuild $(echo "switch \n boot \n dry-activate" | fzf) --flake ./configuration.nix
		- or xargs?

[x] Progress bar for nixos-rebuild (nix-output-monitor)
[x] Spoof MAC Address on WiFi per connection
[ ] Spoof hostname as well on each reboot
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
