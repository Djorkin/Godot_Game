class_name Inventory

const POISON_HEAL = preload("res://Asset/Heal_poison.tres")
const POISON_PAIN = preload("res://Asset/Pain_poison.tres")


var inventory_ui : InventoryUI 
var max_size_inv : int = 12
var max_quantity : int = 12
var _content: Array = []
var owner : Object = null

#func _init(initial_owner: Object = null):
	#self.owner = initial_owner
	#print(self.owner)

func _ready():
	inventory_ui = InventoryUI.new()

func add_item(item: Items, quantity: int = 1):
	var found = false
	for i in range(_content.size()):
		if _content[i][0] == item:
			var total_quantity = _content[i][1] + quantity
			if total_quantity <= max_quantity:
				_content[i][1] = total_quantity
			else:
				_content[i][1] = max_quantity
			found = true
			break

	if not found and _content.size() < max_size_inv:
		if quantity <= max_quantity:
			_content.append([item, quantity])
		else:
			_content.append([item, max_quantity])
	else:
		print("Инвентарь Переполнен")
		EventsGlobal.emit_signal("update_inventory")
		return
		
	EventsGlobal.emit_signal("update_inventory")

func remove_item(item: Items):
	var items_to_remove = []
	for i in range(_content.size()):
		if _content[i][0] == item:
			items_to_remove.append(i)

	for i in range(items_to_remove.size() - 1, -1, -1):
		_content.remove_at(items_to_remove[i])
	EventsGlobal.emit_signal("update_inventory")

func get_items() -> Array:
	var items_data = []
	for item_data in _content:
		items_data.append([item_data[0], item_data[1]])
	return items_data

func increase_item_quantity(item: Items, amount: int = 1):
	for i in range(_content.size()):
		if _content[i][0] == item:
			_content[i][1] += amount
			break
	EventsGlobal.emit_signal("update_inventory")

func decrease_item_quantity(item: Items, amount: int = 1):
	var item_index = -1
	for i in range(_content.size()):
		if _content[i][0] == item:
			item_index = i
			break

	if item_index != -1:
		_content[item_index][1] = max(0, _content[item_index][1] - amount)
		if _content[item_index][1] == 0:
			_content.remove_at(item_index)
		EventsGlobal.emit_signal("update_inventory")

func set_item_quantity(item: Items, quantity: int):
	for i in range(_content.size()):
		if _content[i][0] == item:
			_content[i][1] = max(0, quantity)
			if _content[i][1] == 0:
				_content.remove_at(i) 
			break
	EventsGlobal.emit_signal("update_inventory")

func use_item(item: Items):
	item.heal(owner)
	decrease_item_quantity(item, 1)

func mix_potions(potion1 : Items, potion2 : Items) -> Items:
	var mixed_potion : Items = Items.new()
	mixed_potion.name = "смесь из: " + potion1.name + " + " + potion2.name
	mixed_potion.cost = potion1.cost + potion2.cost
	if mixed_potion.cost != 0:
		mixed_potion.cost = mixed_potion.cost / 2
	return mixed_potion
