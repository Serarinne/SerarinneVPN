from flask import Flask, request, jsonify
import requests
from requests_toolbelt.multipart.encoder import MultipartEncoder
import os
import spur
from dotenv import load_dotenv
import subprocess
import uuid

load_dotenv()  # Load environment variables from a .env file

app = Flask(__name__)

def send_whapi_request(endpoint, params=None, method='POST'):
	headers = {
		'Authorization': f"Bearer {os.getenv('TOKEN')}"
	}
	url = f"{os.getenv('API_URL')}/{endpoint}"
	if params:
		if 'media' in params:
			details = params.pop('media').split(';')
			with open(details[0], 'rb') as file:
				m = MultipartEncoder(fields={**params, 'media': (details[0], fiile, details[1])})
				headers['Content-Type'] = m.content_type
				response = requests.request(method, url, data=m, headers=headers)
		elif method == 'GET':
			response = requests.get(url, params=params, headers=headers)
		else:
			headers['Content-Type'] = 'application/json'
			response = requests.request(method, url, json=params, headers=headers)
	else:
		response = requests.request(method, url, headers=headers)
	return response.json()

def set_hook():
	if os.getenv('BOT_URL'):
		settings = {
			'webhooks': [
				{
					'url': os.getenv('BOT_URL'),
					'events': [
						{'type': "message", 'method': "post"}
					],
					'mode': "method"
				}
			]
	}
	send_whapi_request('settings', settings, 'PATCH')


@app.route('/hook/messages', methods=['POST'])
def handle_new_messages():
	try:
		messages = request.json.get('messages', [])
		endpoint = None
		for message in messages:
			if message.get('from_me'):
				continue
		sender = {'to': message.get('chat_id')}
		command_input = message.get('text', {}).get('body', '').strip().lower()

		if command_input.startswith("buat "):
			USERUID = uuid.uuid4()
			USERDATA = subprocess.run(['bot-add-user',command_input[5:].title().replace(" ",""),str(USERUID)], capture_output=True, text=True)
			sender['body'] = USERDATA.stdout
			endpoint = 'messages/text'
		elif command_input.startswith("pengguna"):
			USERLIST = subprocess.run(['bot-user-list'], capture_output=True, text=True)
			sender['body'] = USERLIST.stdout
			endpoint = 'messages/text'
		elif command_input.startswith("restart server"):
			subprocess.run(['reboot'])

		if endpoint is None:
			return 'Ok', 200
		response = send_whapi_request(endpoint, sender)
		return 'Ok', 200
	except Exception as e:
		print(e)
		return str(e), 500

@app.route('/', methods=['GET'])
def index():
	return 'Bot is running'

if __name__ == '__main__':
	set_hook()
	ipsvr = os.getenv('IPSVR')
	port = os.getenv('PORT') or (443 if os.getenv('BOT_URL', '').startswith('https:') else 80)
	app.run(host=ipsvr, port=port, debug=False)
