Switched to fedora
its a pain in the ass how the packages are outdated
lots of packages my ass
and its a pain in the ass to use
so we going private for this repo or not
and alot of bloat it has
(false alarm, i thought fedora uses 90 GB or sumn)
that was the game, fedora uses 10 GB (for now)

NO MORE VIBECODING OR OPENCODE BRAINROT
I CAN FEEL MY DOPAMINE FRIED
try to write organic brain made code

get away from AI/Vibecoding slop
a slippery slope with how addictive it is because "productivity" dopamine hit boost
and how tokens inflate like crazy, costs as well

and it makes you shitty at programmimg over time

its like a steroid
micro-doses or clinical use is fine
if abused, its bad
(bla bla all in moderacy)


REFACTOR, IT HAS GLUE CODE
THE FACT U STUMBLED USING GREP
just separate using files and folder
think of it as that one library sorting game


Fun Project
"Mini Jarvis" --> "Hatsune Miku"/Waifu?
STT + TTS + MCP + DeepSeek API
Local
Screenshot, [can describe and see]
[can it interact? pretty sure API allow only text] can move cursor and click
can interact with a tmux server
can it see ur user files or it has its own files?
prolly mcp server and some personality.md files
check out STT that can copy people voices
need memory, what VectorDB? dunno if api support that. maybe just md files of chat log summary or profiling(.gitignore)
AI Psychosis huh?
for mic, u have to hold down the button?
but i wanna say "jarvis, open btop! or hollywood!" without pressing anything
so its like siri, always listening
avatar: live2D, image/gif
important: voice recognition (it only respond to my voice)
practical usage?
can write/read my emails
edit my todolist on google keep
and put stuff on google calendar
kinda want it on my phone....
basically over-glorified glue code
python libraries carrying essentially
see openrouter free models and its embeddings & text
https://youtu.be/Ef5zPm7U7So
ideally this setup runs locally, high chances deepseek
one llm only (no bullshit multi-agent nonsense, i prefer it sequential and only one thing that runs so i can keep track)
emails use template with POP/IMAP protocol
hope google keep and google calendar got its own library python
i want that display touchscreen mirror (jsholz) or projector that shows report of messages from slack, emails, anything work
maybe personal email
i mean if u have a PC, u might get a UPS and keep it on all times ngl
if u have PC, u might get a tablet for entertainment or maybe fancy long battery ssh/vnc machine
totally mini ITX pc and some nas server
ideally, u wanna degoogle and self host
dnssec carrying
and phone minimal ig
yeah, this is wanking off to fantasy
python + mardown + mcp + cli scripts
no nodejs stuff or too many depedencies (dont want supply chain attack or install weird plugins)
kept simple and minimal

# separate repo? nahh
# i prefer hatsune miku integrated in my OS 
# literally nyacraft + omarchy
modules
in
hatsune-miku/
in
src/
init.nix
linker.nix
dotenv.nix #.gitignore
# basically our config file, python just read the env
dotenv.nix.example 

src/
in
llm/ # opens a session or continue a session from API
llm/module.py

src/
in
avatar/
avatar/personality.txt
avatar/live2d # later
avatar/siri-like/
avatar/png-gifs

src/
in
audio/
audio/tts/
audio/tts/module.py
audio/tts/config.py or miku-voicebank.py

audio/stt/module.py

src/
in
mcp/
mcp/server/
mcp/server/module.py
mcp/server/server.py
mcp/server/cli.py

mcp/tools/main.py
mcp/tools/report.py

mcp/tools/email/
mcp/tools/email/read.py
mcp/tools/email/write.py
mcp/tools/email/delete.py
mcp/tools/email/templates/*.txt or *.html

mcp/tools/google/

mcp/tools/google/calendar/
mcp/tools/google/calendar/read.py
mcp/tools/google/calendar/write.py
mcp/tools/google/calendar/delete.py

mcp/tools/google/keep
mcp/tools/google/keep/read.py
mcp/tools/google/keep/write.py
mcp/tools/google/keep/delete.py


https://m.youtube.com/watch?v=jlWnoRsGJNQ
learn rust following this guys stack
its pretty goated

imagine wfh and waking pc from sleep or press mirror or stand near mirror (soundwave sensor or sumn) and get report of today

personal life needs to be its own space so just read, reply its own messages
maybe get a dumbphone? or nokia 🗿

try to see if u can duplicate ur sim (unlimited data)
or if u can convert it into esim and use some usb dongle to connect mobile data


[x] sway + waybar
[x] terminal blur
[x] notification
[x] widgets (wifi, bluetooth, date/time, battery)
[x] wallpaper picker (autodefaults, saves current wallpaper in some dir)
[x] colorscheme theme autochange to wallpaper
[x] night light
[x] application launcher 
theme = blur + minimal + clean (most important: fun to use)

make docs/ folder
with neovim.txt on
''
tmux (prefix = ctrl b)
prefix t : terminal
prefix g : lazygit
prefix m : ncmpcpp (mpd client;music player)

nvim (prefix = space)
prefix w : jump word
prefix g : grep picker
prefix f : file picker
prefix o : Oil (file explorer)

neovim.nix philosophy:
- minimal (no useless fancy feature, focus programming)
- onefile (easy to maintain/debug/edit/understand)
''

README
IF U WANT TO USE THIS CONFIG
BRING ~/misc/ with you for davinci look

one day, u copy this setup:
https://youtu.be/aNgujRXDTdE

flakes?
https://youtu.be/XcRe-XS2nak
https://youtu.be/a67Sv4Mbxmc

this guy seems solid:
copy his shit
https://codeberg.org/mateowoetam/configuration.nix/src/branch/main

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
dotenv.nix # where the nixos config lives or ./misc etc
configuration.nix
hardware.nix
home-manager/
home-manager/init.nix # import this in configuration.nix
home-manager/dev/neovim.nix
home-manager/dev/fish.nix




[ ] Apparently you can maximize RAM to iGPU for LLM usage
https://wiki.nixos.org/wiki/AMD_GPU
[ ] KDE: Limit the maximum battery charge
[ ] https://m.youtube.com/watch?v=13hSE3bGIJo
LFS! Or T2 SDE to bootstrap?
[ ] https://m.youtube.com/watch?v=0QZI_m8WZ0Q
Learn LEAN, remember trying a mathematical (functional) magical system when u had schizo episode? chase that high again
[ ] Use emacs and revolve whole workflow around it like lcolonq (doom & evil emacs)
https://m.youtube.com/watch?v=PKaJoqQQoIA
[ ] Test reproducability in Virtual Machine
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
