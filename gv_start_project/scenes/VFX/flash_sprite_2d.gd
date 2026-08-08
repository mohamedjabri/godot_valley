extends Sprite2D


func flash(start_duration: float = 0.2, end_duration: float = 0.2, func_callable: Callable = Callable()):
	var tween = create_tween()
	tween.tween_property(material, "shader_parameter/Progress", 1.0, start_duration)
	if func_callable.is_valid():
		tween.tween_callback(func_callable)
	tween.tween_property(material, "shader_parameter/Progress", 0.0, end_duration)
	
