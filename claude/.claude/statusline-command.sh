#!/bin/sh
input=$(cat)
model=$(echo "$input" | jq -r '.model.display_name // "Unknown"')
ctx=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
s_pct=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
s_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
w_pct=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
w_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

ESC=$(printf '\033')
CYAN="${ESC}[0;36m"
GREEN="${ESC}[0;32m"
YELLOW="${ESC}[0;33m"
RED="${ESC}[0;31m"
RESET="${ESC}[0m"

# Threshold color for a 0-100 quota percentage
qcolor() {
  awk -v v="$1" -v g="$GREEN" -v y="$YELLOW" -v r="$RED" \
    'BEGIN{ if (v>=90) printf "%s", r; else if (v>=70) printf "%s", y; else printf "%s", g }'
}

# Round a percentage to an integer
pct() {
  awk -v v="$1" 'BEGIN{ printf "%.0f", v }'
}

# Format a Unix epoch (seconds) with a date/strftime pattern
at() {
  awk -v v="$1" 'BEGIN{ printf "%d", v }' | xargs -I{} date -r {} "$2" 2>/dev/null
}

out="${CYAN}${model}${RESET}"

# Context window usage (percentage only)
if [ -n "$ctx" ]; then
  out="${out} | C $(pct "$ctx")%"
fi

# Subscription session (5-hour) quota + reset time (24H)
if [ -n "$s_pct" ]; then
  seg=" | $(qcolor "$s_pct")S $(pct "$s_pct")%"
  if [ -n "$s_reset" ]; then
    t=$(at "$s_reset" +%H:%M)
    [ -n "$t" ] && seg="${seg} (→${t})"
  fi
  out="${out}${seg}${RESET}"
fi

# Weekly (7-day) quota + reset time (date + 24H)
if [ -n "$w_pct" ]; then
  seg=" | $(qcolor "$w_pct")W $(pct "$w_pct")%"
  if [ -n "$w_reset" ]; then
    t=$(at "$w_reset" "+%m/%d %H:%M")
    [ -n "$t" ] && seg="${seg} (→${t})"
  fi
  out="${out}${seg}${RESET}"
fi

printf "%s" "$out"

# ===== Line 2: Git =====
MAGENTA="${ESC}[0;35m"
dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
if [ -n "$dir" ] && git -C "$dir" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  # Branch name (or short hash when detached)
  branch=$(git -C "$dir" symbolic-ref --quiet --short HEAD 2>/dev/null)
  if [ -n "$branch" ]; then
    gline=" ${MAGENTA}${branch}${RESET}"
  else
    gline=" ${YELLOW}detached:$(git -C "$dir" rev-parse --short HEAD 2>/dev/null)${RESET}"
  fi

  # Ahead / behind vs upstream (left=behind, right=ahead)
  counts=$(git -C "$dir" rev-list --left-right --count '@{upstream}...HEAD' 2>/dev/null)
  if [ -n "$counts" ]; then
    behind=$(echo "$counts" | awk '{print $1+0}')
    ahead=$(echo "$counts" | awk '{print $2+0}')
    [ "$ahead" -gt 0 ] && gline="${gline} ${GREEN}↑${ahead}${RESET}"
    [ "$behind" -gt 0 ] && gline="${gline} ${YELLOW}↓${behind}${RESET}"
  fi

  # Worktree info
  git_dir=$(git -C "$dir" rev-parse --git-dir 2>/dev/null)
  case "$git_dir" in
    *"/worktrees/"*)
      # Inside a linked worktree: highlight its name so it's not mistaken for main
      gline="${gline} ${CYAN}@$(basename "$git_dir")${RESET}" ;;
  esac
  wt_count=$(git -C "$dir" worktree list 2>/dev/null | grep -c '^')
  [ "$wt_count" -gt 1 ] && gline="${gline} ${CYAN}wt ${wt_count}${RESET}"

  printf "\n%s" "$gline"
fi
