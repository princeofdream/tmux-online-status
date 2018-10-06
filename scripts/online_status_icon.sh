#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

online_option_string="@online_icon"
offline_option_string="@offline_icon"
ping_timeout_string="@ping_timeout"
route_to_ping_string="@route_to_ping"

online_prefix="#[fg=colour076]"
online_end="#[default]"

offline_prefix="#[fg=colour160]"
offline_end="#[default]"


online_icon_osx="✅ "
online_icon="✔"
# online_icon="OK"
offline_icon_osx="❌"
# offline_icon_osx="⛔️"
offline_icon_cygwin="X"
# offline_icon="❌"
offline_icon="✖"
ping_timeout_default="3"
route_to_ping_default="www.qq.com"

source $CURRENT_DIR/shared.sh

is_osx() {
	[ $(uname) == "Darwin" ]
}

is_cygwin() {
	[[ $(uname) =~ CYGWIN ]]
}

is_freebsd() {
	[ $(uname) == FreeBSD ]
}

online_icon_default() {
	if is_osx; then
		printf "$online_icon_osx"
	else
		printf "$online_icon"
	fi
}

offline_icon_default() {
	if is_osx; then
		printf "$offline_icon_osx"
	elif is_cygwin; then
		printf "$offline_icon_cygwin"
	else
		printf "$offline_icon"
	fi
}

online_status() {
	if is_osx || is_freebsd; then
		local timeout_flag="-t"
	else
		local timeout_flag="-w"
	fi
	if is_cygwin; then
		local number_pings_flag="-n"
	else
		local number_pings_flag="-c"
	fi
	local ping_timeout="$(get_tmux_option "$ping_timeout_string" "$ping_timeout_default")"
	# echo local ping_route=\"\$\(get_tmux_option \"$route_to_ping_string\" \"$route_to_ping_default\"\)\"
	local ping_route="$(get_tmux_option "$route_to_ping_string" "$route_to_ping_default")"
	ping "$number_pings_flag" 1 "$timeout_flag" "$ping_timeout" "$ping_route" >/dev/null 2>&1
}

print_icon() {
	if $(online_status); then
		# printf "$(get_tmux_option "$online_option_string" "${online_prefix}$(online_icon_default)${online_end}" "force" )"
		GET_ICON=`online_icon_default`
		ICON_WITH_COLOR="${online_prefix}"${GET_ICON}"${online_end}"
		ONLINE_STAT=`get_tmux_option "$online_option_string" "$ICON_WITH_COLOR" "force" `
		printf "$ONLINE_STAT"
	else
		GET_ICON=`offline_icon_default`
		ICON_WITH_COLOR="${offline_prefix}"${GET_ICON}"${offline_end}"
		ONLINE_STAT=`get_tmux_option "$offline_option_string" "$ICON_WITH_COLOR" "force" `
		printf "$ONLINE_STAT"
	fi
}

main() {
	print_icon
}
main
