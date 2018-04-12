#!/usr/bin/env python2
# -*- coding: utf-8 -*-
"""
Created on Mon Apr  2 18:24:25 2018

@author: nicolobarbagallo
"""
##import unicodedata
##import nltk
##import string
##import pickle
 
import re
import pandas as pd
content= pd.read_pickle('/Users/nicolobarbagallo/Desktop/Text as data/Report assessment/sermon_central_data/sermons_gay.pkl') 


##from nltk.sentiment.vader import SentimentIntensityAnalyzer

"""result = {}
for i in xrange(0,4767):
    analyzer = SentimentIntensityAnalyzer()
    scores = analyzer.polarity_scores(content[i][15])
    result[i] = scores
    content[i].append(result[i])
""" 
### Extracting sentences  

def lookup_keyword(text, keyword):
    if re.search(keyword, text.lower()) != None:
        return True
    else:
        return False

gay = [u'gay marriage',
       u'gay',
       u'gay ',
       u'gay lifestyle',
       u'same-sex',
       u'same-sex ',
       u'same sex',
       u'same sex ',
       u'homosexual*',
       u'same-sex union*',
       u'gay union*',
       u'homosexuality']

from nltk import sent_tokenize

gay2 = [[] for i in range(4767)]
hello2 = [[] for i in range(4767)]

for i in xrange(0,4767):
    gay2[i] = content[i][15]
    gay2[i] = sent_tokenize(gay2[i])
    for j,k in enumerate(gay2[i]):
        for keyword in gay:
            if lookup_keyword(k, keyword):
                if j == len(gay2[i])-1:
                    hello2[i] = " ".join([(gay2[i])[j-1], k])
                elif lookup_keyword(k, keyword):
                    hello2[i] = " ".join([(gay2[i])[j-1], k, (gay2[i])[j+1]])
for i in xrange(0,4767):
    content[i].append(hello2[i])

from nltk.sentiment.vader import SentimentIntensityAnalyzer

result = [[] for i in range(4767)] ## this is createing and empty list of lists in which to store my sentiment coefficents later on the length of it is 4767 becasue that is the number of sermons in my dataset. 
temp = [[] for i in range(4767)]
dictlist = [[] for i in range(4767)]
for i in xrange(0,4767): ###my data set is structured as a list of lists and 4767 is the number of lists that exists at the highests level (in my case the number of sermons I want to analyse)
    analyzer = SentimentIntensityAnalyzer()
    scores = analyzer.polarity_scores(content[i][17]) ## 17 is the location of the unicode string (i.e the text of each sermon) within each one of the 4767 lists/sermons in my dataset (i.e the text of each sermon)
    result[i] = scores ## this is to store the the sentiment coefficient of each sermon in my dataset seperately
    for key, value in result[i].iteritems():
        temp[i] = [key,value]
        content[i].append(temp[i]) ## this is just appending the sentiment coefficients to the respective sermons in my original dataset

### sum coefficient to get overall polarity
'''neg = [[] for i in range(4767)]        
for i in xrange(0,4767):
    neg[i] = content[i][19][1]
neg = sum(map(float,neg))

pos = [[] for i in range(4767)]        
for i in xrange(0,4767):
    pos[i] = content[i][21][1]
pos = sum(map(float,pos))

tra = [[] for i in range(4767)]        
for i in xrange(0,4767):
    tra[i] = content[i][20][1]
tra = sum(map(float,tra))'''

"""## aggragate score

comp = [[] for i in range(4767)]        
for i in xrange(0,4767):
    comp[i] = content[i][21][1]"""
    
"""## Including neutral band 
A = 0
C = 0
E = 0

for j,k in enumerate(comp): 
    if -0.01 <= k <= 0.01:
        A += 1
        neutral = (float(A) / 4767)*100
    elif k <= -0.01:
        ##print k
        C += 1
        negative = (float(C) / 4767)*100
    elif k >= float(0.01):
        print k
        E += 1
        positive = (float(E) / 4767)*100
print "%s of the sermons express a neutral sentiment towards homosexuality and same-sex relationships" % B
print "%s of the sermons express a positive sentiment towards homosexuality and same-sex relationships" % D
print "%s of the sermons express a negative sentiment towards homosexuality and same-sex relationships" % G
print B, D, G """           


"""Split only positive negative with a threshold of 0.1"""

A = 0
C = 0
positive = 0
negative = 0
for i in xrange(0,4767):
    if content[i][21][1] <= 0.1:
        print content[4762][17]
        A += 1
        negative = (float(A) / 4767)*100
    else:
        C += 1
        positive = (float(C) / 4767)*100
print "%s %s of the sermons expresses a negative sentiment towards homosexuality and same-sex relationships" % (negative,'%')
print "%s %s of the sermons expresses a positive sentiment towards homosexuality and same-sex relationships" % (positive,'%')

'''neg = 0
for i in xrange(0,4767):
    neg += content[i][19][1]
pos = 0 
for i in xrange(0,4767):
    pos += content[i][21][1]
    ##print pos
    
tra = 0 
for i in xrange(0,4767):
    tra += content[i][20][1]
    ##print tra'''

"""comp3 = 0 
for i in xrange(0,4767):
    comp3 += content[i][22][1]
    ##print comp
print comp3"""

###Export as CSV
'''import unicodecsv as csv

# Data path
path = '/Users/nicolobarbagallo/Desktop/Text as data/Report assessment/sermon_central_data'

with open(path + '/content_csv.csv', 'w') as csvfile:
    csvwriter = csv.writer(csvfile, encoding = 'utf8')
    csvwriter.writerows(content)  '''  

##create dataframe and export dataset as csv to analyse data it in R

listoftuples = [tuple(l) for l in content]
import pandas as pd
df = pd.DataFrame.from_records(listoftuples)
df = df.drop(df.columns[15], axis=1)
df.to_csv('gay_CSV.csv', encoding = 'utf8')



    
    
    
    
    
    
    
    
    
    
    
