# ==========================================
# 1. Environment Status (Nix/Direnv)
# ==========================================
def get_env_status [] {
    let parts = []
    let parts = (if ("flake.nix" | path exists) { $parts | append "" } else { $parts })
    # let parts = (if ($env.DIRENV_DIR? | is-not-empty) { $parts | append "▼" } else { $parts })

    if ($parts | is-empty) { return "" }
    return $"(ansi grey)($parts | str join ' ')(ansi reset) "
}

# ==========================================
# 2. Jujutsu Status Function
# ==========================================
def get_jj_status [] {
    # Check if we are in a JJ repo; capture error to silence it
    let jj_check = (do -i { jj root } | complete)

    # If exit code is not 0, we aren't in a jj repo
    if $jj_check.exit_code != 0 {
        return ""
    }

    # JJ Template:
    # \x1b[35m   = Magenta (ID/Bookmarks)
    # \x1b[32m   = Green (Description)
    # \x1b[1;31m = Bold Red (Conflict)
    # \x1b[1;33m = Bold Yellow (Divergent)
    # \x1b[90m   = Dark Gray (Immutable/Hidden)
    # \x1b[0m    = Reset
    let template = '
    raw_escape_sequence("\x1b[35m") ++
    "jj: " ++ change_id.shortest(4) ++ 
    if(bookmarks, " [" ++ bookmarks.join(", ") ++ "]") ++ 
    raw_escape_sequence("\x1b[0m") ++ 
    
    if(conflict,  raw_escape_sequence("\x1b[1;31m") ++ " ×"  ++ raw_escape_sequence("\x1b[0m"), "") ++
    if(divergent, raw_escape_sequence("\x1b[1;33m") ++ " ≠" ++ raw_escape_sequence("\x1b[0m"), "") ++
    if(hidden,    raw_escape_sequence("\x1b[90m")   ++ " ø"   ++ raw_escape_sequence("\x1b[0m"), "") ++
    if(immutable, raw_escape_sequence("\x1b[90m")   ++ " ∞"   ++ raw_escape_sequence("\x1b[0m"), "") ++

    " | " ++

    if(empty, "∅ ", "") ++
    raw_escape_sequence("\x1b[32m") ++ 
    coalesce(description.first_line().substr(0, 30), "(no description)") ++ 
    raw_escape_sequence("\x1b[0m")
    '

    let stat = (do -i { 
        jj log --no-graph -r @ --ignore-working-copy --color always --template $template 
    } | complete).stdout | str trim

    return $"(ansi reset)($stat)"
}

# ==========================================
# 3. Git Status Function
# ==========================================
def get_git_status [] {
    # Check if inside git work tree
    let git_check = (do -i { git rev-parse --is-inside-work-tree } | complete)

    if $git_check.exit_code != 0 {
        return ""
    }

    # 1. Get Branch Name
    let branch = (do -i { git branch --show-current } | complete).stdout | str trim
    
    # 2. Get Status (Simple Dirty Check)
    # If porcelain output is empty, it's clean.
    let stat_raw = (do -i { git status --porcelain } | complete).stdout
    
    let status_fmt = if ($stat_raw | is-empty) {
        "" # Clean
    } else {
        $"(ansi red)[!](ansi reset)" # Dirty
    }

    # Format: "on  main [!]"
    return $"(ansi reset)on (ansi magenta) ($branch) ($status_fmt)"
}

# ==========================================
# 4. Main VCS Controller
# ==========================================
def get_vcs_status [] {
    # Priority 1: Check JJ
    let jj = (get_jj_status)
    if ($jj | is-not-empty) {
        return $jj
    }

    # Priority 2: Check Git (Fallback)
    let git = (get_git_status)
    if ($git | is-not-empty) {
        return $git
    }

    # Neither
    return ""
}

# ==========================================
# 5. Prompt Configuration
# ==========================================

# Left Prompt
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
    
    # Structure: 
    # [Newline]
    # [Cyan Path] [Yellow Env] [VCS Status]
    # [Green Arrow]
    $"\n(ansi cyan)($dir) ($env_stat)($vcs_stat)\n(ansi green)❯ (ansi reset)"
}

# Right Prompt
$env.PROMPT_COMMAND_RIGHT = {||
    let date_str = (date now | format date "%Y-%m-%d")
    if $env.LAST_EXIT_CODE != 0 {
        $"(ansi red)exit:($env.LAST_EXIT_CODE) (ansi dark_gray)($date_str)(ansi reset)"
    } else {
        $"(ansi dark_gray)($date_str)(ansi reset)"
    }
}
