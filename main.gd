extends Node

const Settings = preload("res://settings.gd")

@onready var _main_menu = $MainMenu
@onready var _settings_ui = $SettingsUI
@onready var _credits_ui = $CreditsUI

var _settings = Settings.new()
var _game


func _ready():
	_settings_ui.set_settings(_settings)
	if Engine.is_editor_hint():
		_settings.world_save_folder = "res://debug_data/"
	else:
		_settings.world_save_folder = "user://"


func _on_MainMenu_start_requested():
	assert(_game == null)
	_main_menu.hide()
	var game_scene : PackedScene = load("res://game.tscn")
	_game = game_scene.instantiate()
	_game.set_settings(_settings)
	_game.set_settings_ui(_settings_ui)
	_game.exit_to_menu_requested.connect(_on_game_exit_to_menu_requested)
	add_child(_game)


func _on_MainMenu_settings_requested():
	_settings_ui.show()


func _on_MainMenu_credits_requested():
	_credits_ui.show()


func _on_MainMenu_exit_requested():
	get_tree().quit()


func _on_game_exit_to_menu_requested():
	_game.queue_free()
	_game = null
	_main_menu.show()


func _process(delta):
	AudioServer.set_bus_volume_db(0, linear_to_db(_settings.main_volume_linear))
	DDD.visible = _settings.debug_text
	var viewport = get_viewport()
	if _settings.wireframe != (viewport.debug_draw == Viewport.DEBUG_DRAW_WIREFRAME):
		if _settings.wireframe:
			viewport.debug_draw = Viewport.DEBUG_DRAW_WIREFRAME
		else:
			viewport.debug_draw = Viewport.DEBUG_DRAW_DISABLED
		print("Setting viewport draw mode to ", viewport.debug_draw)


func _unhandled_input(event):
	if _game != null:
		# Let the game handle it
		return
	if event is InputEventKey:
		if event.pressed and not event.is_echo():
			if event.keycode == KEY_ESCAPE:
				if _settings_ui.visible:
					_settings_ui.hide()
				if _credits_ui.visible:
					_credits_ui.hide()

