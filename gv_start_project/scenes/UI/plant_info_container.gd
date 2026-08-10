extends Control
@onready var v_box_container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer

func add(child: PanelContainer):
	v_box_container.add_child(child)
	
func get_infos() -> Array:
	return v_box_container.get_children()
	
func remove(child: PanelContainer):
	v_box_container.remove_child(child)
