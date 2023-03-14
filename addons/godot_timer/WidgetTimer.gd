tool
extends Control


var current_session_time := 0.0
var total_project_launch := 0
var total_project_time := 0.0



var out_of_focus := false
var statistics := {}
const DELAY_OUT_OF_FOCUS_BEFORE_PAUSING := 300.0
var c_delay := 0.0

var paused := false
onready var ChartBar := preload("res://addons/godot_timer/prefabs/ChartBar.tscn")
const SAVE_FILEPATH := "res://addons/godot_timer/save.sav"

func fill_statistics() -> void:
	statistics = {}
	for y in range(2020, 2025):
		statistics[y] = {}
		for m in range(0, 12):
			statistics[y][m] = {}
			for d in range(0, 30):
				statistics[y][m][d] = {
					"time": rand_range(0, 24*3600)
				}

func _enter_tree() -> void:
#	fill_statistics()
	load_data()
	$AutosaveTimer.connect("timeout", self, "_autosave_timer_timeout")
	$TickTimer.connect("timeout", self, "_tick_timer_timeout")
	
	
	# Update version in the main popup
	var config := ConfigFile.new()
	var err = config.load("res://addons/godot_timer/plugin.cfg")
	
	if err != OK:
		return
	$MainPopup/Version/Text.text = str("version ", config.get_value("plugin", "version"))





func format_time(t_seconds, dots = false) -> String:
	var seconds:float = fmod(t_seconds , 60.0)
	var minutes:int   =  int(t_seconds / 60.0) % 60
	var hours:  int   =  int(t_seconds / 3600.0)
	if dots:
		return "%02d:%02d:%02d" % [hours, minutes, seconds]	
	return "%02dh %02dm %02ds" % [hours, minutes, seconds]


func _notification(what):
	match what:
		NOTIFICATION_WM_FOCUS_OUT:
			out_of_focus = true
			c_delay = DELAY_OUT_OF_FOCUS_BEFORE_PAUSING
		NOTIFICATION_WM_FOCUS_IN:
			out_of_focus = false
			paused = false


func load_data() -> void:
	var file = File.new()
	if not file.file_exists(SAVE_FILEPATH):
		return
	file.open(SAVE_FILEPATH, File.READ)
	print("Loading timer data...")
	var _data = file.get_var()
	total_project_time = _data.get("total_project_time")
	statistics = _data.get("statistics")
	
func _autosave_timer_timeout() -> void:
	save_data()
	
func _exit_tree() -> void:
	save_data()


func save_data() -> void:
	var data := {
		"total_project_time": total_project_time,
		"statistics": statistics
	}
	
	print(data)
	var file := File.new()
	var err = file.open(SAVE_FILEPATH, File.WRITE)
	if err:
		printerr(err)
		return
	file.store_var(data)
	file.close()


func _on_StatsButton_pressed() -> void:
	$Stats.popup()


func _on_TimerButton_pressed() -> void:
	$MainPopup.popup_centered()
	$MainPopup/Container/CurrentSessionTime.text = str("Current session time:", format_time(current_session_time))
	$MainPopup/Container/TotalProjectTime.text = str("Total project time:", format_time(total_project_time))




func _on_StatisticsButton_pressed() -> void:
	$MainPopup.visible = false
	
	var _date := Time.get_date_dict_from_system()
	
	$Statistics.window_title = str("Statistics of ", _date.month, "/", _date.year)
	$Statistics.popup_centered()
	var _maximum := 0.0
	var data : Dictionary = statistics.get(_date.year).get(_date.month)
	for i in data.keys():
		if data.get(i).time > _maximum:
			_maximum = data.get(i).time
	
	var _maximum_scale = _maximum / 3600.0
	$"Statistics/Scale/0".text = str(ceil(_maximum_scale), "h")
	$"Statistics/Scale/1".text = str(ceil(_maximum_scale * 0.75), "h")
	$"Statistics/Scale/2".text = str(ceil(_maximum_scale * 0.5), "h")
	$"Statistics/Scale/3".text = str(ceil(_maximum_scale * 0.25), "h")
	$"Statistics/Scale/4".text = str(ceil(_maximum_scale * 0), "h")
	
	for i in $Statistics/Scroll/Container.get_children():
		i.queue_free()
	
	for i in data.keys():
		var chart_bar := ChartBar.instance()
		var _time_day := format_time(data[i].time, true)
		chart_bar.get_node("Date").text = str(i, "/", _date.month, "/", str(_date.year).substr(2), "\n", _time_day)
		var _value = (data[i].time / _maximum) * 184.0
		chart_bar.get_node("Bar").rect_size.y = _value
		chart_bar.get_node("Bar").rect_position.y = 184.0 - _value
		$Statistics/Scroll/Container.add_child(chart_bar)

func _on_SettingsButton_pressed() -> void:
	pass # Replace with function body.

func _tick_timer_timeout() -> void:
	if out_of_focus && !paused:
		c_delay -= 1
		if c_delay <= 0:
			paused = true
	$Container/TotalTime/Pause.visible = paused

	if !paused:
		current_session_time += 1
		total_project_time += 1
		$Container/TotalTime/TimerButton.text = format_time(current_session_time)

		var _date = Time.get_date_dict_from_system()
		if !statistics.get(_date.year) || !statistics[_date.year].get(_date.month) || !statistics[_date.year][_date.month].get(_date.day):
			statistics[_date.year] = {}
			statistics[_date.year][_date.month] = {}
			statistics[_date.year][_date.month][_date.day] = {
				"time": 0
			}
		statistics[_date.year][_date.month][_date.day].time += 1


func _on_GithubButton_pressed() -> void:
	OS.shell_open("https://github.com/Yoshiip/GodotActivity")
