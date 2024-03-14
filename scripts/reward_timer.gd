extends Node

signal timer_expired
signal timer_start
const ONE_DAY_SEC = 86400

func start_timer():
	timer_start.emit()

func format_time_left_hms(time_left: int):
	var hours = floor(time_left / 3600)
	var minutes = int(time_left / 60) % 60
	var seconds = int(time_left) % 60
	return [hours, minutes, seconds]

func get_next_reward_time_left():
	# { "year": 2024, "month": 2, "day": 9, "weekday": 5, "hour": 23, "minute": 42, "second": 3, "dst": false }
	if Hint.get_reward_redeemed_date() != null:
		var reward_redeemed_datetime = Time.get_unix_time_from_datetime_dict(Hint.reward_redeemed_date)
		var current_datetime = Time.get_unix_time_from_datetime_dict(Time.get_datetime_dict_from_system(false))
		var dates_seconds_diff = current_datetime - reward_redeemed_datetime
		var time_left = ONE_DAY_SEC - dates_seconds_diff
		if time_left > 0:
			return format_time_left_hms(time_left)
		else:
			Hint.set_reward_redeemed(false)
			timer_expired.emit()
			return [0, 0, 0]
	else:
		Hint.set_reward_redeemed(false)
		return [0, 0, 0]
