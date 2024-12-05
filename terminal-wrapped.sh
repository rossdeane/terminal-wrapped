#!/bin/bash

# File path to the zsh history
HISTORY_FILE="$HOME/.zsh_history"

# Check if the file exists
if [[ ! -f "$HISTORY_FILE" ]]; then
    echo -e "🚨 \e[31mError: File '$HISTORY_FILE' not found.\e[0m 🚨"
    echo -e "👎 Use ZSH next year, loser! 👎"
    exit 1
fi

# Define colors
RED="\e[31m"
GREEN="\e[32m"
BLUE="\e[34m"
CYAN="\e[36m"
MAGENTA="\e[35m"
YELLOW="\e[33m"
RESET="\e[0m"

# Big ASCII Title
echo -e "${CYAN}"
echo "  ______    ___  ____   ___ ___  ____  ____    ____  _          __    __  ____    ____  ____  ____   ___  ___   "
echo " |      |  /  _]|    \ |   |   ||    ||    \  /    || |        |  |__|  ||    \  /    ||    \|    \ /  _]|   \\  "
echo " |      | /  [_ |  D  )| _   _ | |  | |  _  ||  o  || |        |  |  |  ||  D  )|  o  ||  o  )  o  )  [_ |    \\ "
echo " |_|  |_||    _]|    / |  \_/  | |  | |  |  ||     || |___     |  |  |  ||    / |     ||   _/|   _/    _]|  D  | "
echo "   |  |  |   [_ |    \ |   |   | |  | |  |  ||  _  ||     |    |  '  '  ||    \ |  _  ||  |  |  | |   [_ |     | "
echo "   |  |  |     ||  .  \|   |   | |  | |  |  ||  |  ||     |     \      / |  .  \|  |  ||  |  |  | |     ||     | "
echo "   |__|  |_____||__|\_||___|___||____||__|__||__|__||_____|      \_/\_/  |__|\_||__|__||__|  |__| |_____||_____| "
echo "                                                                                                                 "
echo ""
echo -e "🎉 ${MAGENTA}TERMINAL WRAPPED 2024${RESET} 🎉"

echo -e "\n${YELLOW}🌟 Your terminal habits, revealed! 🌟${RESET}"

# Function to display results in a two-column table format
display_table() {
    local title="$1"
    local data="$2"

    echo -e "\n💾 ${BLUE}$title${RESET}"
    echo -e "${GREEN}Count${RESET}       ${GREEN}Command${RESET}"
    echo -e "$data" | awk '{printf "%-12s%s\n", $1, substr($0, index($0,$2))}'
}

# Filter history file by year 2024
filtered_history=$(awk -F';' '$1 ~ /^: [0-9]+/ {timestamp=substr($1, 3); if (timestamp >= 1704067200) print $0}' "$HISTORY_FILE")

# Extract and format top commands (first word only)
top_commands=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd && $2 !~ /^sudo[ \t]/) print cmd}' |
    awk '{print $1}' | sort | uniq -c | sort -rn | head -n 5)

display_table "Most Played Hits (Top Commands)" "$top_commands"

top_invocations=$(awk -F';' '{cmd=substr($0, index($0, $2)); sub(/^[ \t]+/, "", cmd); print cmd}' "$HISTORY_FILE" |
    sort | uniq -c | sort -rn | head -n 5)

display_table "Full Tracks (Top Full Command Invocations)" "$top_invocations"

echo -e "\n${BLUE}With great power comes great responsibility ${RESET}"

# Count how many times 'sudo' was used
sudo_count=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd ~ /^sudo[ \t]/) print cmd}' | wc -l)

echo -e "🛡️ ${RED}Sudo: Your Most Trusted Sidekick:${RESET} $sudo_count"

# Count how many times 'sl' was used by mistake
sl_count=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd == "sl" || cmd ~ /^sl[ \t]/) print cmd}' | wc -l)

echo -e "❌ ${RED}Oops Moments (Mistaken 'sl' Usage):${RESET} $sl_count"

# Count how many times 'gti' was used by mistake
gti_count=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd == "gti" || cmd ~ /^gti[ \t]/) print cmd}' | wc -l)

echo -e "🤔 ${RED}Typo Treasures (Mistaken 'gti' Usage):${RESET} $gti_count"

# Count how many times 'dc' was used by mistake
dc_count=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd == "dc" || cmd ~ /^dc[ \t]/) print cmd}' | wc -l)

echo -e "📉 ${RED}The Forgotten Alias (Mistaken 'dc' Usage):${RESET} $dc_count"

# Find the longest command
longest_command_data=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd && cmd !~ /fbp|fbclid/) print length(cmd), cmd}' |
    sort -nr | head -n 1)
longest_command_length=$(echo "$longest_command_data" | awk '{print $1}')
longest_command_text=$(echo "$longest_command_data" | awk '{print substr($0, index($0,$2))}')
shortened_command=$(echo "$longest_command_text" | cut -c1-10)...

echo -e "\n${BLUE}Stats on Stats ${RESET}"
echo -e "🏃 ${CYAN}The Marathon Typist Award (Longest Command):${RESET} $shortened_command (${longest_command_length} chars)"

# Find the most repeated command in a row
most_repeated=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd && cmd != last) {if (count > max) {max = count; repeated = last}; count = 1} else count++; last = cmd} END {if (count > max) repeated = last; print repeated}')

echo -e "🔄 ${CYAN}Stuck in a Loop (Most Repeated Command):${RESET} $most_repeated"

# Find the shortest command
shortest_command=$(echo "$filtered_history" | awk -F';' '{cmd=$2; sub(/^[ \t]+|[ \t]+$/, "", cmd); if (cmd) print length(cmd), cmd}' |
    sort -n | head -n 1 | cut -d' ' -f2-)

echo -e "🤏 ${CYAN}Minimalist Champion (Shortest Command):${RESET} $shortest_command"

# Count commands between 9 PM and 8 AM
night_commands=$(echo "$filtered_history" | awk -F';' '{timestamp=substr($1, 3, 10); hour=strftime("%-H", timestamp)+0; if (hour >= 21 || hour < 8) print $2}' |
    wc -l)

echo -e "🌙 ${CYAN}Night Owl Commands (Executed 9 PM - 8 AM):${RESET} $night_commands"

echo -e "\n${BLUE}My first, my last, my everything ${RESET}"

first_command=$(echo "$filtered_history" | head -n 1 | awk -F';' '{
    timestamp = substr($1, 3);
    cmd = $2;
    sub(/^[ \t]+|[ \t]+$/, "", cmd);
    date_time = strftime("[%Y-%m-%d %H:%M:%S]", timestamp);  # Format with brackets
    print date_time, cmd;
}')
echo -e "🥇 ${CYAN}First Command of the Year:${RESET} $first_command"

current_time=$(date +"[%Y-%m-%d %H:%M:%S]")  # Get the current timestamp with brackets
echo -e "⏱️ ${CYAN}Last Command of the Year:${RESET}  $current_time TERMINAL WRAPPED 2024!"

# Get the total number of commands
total_commands=$(echo "$filtered_history" | wc -l)
echo -e "\n🔢 ${GREEN}Total Commands Executed:${RESET} $total_commands"

echo -e "\n🎆 ${YELLOW}Phew.. you've been busy - see you again in 2025!${RESET}"