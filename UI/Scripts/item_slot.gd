extends PanelContainer

@onready var texture_rect:TextureRect = %TextureRect

@onready var label = $Label



func display(item:Items, quntity:int = 1):
	texture_rect.texture = item.icon
	label.text = str(quntity)
