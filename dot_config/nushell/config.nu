# $env.EDITOR = nvim
# $env.VISUAL = nvim
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_CELLAR = "/opt/homebrew/Cellar"
$env.HOMEBREW_REPOSITORY = "/opt/homebrew"

$env.PATH = ($env.PATH | append "~/.local/bin")
$env.PATH = ($env.PATH | append "~/.cargo/bin")
$env.PATH = ($env.PATH | append "~/go/bin")
$env.PATH = ($env.PATH | append "/usr/local/bin")
$env.PATH = ($env.PATH | append "~/.local/share/zigup")

use alias.nu *
use keybindings.nu get_keybindings 


$env.config = {
  show_banner: false,
  edit_mode: vi,
  keybindings: (get_keybindings)

}


use ~/.cache/starship/init.nu

