# 1. Define the status function
def get_vcs_status [] {
    # --- Try Jujutsu ---
    # We check if 'jj root' works.
    if not (do -i { jj root } | is-empty) {
        # Fetch bare info from jj (no colors in template to avoid syntax errors)
        # Template: ID Bookmarks ConflictString
        let raw = (do -i { 
            jj log --no-graph -r @ --color never --template '
            change_id.shortest(4) ++ " " ++ 
            bookmarks.join(", ") ++ 
            if(conflict, "CONFLICT", "") ++
            if(divergent, "DIVERGENT", "")
            ' 
        } | str trim)
        
        # Colorize in Nushell
        return $"(ansi purple)jj:($raw)(ansi reset)"
    }

    # --- Try Git ---
    if not (do -i { git rev-parse --is-inside-work-tree } | is-empty) {
        let branch = (do -i { git branch --show-current } | str trim)
        return $"(ansi red)git:($branch)(ansi reset)"
    }

    return ""
}

# 2. Set the Prompt Command
$env.PROMPT_COMMAND = {||
    # Calculate relative path safely
    let dir = (
        if ($env.PWD | str starts-with $nu.home-path) {
            $env.PWD | path relative-to $nu.home-path
        } else {
            $env.PWD
        }
    )
    
    let vcs = (get_vcs_status)
    
    # Draw the prompt
    $"\n(ansi blue)($dir) ($vcs)\n(ansi green)❯ (ansi reset)"
}

# 3. Optional Right Prompt
$env.PROMPT_COMMAND_RIGHT = {||
    let time = ($env.CMD_DURATION_MS | into int | into duration)
    if $env.LAST_EXIT_CODE != 0 {
        $"(ansi red)($env.LAST_EXIT_CODE) (ansi reset) ($time)"
    } else {
        $"($time)"
    }
}
