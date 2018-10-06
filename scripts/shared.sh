set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

get_tmux_option() {
	local option=$1
	local default_value=$2
	local force_icon=$3
	if [[ $force_icon == "force" ]]; then
		local option_value=$(tmux show-option -gqv "$option")
		if [[ $option_value != $default_value ]]; then
			set_tmux_option "$option" "$default_value"
			# set_tmux_option "$option" "xx"
		fi
	fi
	local option_value=$(tmux show-option -gqv "$option")
	if [[ $force_icon == "custom" ]]; then
		echo "$default_value"
	elif [[ $force_icon == "force" ]]; then
		echo "$option_value"
	elif [[ $option_value != "" ]]; then
		echo "$option_value"
	else
		echo "$default_value"
		# echo "$option_value"
	fi
}

