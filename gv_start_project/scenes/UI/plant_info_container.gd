extends Control
@onready var v_box_container: VBoxContainer = $MarginContainer/ScrollContainer/VBoxContainer


func add(child: PanelContainer):
	v_box_container.add_child(child)
