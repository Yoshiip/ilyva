extends Control

const API_KEY = ""






const API_ENDPOINT = "https://api.openai.com/v1/chat/completions"

var http_request = null

func _ready():
	http_request = HTTPRequest.new()
	http_request.connect("request_completed", self, "_on_request_completed")
	add_child(http_request)

func _on_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		print("Request failed")
		return
	var json = JSON.parse(body.get_string_from_utf8())
	print(json)
	var box = AIBOX.instance()
	box.get_node("Text").text = str("ChatGChié: ", json.result.choices[0].message.content)
	$Canvas/Container/Scroll/Container.add_child(box)

onready var AIBOX := preload("res://prefabs/ai/AIBox.tscn")

func ask_chatgpt(text : String) -> void:
	var headers = PoolStringArray()
	headers.append("Authorization: Bearer " + API_KEY)
	headers.append("Content-Type: application/json")
	
	var body = '{"model": "gpt-3.5-turbo", "messages": [{"role": "user", "content": "' + text + '"}], "temperature": 0.7, "max_tokens": 64}'

	http_request.request(API_ENDPOINT, headers, true, HTTPClient.METHOD_POST, body)

func _on_UserInput_text_entered(new_text: String) -> void:
	var box = AIBOX.instance()
	box.get_node("Text").text = str("Vous: ", new_text)
	box.self_modulate.a = 0.8
	ask_chatgpt(new_text)
	$Canvas/Container/Scroll/Container.add_child(box)
	$Canvas/Container/UserInput.text = ""
