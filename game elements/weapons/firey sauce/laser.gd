# line_emitter_spawner.gd
extends Line2D

const LASER_PARTICLES = preload("res://game elements/weapons/firey sauce/LaserParticles.tscn")
var particle_instances = []

func _physics_process(delta):
	var points = get_points_along_line(0.25)
	if len(points) == 0:
		pass
	else:
		for point in points:
			var new_particle = LASER_PARTICLES.instantiate()	
			new_particle.global_position = point
			add_child(new_particle)
			particle_instances.append(new_particle)
			
			
func make_invisible():
	visible = false
	for child in get_children():
		child.queue_free()
	
			
	
func get_points_along_line(density: float) -> PackedVector2Array:
	if visible:
		var generated_points := PackedVector2Array()
		var current_line_points = self.points

		if density <= 0.0 or current_line_points.size() < 2:
			print("Density must be positive and Line2D needs at least 2 points.")
			return []
		var spacing: float = 1.0 / density
		var distance_covered: float = 0.0
		var distance_to_next_point: float = spacing
		generated_points.append(self.to_global(current_line_points[0]))
		for i in range(current_line_points.size() - 1):
			var p1_local: Vector2 = current_line_points[i]
			var p2_local: Vector2 = current_line_points[i + 1]
			var segment_vector: Vector2 = p2_local - p1_local
			var segment_length: float = segment_vector.length()
			if segment_length < 0.0001:
				continue
			while distance_to_next_point <= distance_covered + segment_length + 0.0001:
				var distance_along_segment: float = distance_to_next_point - distance_covered
				var t: float = distance_along_segment / segment_length
				var point_local: Vector2 = p1_local.lerp(p2_local, t)
				generated_points.append(self.to_global(point_local))
				distance_to_next_point += spacing
			distance_covered += segment_length
		var end_point_global = self.to_global(current_line_points[-1])
		const MIN_DIST_SQ_FOR_END_POINT = 0.01
		if generated_points.is_empty() or generated_points[-1].distance_squared_to(end_point_global) > MIN_DIST_SQ_FOR_END_POINT:
			if generated_points.size() > 1 or generated_points[0].distance_squared_to(end_point_global) > MIN_DIST_SQ_FOR_END_POINT:
				generated_points.append(end_point_global)
		return generated_points
	else:
		return []
