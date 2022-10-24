extends Level

var SentryGunsKilled = 0

func _on_SentryGun_died():
	SentryGunsKilled += 1

func _on_SentryGun2_died():
	SentryGunsKilled += 1

func _on_SentryGun3_died():
	SentryGunsKilled += 1

func _on_AmmoM17_tree_exited():
	ref.level.secret_area = true
