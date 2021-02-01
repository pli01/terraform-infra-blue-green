from wsgiref.simple_server import make_server
import os

myhost = os.uname()[1]

hello_target = os.environ.get('HELLO_TARGET', 'World')

GREETING = 'Hello, '+hello_target+' from '+myhost+'\n'

def hello(environ, start_response):
    start_response('200 OK', [('Content-Type', 'text/plain')])
    return [GREETING.encode("utf-8")]

make_server('0.0.0.0', 9000, hello).serve_forever()
