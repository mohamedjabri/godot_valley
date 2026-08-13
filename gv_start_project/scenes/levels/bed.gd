extends StaticBody2D
signal sleeping

func interact(_player):
	sleeping.emit()
