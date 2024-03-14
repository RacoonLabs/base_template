class_name Share
extends Node

static func _get_plugin() -> Object:
	if (Engine.has_singleton("NativeShare")):
		return Engine.get_singleton("NativeShare")
	if OS.get_name() == "Android":
		printerr("NativeShare" + " not found, make sure you marked 'NativeShare' plugin on export tab")
	return null

static func share_image(path: String, title: String, text: String, subject: String) -> void:
	var plugin = Share._get_plugin()
	if !plugin:
		return
	else:
		plugin.shareImage(path, title, text, subject)
