extends CanvasLayer

@onready var stamina_bar: ProgressBar = $UI/StaminaBar

func update_stamina(current: float) -> void:
	stamina_bar.value = current
