# -*- coding: utf-8 -*-
"""
Created on Sun Apr  2 16:48:07 2017

@author: greert
"""

from sklearn import tree
from sklearn.metrics import precision_recall_fscore_support
import pandas
import re
import string
from collections import Counter
from sklearn.feature_extraction.text import TfidfVectorizer, CountVectorizer
import matplotlib.pyplot as plt
from collections import defaultdict
import nltk
from nltk import bigrams
from nltk import trigrams
from nltk import word_tokenize
from nltk import ngrams
#from nltk.util import ngrams
#All messed up, but you can go here if you really want to: https://www.google.com/search?client=ubuntu&channel=fs&q=nltk.model.ngram+download&ie=utf-8&oe=utf-8
#from nltk_model_ngram import perplexity
#Don't need lesk
from nltk.wsd import lesk
from nltk.corpus import wordnet as wn
import re
import time
import pickle
from random import shuffle
from sklearn.tree import _tree
from sklearn.metrics import f1_score

def tree_to_code(tree, feature_names):
    tree_ = tree.tree_
    feature_name = [
        feature_names[i] if i != _tree.TREE_UNDEFINED else "undefined!"
        for i in tree_.feature
    ]
    print "def tree({}):".format(", ".join(feature_names))

    def recurse(node, depth):
        indent = "  " * depth
        if tree_.feature[node] != _tree.TREE_UNDEFINED:
            name = feature_name[node]
            threshold = tree_.threshold[node]
            print "{}if {} <= {}:".format(indent, name, threshold)
            recurse(tree_.children_left[node], depth + 1)
            print "{}else:  # if {} > {}".format(indent, name, threshold)
            recurse(tree_.children_right[node], depth + 1)
        else:
            print "{}return {}".format(indent, tree_.value[node])

    recurse(0, 1)

humorfeatures = pickle.load(open('humorfeatures.p','rb'))
unfunnyfeatures = pickle.load(open('unfunnyfeatures.p','rb'))
shuffled_humor = humorfeatures
shuffled_unfunny = unfunnyfeatures 
shuffle(shuffled_humor)
shuffle(shuffled_unfunny)
#print shuffled_humor
#print shuffled_unfunny
X = []
X.extend(shuffled_humor[0:int(.8*len(shuffled_humor))])
X.extend(shuffled_unfunny[0:int(.8*len(shuffled_unfunny))])
Y = []
Y.extend([1]*int(.8*len(shuffled_humor)))
Y.extend([0]*int(.8*len(shuffled_unfunny)))
print len(X)
print len(Y)
for i in xrange(len(X)):
    for j in xrange(len(X[i])):
        if X[i][j] > 100:
            X[i][j] = 0.0
clf = tree.DecisionTreeClassifier(max_depth=5)
clf = clf.fit(X, Y)
ytrain = clf.predict(X)
print clf.get_params()
print type(ytrain)
print type(Y)
print "Training Accuracy " + str(sum(ytrain==Y)/(len(Y)+0.0))

Xtest = []
Xtest.extend(shuffled_humor[int(.8*len(shuffled_humor))+1:])
Xtest.extend(shuffled_unfunny[int(.8*len(shuffled_unfunny))+1:])
for i in xrange(len(Xtest)):
    for j in xrange(len(Xtest[i])):
        if Xtest[i][j] > 100:
            Xtest[i][j] = 0.0

Ytest = []
Ytest.extend([1]*int(.2*len(shuffled_humor)))
Ytest.extend([0]*int(.2*len(shuffled_unfunny)))

ytest = clf.predict(Xtest)
print len(ytest)
print len(Xtest)
print "Testing Accuracy " + str(sum(ytest==Ytest)/(len(ytest)+0.0))
print precision_recall_fscore_support(Ytest,ytest)
print f1_score(Ytest,ytest)
print clf.predict([[4,0,0,0,0,0,0,0,0]])

feature_names = ["polarity_score", "complexity", "complnomperclause", "dispersion", "resnik_m", "posemo","social","affect","cogmech"]
print tree_to_code(clf,feature_names)
