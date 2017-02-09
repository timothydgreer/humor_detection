
# coding: utf-8

# In[65]:

#!/usr/bin/env python

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
from nltk.stem.snowball import SnowballStemmer
#this is for chunker
import commands
#Karan told me to do this
#commands.getstatusoutput(<bash-command>)
from pattern.en import parse
from VLIWC import VLIWC
import math

#computes perplexity of the unigram model on a testset?
#From here: http://stackoverflow.com/questions/33266956/nltk-package-to-estimate-the-unigram-perplexity  
def perplexity(testset, model):
    testset = testset.split()
    perplexity = 1
    N = 0
    for word in testset:
        N += 1
        perplexity = perplexity * (1/model[word])
    perplexity = pow(perplexity, 1/float(N)) 
    return perplexity

#here you construct the unigram language model 
def unigram(tokens):    
    model = collections.defaultdict(lambda: 0.01)
    for f in tokens:
        try:
            model[f] += 1
        except KeyError:
            model [f] = 1
            continue
    for word in model:
        model[word] = model[word]/float(len(model))
    return model    
    
#cachedStopWords = stopwords.words("english")
with open('30_minutes_or_less.txt','rb') as myFile:
    mystr = myFile.read()

with open('30_minutes_or_less.txt','rb') as myFile:
    mylist = myFile.readlines()

#Get our word associations from waid mohammad
with open('wordassocs.txt','rb') as myFile:
    wordassocs = myFile.readlines()


# In[66]:

s = 'The mobile web is more important than mobile apps. My name is Tim. Jeff, my friend, is a good guy.'
s = parse(s, relations=False, lemmata=False)
print s
print ""
vliwc = VLIWC(dict_file = "./LIWC2007_English131104.dic")
fff = vliwc.processText("So in America when the sun goes down and I sit on the old broken-down river pier watching the long, long skies over New Jersey and sense all that raw land that rolls in one unbelievable huge bulge over to the West Coast, and all that road going, and all the people dreaming in the immensity of it, and in Iowa I know by now the children must be crying in the land where they let the children cry, and tonight the stars'll be out, and don't you know that God is Pooh Bear? the evening star must be drooping and shedding her sparkler dims on the prairie, which is just before the coming of complete night that blesses the earth, darkens all the rivers, cups the peaks and folds the final shore in, and nobody, nobody knows what's going to happen to anybody besides the forlorn rags of growing old, I think of Dean Moriarty, I even think of Old Dean Moriarty the father we never found, I think of Dean Moriarty.")
print type(fff)
print fff


# In[67]:

print mylist[0:10]


# In[68]:

#Let's get the wordassocs as an nx2 array
for i in xrange(len(wordassocs)):
    wordassocs[i] = wordassocs[i].split()
print wordassocs[:][0]

#This is going to get the words. There will be 10 of each
wordsonly = [item[0] for item in wordassocs]

#Get one of each word. There are 14182 words here
words_only_no_dups = wordsonly[1:-1:10]


#Parse by line
mylist = filter(lambda a: a != '\n', mylist)
for i in xrange(len(mylist)):
    mylist[i] = mylist[i].rstrip()

#Print the first 100 lines
print mylist[1:100]

#Let's get the character names
characters = []
for line in mylist:
    temp = line.partition(" => ")
    characters.append(temp[0]) 

#This is number of characters
uniq_chars = list(set(characters))
lenchars = len(characters)


# In[69]:

print uniq_chars


# In[70]:

#Set up a dictionary
d = dict.fromkeys(characters)

#Set as empty to start
for key in d:
    d[key] = []


print d['DWAYNE']

#Split up every line into character and speech. Then assign the speech to each corresponding character. This is a dictionary of lists
for line in mylist:
    temp = line.partition(" => ")
    #print temp[0]
    #print temp[2]
    d[temp[0]].append(temp[2])
    #print d[temp[0]]


print characters

#Time to get the corpus of lines for each character
dcorp = dict.fromkeys(characters)


#Instantiate the dictionary
for key in dcorp:
    dcorp[key] = []

#Pretty much copy the dict from before, but this is now a dictionary of strings instead of lists
for key in d:
    dcorp[key] = ' '.join(str(elem) for elem in d[key])

#Print to show this is right
print dcorp['REGISTER WOMAN']

#PUT IN THE GRAMS HERE

#Let's get the 1-grams, 2-grams, and 3-grams for each character


# In[73]:

#Instantiate the dictionary
dtest = dict.fromkeys(characters)
for key in dcorp:
    dtest[key] = []
list1 = ["2","#","4nm"]
list2 = ['3','6','0']
dtest["WILL"].append(list1)
dtest["WILL"].append(list2)
print dtest["WILL"]
stemmer = SnowballStemmer("english")
print(SnowballStemmer("english").stem("validated"))
dog = wn.synset('dog.n.01')
cat = wn.synset('cat.n.01')

print dog.res_similarity(cat, brown_ic)


# In[72]:

#Time to get the corpus of lines for each character
dcorp123 = dict.fromkeys(characters)

#Instantiate the dictionary
for key in dcorp:
    dcorp123[key] = []

#Pretty much copy the dict from before, but this is now a dictionary of lists of 5 items, with 1 2 3 4 and 5 grams the elements
for key in dcorp:
    #For every utterance
    for i in xrange(len(d[key])):
        sents = nltk.sent_tokenize(d[key][i])
        for k in xrange(len(sents)):
            sents[k] = sents[k][:-1]
        full_sents_with_commas = " ".join(sents)
        full_sents = full_sents_with_commas.replace(",","")
        #This might not be right (below) We essentially want the utterances so we can
        #see if they are humorous or not. TODO: We may want this to be a sentence.
        token = nltk.word_tokenize(full_sents)
        unigrams = ngrams(token,1)
        bigrams = ngrams(token,2)
        trigrams = ngrams(token,3)
        fourgrams = ngrams(token,4)
        fivegrams = ngrams(token,5)

        
        #Get perplexity. This might need to be changed, too!
        #This taken from http://stackoverflow.com/questions/33266956/nltk-package-to-estimate-the-unigram-perplexity
        #We are going to find the perplexity for unfunny texts and funny texts, using 4 or 5 grams
        #model = unigram(tokens)
        #perplex = perplexity(dcorp[key][i])
        #print "HERE???"
        #Perplexity Ratio. This is probably wrong.
        #perplexrat = (perplex*len(dcorp[key][i])/len(dcorp[key]))
        
        
        print "\n\n\n"
        #Append to make a new list in the list.
        dcorp123[key].append(unigrams)
        dcorp123[key].append(bigrams)
        dcorp123[key].append(trigrams)
        dcorp123[key].append(fourgrams)
        dcorp123[key].append(fivegrams)
        #print type(dcorp123[key])
        #print dcorp123[key]
        #This is definitely wrong (below) http://stackoverflow.com/questions/35242155/kneser-ney-smoothing-of-trigrams-using-python-nltk
        freq_dist = nltk.FreqDist(trigrams)
        kneser_ney = nltk.KneserNeyProbDist(freq_dist)
        prob_sum = 0.0
        for k in kneser_ney.samples():
            prob_sum += kneser_ney.prob(k)
        if prob_sum > 0.0:
            print "Probsum ", str(prob_sum)

        #Get the parts of speech for one utterance
        
        tags = nltk.pos_tag(token)
        vliwc = VLIWC(dict_file = "./LIWC2007_English131104.dic")
        fff = vliwc.processText(d[key][i])
        print fff



        #Utterance Complexity here
        nouns = 0
        adjs = 0
        verbs = 0
        advs = 0
        polarity = 0
        cardinality = len(token)
        #All I have to do is remove the periods and commas here and I'm done.
        #TODO: USE STEMS? REMOVE SENTENCES
        synses = []
        #Add up the nouns for complexity
        #Get the synset for each word so we can get dispersion eventually
        for j in xrange(len(tags)):
            if tags[j][1][0:2] == 'NN':
                temp = (wn.synsets(tags[j][1]),'n')
                synses.append(temp[0])
                nouns = nouns+1
            if tags[j][1][0:2] == 'JJ':
                temp = (wn.synsets(tags[j][1]),'a')
                synses.append(temp[0])
                adjs = adjs+1
            if tags[j][1][0:2] == 'VB':
                temp = (wn.synsets(tags[j][1]),'v')
                synses.append(temp[0])
                verbs = verbs+1
            if tags[j][1][0:2] == 'RB':
                temp = (wn.synsets(tags[j][1]),'r')
                synses.append(temp[0])
                advs = advs+1
            #print tags[j]
            try:
                ind = words_only_no_dups.index(tags[j][0])
            except:
                try: 
                    ind = words_only_no_dups.index(SnowballStemmer("english").stem(tags[j][0]))
                    print "Actually Got Here"
                except:
                    continue
            for k in xrange(2):
                polarity += int(wordassocs[ind*10+k+5][-1])
                if int(wordassocs[ind*10+k+5][-1]) != 0:
                    print wordassocs[ind*10+k+5][0]
                    print wordassocs[ind*10+k+5][1]
        
        #Find the polarity score from the polarity plus the 
        polarity_score = (0.0 + polarity)/(cardinality + 0.0)
        print "Polarity: ", str(polarity)
        print "Cardinality: ", str(cardinality)
        print "d[key][i] clean: ", str(full_sents)
        print "Polarity_score: ", str(polarity_score)                  
        #WHAT IS A CLAUSE??
        #USE CHUNKER (Stanford) to find phrases
        complexity = (nouns+verbs+0.0)/(math.log(cardinality)+1.0) #Should be clauses
        print "Complexity, using loglen: ", str(complexity)


        #Dispersion here 
        
        
        #Contextual imbalance here Resnik measure, implemented in WordNet: Similarity
        #http://www.nltk.org/howto/wordnet.html
        
        #Emotional scenarios Whissell's dictionary
        #Download on windows, port to http://www.innerworlds.50megs.com/whissel-dictionary-of-affect/index.htm
        
        #We can also use LIWC


# In[ ]:

wl = dict.fromkeys(characters)
    
for key in dcorp:
    wl[key] = []
for i in xrange(len(uniq_chars)):
    wl[uniq_chars[i]] = [word.strip(string.punctuation).lower() for word in dcorp[uniq_chars[i]].split(" ")]
print wl["REGISTER WOMAN"]  


stopwords = [line.rstrip('\n') for line in open('english.txt')]
stopwords.append('')
stopwords.append(' ')

print "Number of total words per person before removing stopwords\n"
for i in xrange(len(uniq_chars)):
    print uniq_chars[i]
    print len(list(set(wl[uniq_chars[i]])))
    wl[uniq_chars[i]] = [ws for ws in wl[uniq_chars[i]] if ws not in stopwords]


uniq_words = [""]
print "Number of total words per person after removing stopwords\n"
for i in xrange(len(uniq_chars)):
    print uniq_chars[i]
    print len(list(set(wl[uniq_chars[i]])))
    uniq_words.extend(list(set(wl[uniq_chars[i]])))



#Get the Whissell Dictionary of Affect in Language
#http://www.innerworlds.50megs.com/whissel-dictionary-of-affect/index.htm    

print "Number of *total* total words after removing stopwords\n"
print len(list(set(uniq_words)))

emotions = dict.fromkeys(characters)
for key in emotions:
    emotions[key] = [0]*10



print wl["REGISTER WOMAN"]


    

        

print emotions

#Normalize emotions
normemotions = dict.fromkeys(characters)
for key in normemotions:
    normemotions[key] = [0]*10
for i in xrange(len(uniq_chars)):
    sumemotions = sum(emotions[uniq_chars[i]])
    if sumemotions != 0:
        normemotions[uniq_chars[i]] = [(elem+0.0)/sumemotions for elem in emotions[uniq_chars[i]]]
    else:
        normemotions[uniq_chars[i]] = [elem for elem in emotions[uniq_chars[i]]]

print normemotions
print "ORDER OF THE EMOTIONS"
emotitles = ["Anger", "Anticipation", "Disgust", "Fear", "Joy", "Negative", "Positive", "Sadness", "Surprise", "Trust"]
print emotitles
print normemotions['DWAYNE'].index(max(normemotions['DWAYNE']))
print normemotions['WILL'].index(max(normemotions['WILL']))
print normemotions['CHET'].index(max(normemotions['CHET']))

