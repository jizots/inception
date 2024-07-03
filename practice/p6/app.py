from flask import Flask
import pymysql
import redis

app = Flask(__name__)

# MySQLデータベース接続
db = pymysql.connect(
    host = 'db',
    user = 'flaskuser',
    password = 'flaskpassword',
    database = 'flaskdb'
)

# Redisキャッシュ接続
cache = redis.Redis(host = 'redis', port=6379)

@app.route('/')
def hello_world():
    cache.set('hello', 'world')
    return cache.get('hello').decode()

if __name__=="__main__":
    app.run(host='0.0.0.0', port=5000)