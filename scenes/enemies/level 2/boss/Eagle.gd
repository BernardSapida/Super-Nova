extends BossBase

var target_position
var locked_on: bool = false
var ready_attack: bool = false
var velocity: Vector2

onready var lock_on_timer = $LockOnTimer
onready var attack_timer = $AttackTimer
onready var return_timer = $ReturnTimer
onready var eagle = $"."

func _ready():
	animated_sprite.play("default")
	
func _physics_process(delta):
	if not active:
		return
	
	velocity = Vector2.ZERO
	
	if not locked_on:
		target_position = (player_ref.global_position - global_position).normalized()
		
	if ready_attack:
		velocity = target_position * speed
		
	move_and_slide(velocity)
	
func activate():
	animation_player.play("entrance")
	yield(animation_player, "animation_finished")
	active = true
	lock_on_timer.start()
		
		
func die():
	if dying:
		return
		
	dying = true
	
	set_physics_process(false)
	
	var explosion = death_explosion.instance()

	explosion.global_position = global_position
	get_tree().current_scene.add_child(explosion)
	
	
	animated_sprite.play("default")
	animated_sprite.stop()
	animated_sprite.frame = 0
	attack_timer.stop()
	lock_on_timer.stop()
	return_timer.stop()
	SoundManager.play_clip(sound_player, SoundManager.SOUND_DEAD)
	animation_player.play("die")
	LevelManager.add_current_points(points)

		
		
func return_to_position():
	var tween = get_tree().create_tween()
	if facing == FACING.RIGHT:
		tween.tween_property(eagle, "position", Vector2(360, 0), 1.0 )
		flip_me()
	elif facing == FACING.LEFT:
		tween.tween_property(eagle, "position", Vector2(-360, 0), 1.0 )
		flip_me()
	tween.connect("finished", self, "lock_on_player")


func flip_me():
	animated_sprite.flip_h = !animated_sprite.flip_h
	
	if facing == FACING.LEFT:
		facing = FACING.RIGHT
	else:
		facing = FACING.LEFT
		
		
func lock_on_player():
	locked_on = false
	lock_on_timer.start()
	animated_sprite.speed_scale = 1

func _on_LockOnTimer_timeout():
	locked_on = true
	attack_timer.start()
	animated_sprite.stop()
	animated_sprite.frame = 0
	
func _on_AttackTimer_timeout():
	ready_attack = true
	animated_sprite.play("default")
	animated_sprite.speed_scale = 2

func _on_ReturnTimer_timeout():
	ready_attack = false
	return_to_position()


func _on_VisibilityNotifier2D_screen_exited():
	return_timer.start()

