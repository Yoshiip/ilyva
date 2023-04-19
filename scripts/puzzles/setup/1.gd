extends Node

var root : Array
func ready() -> void:
	root = [
		SystemElement.new(1, "translator", "/", "", [
			SystemElement.new(1, "modules", "/translator", "", [
				SystemElement.new(0, "mod1.bin", "/translator/modules", "", [], "root", "root"),
				SystemElement.new(0, "mod2.bin", "/translator/modules", "", [], "root", "root"),
				SystemElement.new(0, "lang4.bin", "/translator/langages", "", [], "root", "root"),
				SystemElement.new(0, "mod3.bin", "/translator/modules", "", [], "root", "root"),
				SystemElement.new(0, "mod4.bin", "/translator/modules", "", [], "root", "root"),

			], "root", "root"),
			SystemElement.new(1, "langages", "/translator", "", [
				SystemElement.new(0, "satel1.bin", "/translator/satellite", "", [], "root", "root"),
				SystemElement.new(0, "lang1.bin", "/translator/langages", "", [], "root", "root"),
				SystemElement.new(0, "lang_2.bin", "/translator/langages", "", [], "root", "root"),
				SystemElement.new(0, "lang3.bin", "/translator/langages", "", [], "root", "root"),
			], "root", "root"),
			SystemElement.new(1, "satellite", "/translator", "", [
				SystemElement.new(0, "satel2.bin", "/translator/satellite", "", [], "root", "root"),
				SystemElement.new(0, "satel3.bin", "/translator/satellite", "", [], "root", "root"),
				SystemElement.new(0, "satel4.bin", "/translator/satellite", "", [], "root", "root"),

			], "root", "root"),
		], "root", "root")
	]
