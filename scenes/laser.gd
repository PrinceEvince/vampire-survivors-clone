extends Line2D

var emission_points = []
var start_point: Vector2
var end_point: Vector2
var length: float

func _process(delta):
	if len(points) > 0:
		start_point = points[0]
		end_point = points[1]
	length = start_point.distance_to(end_point)
