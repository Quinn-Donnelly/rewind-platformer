extends LineEdit

func _ready() -> void:
	text_submitted.connect($"/root/Score".usernameSubmit)
	grab_focus()


func _on_text_submitted(new_text: String) -> void:
	print("just a test")


func _on_text_changed(new_text: String) -> void:
	print("yea")
