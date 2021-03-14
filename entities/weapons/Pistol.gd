"""Pistol.gd"""
extends Weapon

func _ready():
	if equiped:
		if raycast:
			raycast.cast_to.z = -ray_cast_range
		else:
			print(self, " missing raycast")

func do_fire():
	if can_fire:
		can_fire = false 
		timer.start(rate)
		if fire_type == FIRE_TYPE.RAYCAST:
			if raycast.is_colliding():
				var collider = raycast.get_collider()
				if collider.is_in_group(target_group):
					collider.do_damage(damage, holder)
		anime.play("Fire", -1, fire_anime_speed)
		emit_signal("fired")

func _on_Rate_timeout():
	if can_shoot_mode == CAN_SHOOT.FIRE_RATE:
		can_fire = true

func _on_Anime_animation_finished(anim_name):
	if anim_name == "Fire":
		if can_shoot_mode == CAN_SHOOT.ANIME_END:
			can_fire = true

func _on_Pistol_tree_entered():
	var par = get_parent()
	if par:
		if par.is_in_group("hand"):
			par.current_weapon = self
