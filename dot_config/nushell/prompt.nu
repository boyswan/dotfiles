# --- 1. Environment Status (Nix/Direnv) ---
def get_env_status [] {
    let parts = []
    
    # Check for Nix Flake
    let parts = (if ("flake.nix" | path exists) { $parts | append "" } else { $parts })
    
    # Check for Active Direnv
    let parts = (if ($env.DIRENV_DIR? | is-not-empty) { $parts | append "▼" } else { $parts })

    if ($parts | is-empty) {
        return ""
    }
    # Return Yellow status
    return $"(ansi yellow)($parts | str join ' ')(ansi reset) "
}

# --- 2. VCS Status (JJ / Git) ---
def get_vcs_status [] {
    # A. TRY JUJUTSU
    let jj_check = (do -i { jj root } | complete)

    if $jj_check.exit_code == 0 {
        # Template Construction
        # Colors:
        # \x1b[35m   = Magenta (ID/Bookmarks)
        # \x1b[32m   = Green (Description)
        # \x1b[1;31m = Bold Red (Conflict)
        # \x1b[1;33m = Bold Yellow (Divergent)
        # \x1b[90m   = Dark Gray (Immutable/Hidden)
        # \x1b[0m    = Reset
        
        let template = '
        raw_escape_sequence("\x1b[35m") ++
        change_id.shortest(4) ++ 
        if(bookmarks, " [" ++ bookmarks.join(", ") ++ "]") ++ 
        raw_escape_sequence("\x1b[0m") ++ 
        
        if(conflict,  raw_escape_sequence("\x1b[1;31m") ++ " ×"  ++ raw_escape_sequence("\x1b[0m"), "") ++
        if(divergent, raw_escape_sequence("\x1b[1;33m") ++ " ≠" ++ raw_escape_sequence("\x1b[0m"), "") ++
        if(hidden,    raw_escape_sequence("\x1b[90m")   ++ " ø"   ++ raw_escape_sequence("\x1b[0m"), "") ++
        if(immutable, raw_escape_sequence("\x1b[90m")   ++ " ∞"   ++ raw_escape_sequence("\x1b[0m"), "") ++

        " | " ++

        if(empty, "∅ ", "") ++
        
        raw_escape_sequence("\x1b[32m") ++ 
        coalesce(
            description.first_line().substr(0, 30),
            "(no description)"
        ) ++ 
        raw_escape_sequence("\x1b[0m")
        '

        let stat = (do -i { 
            jj log --no-graph -r @ --ignore-working-copy --color always --template $template 
        } | complete)

        return ($stat.stdout | str trim)
    }

    # B. TRY GIT
    let git_check = (do -i { git rev-parse --is-inside-work-tree } | complete)

    if $git_check.exit_code == 0 {
        let branch = (do -i { git branch --show-current } | complete).stdout | str trim
        return $"(ansi magenta)git:($branch)(ansi reset)"
    }

    return ""
}

# --- 3. Left Prompt Configuration ---
$env.PROMPT_COMMAND = {||
    # Calculate relative path
    let dir = (
        if ($env.PWD | str starts-with $nu.home-path) {
            $env.PWD | path relative-to $nu.home-path
        } else {
            $env.PWD
        }
    )
    
    let env_stat = (get_env_status)
    let vcs_stat = (get_vcs_status)
    
    # Path (Cyan) + Env (Yellow) + VCS (Magenta/Green)
    $"\n(ansi cyan)($dir) ($env_stat)($vcs_stat)\n(ansi green)❯ (ansi reset)"
}

# --- 4. Right Prompt Configuration ---
$env.PROMPT_COMMAND_RIGHT = {||
    # Date Format: YYYY-MM-DD
    let date_str = (date now | format date "%Y-%m-%d")
    
    if $env.LAST_EXIT_CODE != 0 {
        $"(ansi red)exit:($env.LAST_EXIT_CODE) (ansi dark_gray)($date_str)(ansi reset)"
    } else {
        $"(ansi dark_gray)($date_str)(ansi reset)"
    }
}
