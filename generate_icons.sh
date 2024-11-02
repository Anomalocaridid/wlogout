#!/usr/bin/env bash
# generate_icons.sh: Generate icons for catppuccin wlogout theme
# requires curl

# Sanity options for safety
set -o errtrace \
    -o errexit \
    -o nounset \
    -o xtrace \
    -o pipefail

readonly ICONS=("hibernate" "lock" "logout" "reboot" "shutdown" "suspend")
# Use text colors for each set of icons
readonly -A FLAVORS=(
    ["latte"]="#4c4f69"
    ["frappe"]="#c6d0f5"
    ["macchiato"]="#cad3f5"
    ["mocha"]="#cdd6f4"
)
# Size of final icons
readonly SIZE=1024

TMP_ICON_DIR=$(mktemp --directory)
declare -r TMP_ICON_DIR

generate_icon_set() {
    local -r name="$1"
    local -r url="$2"
    local -r recolor="$3"

    for icon in "${ICONS[@]}"; do
        # Download svg icons
        mkdir --parents "$TMP_ICON_DIR/$name"
        # shellcheck disable=SC2059
        curl "$(printf "$url" "$icon")" -o "$TMP_ICON_DIR/$name/$icon.svg"

        # Create recolored icons
        for flavor in "${!FLAVORS[@]}"; do
            mkdir --parents "icons/$name/$flavor"

            # Recolor icon
            # shellcheck disable=SC2059
            sed "$TMP_ICON_DIR/$name/$icon.svg" -e "$(printf "$recolor" "${FLAVORS[$flavor]}")" > "icons/$name/$flavor/$icon.svg"
        done
    done
}

generate_icon_set "wlogout" "https://raw.githubusercontent.com/ArtsyMacaw/wlogout/refs/heads/master/assets/%s.svg" 's/<svg/<svg fill="%s"/'
generate_icon_set "wleave" "https://raw.githubusercontent.com/AMNatty/wleave/refs/heads/development/icons/%s.svg" "s/#ebebeb/%s/g"
