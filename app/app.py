from flask import Flask
app = Flask(__name__)

@app.route('/')
def app_msg():
    return 'The app is running OK!'


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0')

