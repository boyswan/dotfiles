# ==========================================
# 1. Jujutsu Logic
# ==========================================
def get_jj_info [] {
    # Check if in JJ repo and get Root Path immediately
    let root_check = (do -i { jj root } | complete)

    if $root_check.exit_code != 0 {
        return null
    }

    let root_path = ($root_check.stdout | str trim)

    # JJ Template
    let template = '
    raw_escape_sequence("\x1b[35m") ++
    " " ++ change_id.shortest(4) ++ 
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

    # Return structured data: Root Path + Formatted String
    return { 
        root: $root_path, 
        display: $"(ansi reset)($stat)" 
    }
}

# ==========================================
# 2. Git Logic
# ==========================================
def get_git_info [] {
    # Check if in Git repo and get Root Path immediately
    let root_check = (do -i { git rev-parse --show-toplevel } | complete)

    if $root_check.exit_code != 0 {
        return null
    }

    let root_path = ($root_check.stdout | str trim)

    let branch = (do -i { git branch --show-current } | complete).stdout | str trim
    let stat_raw = (do -i { git status --porcelain } | complete).stdout
    let status_fmt = if ($stat_raw | is-empty) { "" } else { $"(ansi red)[!](ansi reset)" }

    # Return structured data
    return { 
        root: $root_path, 
        display: $"(ansi reset)on (ansi magenta) ($branch) ($status_fmt)" 
    }
}

# ==========================================
# 3. Main Prompt Command
# ==========================================
$env.PROMPT_COMMAND = {||
    # 1. Attempt to get VCS Info (returns Record or Null)
    # We check JJ first. If null, check Git.
    let vcs_info = (get_jj_info)
    let vcs_info = if ($vcs_info == null) { (get_git_info) } else { $vcs_info }
    
    # 2. Path Calculation
    let dir = if ($vcs_info != null) {
        # --- CASE A: Inside a Repo ---
        # We have the authoritative root path from the vcs_info record.
        let root = $vcs_info.root
        let root_name = ($root | path basename)
        
        # Calculate relative path
        let relative = ($env.PWD | path relative-to $root | str trim)
        
        # If relative is "." or empty, we are at the root -> Show "RepoName"
        # Else -> Show "RepoName/subdir"
        if ($relative == ".") or ($relative | is-empty) {
            $root_name
        } else {
            $"($root_name)/($relative)"
        }
    } else {
        # --- CASE B: Not in a Repo ---
        # Standard home-relative path
        if ($env.PWD | str starts-with $nu.home-path) {
            $env.PWD | path relative-to $nu.home-path
        } else {
            $env.PWD
        }
    }

    # 3. Formatting
    # If vcs_info is null, display empty string, otherwise display the text
    let vcs_display = if ($vcs_info != null) { $vcs_info.display } else { "" }

    # Output
    $"\n(ansi cyan)($dir) ($vcs_display)\n(ansi green)❯ (ansi reset)"
}

$env.PROMPT_COMMAND_RIGHT = {||
    let date_str = (date now | format date "%Y-%m-%d")
    if $env.LAST_EXIT_CODE != 0 {
        $"(ansi red)exit:($env.LAST_EXIT_CODE) (ansi dark_gray)($date_str)(ansi reset)"
    } else {
        $"(ansi dark_gray)($date_str)(ansi reset)"
    }
}
