# MSP
Mud Sound Protocol plugin for Blightmud

# Installation
In Blightmud run: `/add_plugin https://github.com/Blightmud/msp`

## Usage

***MSP.set_dir(dir)***
Sets the directory where the audio files for your current mud is stored.
If this is not set the plugin will not operate.

- `dir` The path to the folder containing the files.

***MSP.set_filetype(suffix)***
Sets the audio filetyp suffix of your audio files. Defaults to `nil`
Some muds don't actually send the filesuffix. This will override this and
default to a certain file type.

- `suffix` The filetype suffix (eg. 'mp3', 'wav', 'ogg', 'flac')

## Functionality
This plugin will add triggers for `!!SOUND` and `!!MUSIC` lines and play
whatever file is provided if it exists in the directory you have specified.

If a soundfile doesn't exist this will be highlited by the plugin.

### What doesn't work yet

- Sound file wildcars (eg. `sword*`)
- Volume (`V`) parameter will be ignored because it's not yet supported in Blightmud.
- Loop (`L`) parameter
- Priority (`P`) parameter
- Continue (`C`) parameter
- Type (`T`) parameter
- Url (`U`) parameter

Any music requested will repeat indefinitely. Sounds will play once per
request. If you play a mud which has MSP and you are comfortable with Lua then
any contributions are more then welcome.
