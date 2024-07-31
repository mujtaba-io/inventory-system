extends Control
class_name InventorySlot

@export var item: Item

signal slot_pressed(which: InventorySlot)
signal slot_hovered(which: InventorySlot, is_hovering: bool)


func _ready():
	add_to_group("inventory_slots")


func set_item(new_item: InventoryItem):
	if self.item and self.item.item_name == new_item.item_name:
		self.item.amount += new_item.amount
	else:
		item = new_item
	update_slot()


"""
func remove_item():
	item = null
	update_slot()
"""


# Removes item from slot and returns it.
func select_item() -> InventoryItem:
	var inventory = self.get_parent().get_parent() # Inventory
	var tmp_item := self.item
	if tmp_item:
		tmp_item.reparent(inventory)
		self.item = null
	return tmp_item


# If swap, then retur swapped item, else return null
func deselect_item(new_item: InventoryItem) -> InventoryItem:
	var inventory = self.get_parent().get_parent() # Inventory
	if self.is_empty():
		new_item.reparent(self)
		self.item = new_item
		return null
	else:
		if self.has_same_item(new_item): # if both items are same
			self.item.amount += new_item.amount
			new_item.free()
			return null
		else: # if different type, swap
			new_item.reparent(self) # Make new thing our child
			self.item.reparent(inventory) # make old thing inventory child
			var tmp_item = self.item
			self.item = new_item
			return tmp_item



# Is slot empty (has no item)
func is_empty():
	return self.item == null


# Has same kind of item?
func has_same_item(_item: InventoryItem):
	_item.item_name == self.item.item_name


func update_slot():
	if item:
		if not self.get_children().has(item):
			add_child(item)
		item.sprite.texture = item.icon
		item.set_sprite_size_to(item.sprite, Vector2(42, 42)) # make sure texture is 32x32
		item.label.text = str(item.amount) + " - " + str(item.name)


# On slot button pressed
func _on_texture_button_pressed():
	slot_pressed.emit(self)


func _on_texture_button_mouse_entered():
	slot_hovered.emit(self, true)


func _on_texture_button_mouse_exited():
	slot_hovered.emit(self, false)
