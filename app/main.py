from flask import Flask, render_template  # Importe render_template
import socket

app = Flask(__name__)

@app.route('/')
def hello_ecs():
    hostname = socket.gethostname()
    
    # Renderiza o template, passando o hostname como variável
    return render_template('index.html', hostname=hostname) 

if __name__ == '__main__':
    # Continue com o host e porta para ambiente de container (ECS)
    app.run(host='0.0.0.0', port=8080)