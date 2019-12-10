From flask import Flask
app = Flask(__name__)

@app.route('/')
def app_msg:
    return 'Hi, the app is running OK!'


if __name == '__main__':
    app.run(debug=True, host='0.0.0.0')

