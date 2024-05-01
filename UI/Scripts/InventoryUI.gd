extends Control

class_name InventoryUI

# Сцена слота инвентаря
@export var slot_scene: PackedScene

@onready var inventory_list: ItemList = $Inventory_list2

@onready var player = $".."



var is_dragging = false
var drag_item_index = -1

func _ready():
	EventsGlobal.update_inventory.connect(_refresh)
	_refresh()


# Функция для добавления элементов инвентаря в ItemList
func _add_inventory_item():
	# Получаем список предметов из инвентаря игрока
	var items = player.inventory.get_items()
	inventory_list.clear()
	for item_data in items:
		var item_pick = item_data[0].icon
		var quantity = str(item_data[1])
		# Добавляем элементы в ItemList
		inventory_list.add_item(quantity, item_pick)

# Функция для обновления инвентаря в HUD
func _refresh():
	print()
	# Очищаем список инвентаря в HUD и добавляем элементы заново
	_add_inventory_item()






