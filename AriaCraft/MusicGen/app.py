from flask import Flask, request, jsonify, make_response
from flask_restful import Api
from flask_cors import CORS
from musicGeneration import MusicGenaration

app = Flask(__name__)
cors = CORS(app, resources={r"*": {"origins": "*"}}),
api = Api(app)
musicGeneration = MusicGenaration()
app.config['DEBUG'] = True

@app.route('/ping', methods=['GET'])
def ping():
    return make_response(jsonify({'data': 'pong'}), 200)

@app.route('/generate-music', methods=['POST'])
def generate():
    try:
        data = request.get_json()
        input_list = data['input_list']
        print(input_list)
        output_files = musicGeneration.generate_continuation(input_list=input_list)
        return make_response(jsonify({'data':output_files, 'message':'Success'}), 200)
    except :
        return make_response(jsonify({'message': 'error creating music'}), 500)

@app.errorhandler(404)
def handle_404(e):
    # handle all other routes here
    return make_response(jsonify({'data' : 'Not Found, but I have HANDLED IT'}), 200)
