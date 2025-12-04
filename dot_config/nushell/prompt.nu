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
    let jj_check = (do -i { jj root } | complete)

    if $jj_check.exit_code != 0 {
        return ""
    }

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
    coalesce(description.first_line().substr(0, 30), "(no description)") ++ 
    raw_escape_sequence("\x1b[0m")
    '

    let stat = (do -i { 
        jj log --no-graph -r @ --ignore-working-copy --color always --template $template 
    } | complete).stdout | str trim

    return $"(ansi reset)on (ansi magenta) (ansi reset)($stat)"
}

# ==========================================
# 3. Git Status Function
# ==========================================
def get_git_status [] {
    let git_check = (do -i { git rev-parse --is-inside-work-tree } | complete)

    if $git_check.exit_code != 0 {
        return ""
    }

    let branch = (do -i { git branch --show-current } | complete).stdout | str trim
    let stat_raw = (do -i { git status --porcelain } | complete).stdout
    let status_fmt = if ($stat_raw | is-empty) { "" } else { $"(ansi red)[!](ansi reset)" }

    return $"(ansi reset)on (ansi magenta) ($branch) ($status_fmt)"
}

# ==========================================
# 4. Main VCS Controller
# ==========================================
def get_vcs_status [] {
    let jj = (get_jj_status)
    if ($jj | is-not-empty) { return $jj }

    let git = (get_git_status)
    if ($git | is-not-empty) { return $git }

    return ""
}

# ==========================================
# 5. Prompt Configuration
# ==========================================
$env.PROMPT_COMMAND = {||
    let env_stat = (get_env_status)
    let vcs_stat = (get_vcs_status)
    
    # --- PATH LOGIC ---
    let dir = if ($vcs_stat | is-not-empty) {
        # CASE A: We are in a Repo (Git or JJ)
        # Show only the current folder name (basename)
        let base = ($env.PWD | path basename)
        if ($base | is-empty) { "/" } else { $base }
    } else {
        # CASE B: We are NOT in a Repo
        # Show full path relative to home (standard)
        if ($env.PWD | str starts-with $nu.home-path) {
            $env.PWD | path relative-to $nu.home-path
        } else {
            $env.PWD
        }
    }

    # Output:
    # [Cyan Path] [Yellow Env] [VCS Status]
    $"\n(ansi cyan)($dir) ($env_stat)($vcs_stat)\n(ansi green)❯ (ansi reset)"
}

$env.PROMPT_COMMAND_RIGHT = {||
    let date_str = (date now | format date "%Y-%m-%d")
    if $env.LAST_EXIT_CODE != 0 {
        $"(ansi red)exit:($env.LAST_EXIT_CODE) (ansi dark_gray)($date_str)(ansi reset)"
    } else {
        $"(ansi dark_gray)($date_str)(ansi reset)"
    }
}
