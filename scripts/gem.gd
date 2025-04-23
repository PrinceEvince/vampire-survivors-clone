extends Area2D

@onready var gem_pickup_sfx = $AudioStreamPlayer2D

func _ready():
	%AnimationPlayer.play("idle")

func _on_body_entered(body: Node2D) -> void:
	if body == GlobalData.player:
		pickup()

func pickup():
	UserData.gems += 1
	gem_pickup_sfx.play()
	$Sprite2D.hide()
	$Timer.start()

func _on_timer_timeout() -> void:
	queue_free()
