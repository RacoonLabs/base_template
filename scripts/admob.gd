extends Node

signal banner_load_error(message: String)
signal interstitial_load_error(message: String)
signal interstitial_finished
signal rewarded_load_error(message: String)
signal rewarded_ad_loaded
signal rewarded_interstitial_load_error(message: String)
signal rewarded_finished(amount: int, type: String)

# ads unit id samples
# TODO - Research how to replace it by environment
# PROD IDs
# var ADD_UNIT_IDS = {
# 	"banner_unit_id": "ca-app-pub-5285980704820708/4625849529",
# 	"interstitial_unit_id": "ca-app-pub-5285980704820708/5938931197",
# 	"rewarded_unit_id": "ca-app-pub-5285980704820708/2095905016"
# }

var ADD_UNIT_IDS = {
	"banner_unit_id": "ca-app-pub-3940256099942544/6300978111",
	"interstitial_unit_id": "ca-app-pub-3940256099942544/1033173712",
	"rewarded_unit_id": "ca-app-pub-3940256099942544/5224354917"
}

var banner_ad_view_bottom : AdView
var interstitial_ad : InterstitialAd
var full_screen_interstitial_content_callback : FullScreenContentCallback
var full_screen_rewarded_content_callback : FullScreenContentCallback
var rewarded_ad : RewardedAd
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()

# TODO - replace logic to support both android and iOS
func _ready() -> void:
	if OS.get_name() != "Android":
		return
	MobileAds.initialize()
	
	register_intertitial_add_listener()
	register_rewarded_add_listener()

## ----------- LOAD AD METHODS -----------
func load_banner_ad():
	if OS.get_name() != "Android":
		return
	#free memory
	if banner_ad_view_bottom:
		destroy_banner_ad_view()
	var unit_id : String
	unit_id = ADD_UNIT_IDS.banner_unit_id
	banner_ad_view_bottom = AdView.new(unit_id, AdSize.BANNER, AdPosition.Values.BOTTOM)
	# register_banner_ad_listener()
	var ad_request_top := AdRequest.new()
	banner_ad_view_bottom.load_ad(ad_request_top)
	GameAnalytcs.trackShowAdAnalytics(GameAnalytcs.AD_TYPE.Banner, ADD_UNIT_IDS["banner_unit_id"])
	
func load_interstitial_ad():
	if OS.get_name() != "Android":
		return
	if interstitial_ad:
		destroy_interstitial_ad_view()
	var unit_id: String = ADD_UNIT_IDS.interstitial_unit_id
	var interstitial_ad_load_callback := InterstitialAdLoadCallback.new()
	interstitial_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)
		emit_signal("interstitial_load_error", adError.message)

	interstitial_ad_load_callback.on_ad_loaded = func(new_interstitial_ad : InterstitialAd) -> void:
		print("interstitial ad loaded" + str(new_interstitial_ad._uid))
		interstitial_ad = new_interstitial_ad
		interstitial_ad.full_screen_content_callback = full_screen_interstitial_content_callback

	InterstitialAdLoader.new().load(unit_id, AdRequest.new(), interstitial_ad_load_callback)

func load_rewarded_ad():
	if OS.get_name() != "Android":
		return
	if rewarded_ad:
		destroy_rewarded_view()
	var unit_id: String = ADD_UNIT_IDS.rewarded_unit_id
	var rewarded_load_callback := RewardedAdLoadCallback.new()
	rewarded_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)
		emit_signal("rewarded_load_error", adError.message)

	rewarded_load_callback.on_ad_loaded = func(new_rewarded_ad : RewardedAd) -> void:
		print("Rewarded ad loaded" + str(new_rewarded_ad._uid))
		rewarded_ad = new_rewarded_ad
		rewarded_ad.full_screen_content_callback = full_screen_rewarded_content_callback
		rewarded_ad_loaded.emit()

	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_load_callback)

## -------- SHOW METHODS -----------
func show_interstitial_ad(where: String = ""):
	if interstitial_ad:
		interstitial_ad.show()
		GameAnalytcs.trackShowAdAnalytics(GameAnalytcs.AD_TYPE.Interstitial, where)

func show_rewarded_ad(where: String = ""):
	if rewarded_ad:
		rewarded_ad.show(on_user_earned_reward_listener)
		GameAnalytcs.trackShowAdAnalytics(GameAnalytcs.AD_TYPE.RewardedVideo, where)

# ----------- ADD LISSTENERS -----------
func register_banner_ad_listener() -> void:
	if OS.get_name() != "Android":
		return
	if banner_ad_view_bottom != null:
		var ad_listener := AdListener.new()

		ad_listener.on_ad_failed_to_load = func(load_ad_error : LoadAdError) -> void:
			print("_on_ad_failed_to_load: " + load_ad_error.message)
		ad_listener.on_ad_clicked = func() -> void:
			print("_on_ad_clicked")
		ad_listener.on_ad_closed = func() -> void:
			print("_on_ad_closed")
		ad_listener.on_ad_impression = func() -> void:
			print("_on_ad_impression")
		ad_listener.on_ad_loaded = func() -> void:
			print("_on_ad_loaded")
		ad_listener.on_ad_opened = func() -> void:
			print("_on_ad_opened")

		banner_ad_view_bottom.ad_listener = ad_listener
	
func register_intertitial_add_listener() -> void:
	full_screen_interstitial_content_callback = FullScreenContentCallback.new()
	full_screen_interstitial_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	full_screen_interstitial_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
		emit_signal("interstitial_finished")
	full_screen_interstitial_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("Interstitial show full screen content error: ", ad_error.message)
		emit_signal("interstitital_load_error", ad_error.message)
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_interstitial_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	full_screen_interstitial_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")

func register_rewarded_add_listener() -> void:
	full_screen_rewarded_content_callback = FullScreenContentCallback.new()
	full_screen_rewarded_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	full_screen_rewarded_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
	full_screen_rewarded_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	full_screen_rewarded_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	full_screen_rewarded_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
		emit_signal("rewarded_finished", rewarded_item.amount, rewarded_item.type)


## ----------- DESTROY METHODS -----------
func destroy_banner_ad_view() -> void:
	if banner_ad_view_bottom:
		banner_ad_view_bottom.destroy()
		banner_ad_view_bottom = null

func destroy_interstitial_ad_view() -> void:
	if interstitial_ad:
		interstitial_ad.destroy()
		interstitial_ad = null

func destroy_rewarded_view() -> void:
	if rewarded_ad:
		rewarded_ad.destroy()
		rewarded_ad = null

# TODO new ads methods implementation following the docs https://poing-studios.github.io/godot-admob-plugin/
