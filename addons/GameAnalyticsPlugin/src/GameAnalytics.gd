class_name GameAnalytcs
extends Node

# This enums are used to match with the exposed by the SDK
enum PROGRESSION_STATUS_TYPE {
	Undefined,
	Start,
	Complete,
	Fail
}

# This enums are used to match with the exposed by the SDK
enum AD_TYPE {
	Undefined = 0,
	RewardedVideo = 2,
	Interstitial = 4,
	Banner = 6
}

# This enums are used to match with the exposed by the SDK. Source is an add and sink is a substract
enum RESOURCE_TYPE {
	SOURCE = 0,
	SINK = 1
}

static func _get_plugin() -> Object:
	if (Engine.has_singleton("GameAnalyticsPlugin")):
		return Engine.get_singleton("GameAnalyticsPlugin")
	if OS.get_name() == "Android":
		printerr("GameAnalyticsPlugin" + " not found, make sure you marked 'GameAnalyticsPlugin' plugin on export tab")
	return null

static func initialize(key: String, secret: String) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.initialize(key, secret)

static func trackShowAdAnalytics(type: AD_TYPE, where: String) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.trackShowAdAnalytics(type, where)

static func trackAdRewardReceivedAnalytics(where: String) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.trackAdRewardReceivedAnalytics(where)

static func trackShowAdErrorAnalytics(type: AD_TYPE, where: String) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.trackShowAdErrorAnalytics(type, where)

static func trackProgressionAnalytics(status: PROGRESSION_STATUS_TYPE, mode: String, level: int, globalLevel: int) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.trackProgressionAnalytics(status, mode, level, globalLevel)


static func addResourceEvent(source: RESOURCE_TYPE, currency: String, amount: float, itemType: String, itemId: String) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.addResourceEvent(source, currency, amount, itemType, itemId)

static func addEvent(eventId: String) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.addEvent(eventId)
		
static func addEventValue(eventId: String, eventValue: float) -> void:
	var plugin = GameAnalytcs._get_plugin()
	if !plugin:
		return
	else:
		plugin.addEventValue(eventId, eventValue)
