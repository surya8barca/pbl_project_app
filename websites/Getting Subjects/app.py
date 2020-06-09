from flask import Flask,jsonify,request
import pandas as pd
from flask.templating import render_template

app = Flask(__name__)

def getsubjects(semester,branch):
    import pandas as pd
    df=pd.read_csv('Subjects.csv',encoding= 'unicode_escape')
    subjects=df.dropna()
    semsubjects=subjects[subjects['Semester']==semester]
    branchsubjects=semsubjects[semsubjects['Branch']==branch]
    practicalsubjects=branchsubjects[branchsubjects['Subject Type']=='Practical']["Subject Name"].tolist()
    theorysubjects=branchsubjects[branchsubjects['Subject Type']=='Theory']["Subject Name"].tolist()
    return practicalsubjects,theorysubjects


@app.route("/")
def index():
    return render_template('form.html')

@app.route("/subjects/",methods=['GET'])

def predict():
    query=request.args
    semester=int(query['Semester'])
    branch=query['Branch']
    if(semester==1 or semester==2):
        branch='Common'
    practical_subjects=[]
    theory_subjects=[]
    practical_subjects,theory_subjects=getsubjects(semester,branch)
    return jsonify({'Practical Subjects':practical_subjects,'Theory Subjects': theory_subjects}) 


if __name__ == '__main__':
    app.run()