extends ColorPickerButton


# Called when the node enters the scene tree for the first time.
func _ready():
	var picker: ColorPicker = get_picker()
	picker.set_can_add_swatches(false)
	picker.set_modes_visible(false)
	picker.set_hex_visible(false)
	picker.set_presets_visible(false)
	picker.set_sampler_visible(false)
	picker.set_sliders_visible(false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
