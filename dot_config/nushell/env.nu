$env.PATH = ($env.PATH | prepend "/opt/homebrew/bin")

let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force
