extends AnimatedSprite2D

var distanceFromWantedAngle

func _physics_process(delta: float):
	distanceFromWantedAngle = get_parent().neededChangeInDirection
	if -12 < distanceFromWantedAngle and distanceFromWantedAngle < 12:
		if frame == 3 or frame == 1:
			if -8 < distanceFromWantedAngle and distanceFromWantedAngle < 8:
				frame = 0
		else:
			frame = 0
	elif -16 < distanceFromWantedAngle and distanceFromWantedAngle < 16:
		if frame == 2 or frame == 4:
			if -14 < distanceFromWantedAngle and distanceFromWantedAngle < 14:
				if distanceFromWantedAngle > 0:
					frame = 3
				else:
					frame = 1
		else:
			if distanceFromWantedAngle > 0:
				frame = 3
			else:
				frame = 1
	else:
		if distanceFromWantedAngle > 0:
			frame = 4
		else:
			frame = 2
