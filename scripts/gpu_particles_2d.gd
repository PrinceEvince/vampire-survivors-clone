extends Node2D

@onready var particles: GPUParticles2D = $GPUParticles2D

func setup_and_emit(emit_position: Vector2, enemy_sprite: Sprite2D = null):
	if not particles:
		queue_free()
		return
	global_position = emit_position

	if enemy_sprite != null:
		if particles.process_material is ParticleProcessMaterial:
			var process_mat := particles.process_material as ParticleProcessMaterial
			process_mat.color = enemy_sprite.modulate
			print("DustEffect: Tinting particles with color: ", enemy_sprite.modulate) # Debug output

		elif particles.process_material is ShaderMaterial:
			var shader_mat := particles.process_material as ShaderMaterial
			# Check if the material, shader, and enemy texture exist
			if shader_mat and shader_mat.shader and enemy_sprite.texture:
				var enemy_tex = enemy_sprite.texture
				var tex_size = enemy_tex.get_size()

				shader_mat.set_shader_parameter("enemy_texture", enemy_tex)
				shader_mat.set_shader_parameter("texture_size", tex_size)
				shader_mat.set_shader_parameter("enemy_modulate", enemy_sprite.modulate)
	particles.restart()
	var cleanup_delay = particles.lifetime + 0.2
	await get_tree().create_timer(cleanup_delay).timeout
	queue_free()


func setup_and_emit_animated(emit_position: Vector2, enemy_sprite: AnimatedSprite2D = null):
	global_position = emit_position
	if enemy_sprite != null:
		if particles.process_material is ParticleProcessMaterial:
			var process_mat := particles.process_material as ParticleProcessMaterial
			process_mat.color = enemy_sprite.modulate

		elif particles.process_material is ShaderMaterial:
			var shader_mat := particles.process_material as ShaderMaterial
			var current_frame_texture = enemy_sprite.sprite_frames.get_frame_texture(enemy_sprite.animation, enemy_sprite.frame)
			if shader_mat and shader_mat.shader and current_frame_texture:
				shader_mat.set_shader_parameter("enemy_texture", current_frame_texture)
				shader_mat.set_shader_parameter("texture_size", current_frame_texture.get_size())
				shader_mat.set_shader_parameter("enemy_modulate", enemy_sprite.modulate)
	particles.restart()
	var cleanup_delay = particles.lifetime + 0.2
	await get_tree().create_timer(cleanup_delay).timeout
	queue_free()
