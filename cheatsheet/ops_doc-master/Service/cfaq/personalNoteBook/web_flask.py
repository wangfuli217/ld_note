# -*- coding: utf-8 -*-
"""
Created on Tue May  1 15:19:36 2018

python web, it worked.

For this project:there are 3 other html files(base.html,entry.html,results.html) together with this py file.

url: http://127.0.0.1:5000/

dependency: mysql products(server,client),  conda install mysql-connector-python

@author: lianzeng
"""

from flask import Flask,render_template,request,redirect
import mysql.connector


class UseDatabase:
    def __init__(self, config:dict)->None:
        self.configuration = config
        
    def __enter__(self)->'cursor':
        self.conn = mysql.connector.connect(**self.configuration)
        self.cursor = self.conn.cursor()    
        return self.cursor
    
    def __exit__(self,exc_type, exc_value, exc_trace)->None:
        self.conn.commit()    
        self.cursor.close()        
        self.conn.close()    
    


def log_request(req:'flask_request', result:str)->None:    
    dbconfig = {'host':'127.0.0.1',
                'user':'vsearch',
                'password':'vsearchpasswd',
                'database':'vsearchlogdb'}
    
    with UseDatabase(dbconfig) as cursor:
        _SQL = """ insert into log 
                (phrase,letters,ip,browser_string,results)
                values
                (%s, %s, %s, %s, %s)"""
        cursor.execute(_SQL,(req.form['phrase'],
                             req.form['letters'],
                             req.remote_addr,
                             req.user_agent.browser,
                             result))                
    



def search4Letters(phrase:str, letters:str):
    ps = set(phrase)
    ls = set(letters)
    return ps.intersection(ls)



app = Flask(__name__)

@app.route('/')
def hello()->'302':
    return redirect('/entry')

@app.route('/search4',methods=['POST'])
def do_search()->'html':
    phrase = request.form['phrase']
    letter = request.form['letters']
    results =  str(search4Letters(phrase,letter))
    
    log_request(request, results)
    
    return render_template('results.html',
                           the_phrase=phrase,
                           the_letters=letter,
                           the_results=results,
                           the_title = 'Here are results:')

@app.route('/entry')
def entry_page()->'html':
    return render_template('entry.html',the_title='Web using Python Flask!')

    


if __name__ == '__main__':            
    app.run()
    
    
    
    
    
