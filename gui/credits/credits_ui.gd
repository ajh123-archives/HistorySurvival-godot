extends CenterContainer


func _on_Close_pressed():
	hide()


func _on_label_meta_clicked(meta):
	OS.shell_open(meta)
