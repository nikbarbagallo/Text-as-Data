#!/usr/bin/python

import sys
from numpy import prod
reload(sys)  # Reload does the trick!
sys.setdefaultencoding('UTF-8')
import pickle
import unicodecsv as csv
import re

def lookup_keyword(text, keyword):
    if re.search(keyword, text.lower()) != None:
        return True
    else:
        return False

def flatten(list_of_lists):
    return [item for sublist in list_of_lists for item in sublist]

# Data path
path = '/Users/nicolobarbagallo/Desktop/Text as data/Report assessment/sermon_central_data'

# Pull in data
with open(path + '/sermons.pkl', 'r') as pfile:
    content = pickle.load(pfile)

##listoftuples = [tuple(l) for l in content2]
##df = pd.DataFrame.from_records(listoftuples)
##df = df.drop(df.columns[15], axis=1)
##df.to_csv('whole_CSV.csv', encoding = 'utf8')

immigration = [u'immigration', 
               u'immigrant', 
               u'immigrants' 
               u' migrant', 
               u'migration', 
               u'border', 
               u'mexico',
               u'mexican', 
               u'islam', 
               u'muslim',
               u'foreign',
               u'terrorism',
               u'security',
               u'refugee',
               u'flee',
               u'poverty',
               u'war',
               u'undocumented', 
               u'illegal',
               u'job', 
               u'diverse']

# Loop over and extract content
immigration = [u'immigration', 
               u'immigrant', 
               u'immigrants' 
               u' migrant', 
               u'migration', 
               u'border', 
               u'mexico',
               u'mexican',
               u'islam', 
               u'muslim',
               u'foreign',
               u'terrorism',
               u'refugee',
               u'undocumented']

immigration = [u'immigration', 
               u'immigrant', 
               u'immigrants' 
               u' migrant', 
               u'migration',  
               u'mexico',
               u'mexican',
               u'undocumented']


immigration_content = []

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
gay_content = []

for i,sermon in enumerate(content):
    # Loop over keywords
    for keyword in gay:
        if lookup_keyword(sermon[-1], keyword):
            gay_content.append(flatten([sermon, [keyword]]))
            break

    # Log progress
    if (i % 5000) == 0:
        print "Finished processing %s sermons" % i

print len(gay_content)

with open(path + '/sermons_gay.pkl', 'w') as pfile:
    pickle.dump(gay_content, pfile)


