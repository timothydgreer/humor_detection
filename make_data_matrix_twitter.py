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
from nltk.corpus import wordnet_ic
from analyzeText import analyzeText

#computes perplexity of the unigram model on a testset
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
    
def res(my_set,ic):
    #This is Resnik Measure. I have to delimit by 3 words
    counter = 0.0;
    for i in xrange(len(my_set)-1):
        counter += my_set[i].res_similarity(my_set[i], ic)
    return counter
    
def disp(my_set):
    #This is distance from one thing to another but NOT dispersion as the paper defines it. For that, we may need to go somewhere else. 
    counter = 0;
    denom = len(my_set)*(len(my_set)-1.0)/2.0
    if denom == 0 or denom == 1:
        return 0.0
    else:
        for i in xrange(len(my_set)-1):
            for j in xrange(i+1,len(my_set)):
                if my_set[i].shortest_path_distance(my_set[j], simulate_root = True) != None:
                    counter = counter+my_set[i].shortest_path_distance(my_set[j], simulate_root = True)
    return counter/denom 
    
with open('humor_nodups.txt','rb') as myFile:
    humorlines = myFile.readlines()
    
with open('unfunny_nodups.txt','rb') as myFile:
    unfunnylines = myFile.readlines()

#Get our word associations from waid mohammad
with open('wordassocs.txt','rb') as myFile:
    wordassocs = myFile.readlines()

#Let's get the wordassocs as an nx2 array
for i in xrange(len(wordassocs)):
    wordassocs[i] = wordassocs[i].split()
print wordassocs[:][0]

#This is going to get the words. There will be 10 of each
wordsonly = [item[0] for item in wordassocs]

#Get one of each word. There are 14182 words here
words_only_no_dups = wordsonly[1:-1:10]


dcorp123 = []
humorfeatures = []
unfunnyfeatures = []
for oo in xrange(2):
    if oo == 0:
        d = humorlines
    else:
        d = unfunnylines

    #Print the first 100 lines
    print d[1:100]
    
    
    
    
    #PUT IN THE GRAMS HERE
    
    #Let's get the 1-grams, 2-grams, and 3-grams for each character
    #For every utterance
    for i in xrange(len(d)):
        d[i] = d[i].strip()
        #For every utterance
        sents = nltk.sent_tokenize(d[i])
        for k in xrange(len(sents)):
            sents[k] = sents[k][:-1]
        full_sents_with_commas = " ".join(sents)
        full_sents = full_sents_with_commas.replace(",","")
        #This might not be right (below) We essentially want the utterances so we can
        #see if they are humorous or not. TODO: We may want this to be a sentence.
        dispersion = 0
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
        dcorp123.append(unigrams)
        dcorp123.append(bigrams)
        dcorp123.append(trigrams)
        dcorp123.append(fourgrams)
        dcorp123.append(fivegrams)
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
        print tags
        vliwc = VLIWC(dict_file = "./LIWC2007_English131104.dic")
        try:
            fff = vliwc.processText(d[i])
        except:
            print "VLIWC FAILED"
            fff = dict()
            fff['posemo'] = 0.0
            fff['social'] = 0.0
            fff['affect'] = 0.0
            fff['cogmech'] = 0.0
        fftemp = []
        try:
            fftemp.append(float(fff['posemo']))
        except:
            print "Posemo failed"
            fftemp.append(0.0)
        try:
            fftemp.append(float(fff['social']))
        except:
            print "Social failed"
            fftemp.append(0.0)
        try:
            fftemp.append(float(fff['affect']))
        except:
            print "Affect Failed"
            fftemp.append(0.0)
        try:
            fftemp.append(float(fff['cogmech']))
        except:
            print "Cogmech failed"
            fftemp.append(0.0)
        
            



        #Utterance Complexity here
        nouns = 0
        adjs = 0
        verbs = 0
        advs = 0
        polarity = 0
        cardinality = len(token)
        if cardinality == 0:
            continue
        #All I have to do is remove the periods and commas here and I'm done.
        #TODO: USE STEMS? REMOVE SENTENCES
        n_synses = []
        v_synses = []
        adjs_synses = []
        advs_synses = []
        #Add up the nouns for complexity
        #Get the synset for each word so we can get dispersion eventually
        keeper = 0
        res_m = []
        for j in xrange(len(tags)):
            if tags[j][1][0:2] == 'NN':
                if n_synses and j-3 < keeper:
                    stem_temp = SnowballStemmer("english").stem(tags[j][0])
                    if not res_m:
                        st = wn.synsets(stem_temp, 'n')
                        if not st:
                            pass
                        else:
                            res_m.append(st[0])
                        stem_temp2 = SnowballStemmer("english").stem(tags[keeper][0])
                        st = wn.synsets(stem_temp2, 'n')
                        if not st:
                            pass
                        else:
                            res_m.append(st[0])
                    else:
                        stem_temp = SnowballStemmer("english").stem(tags[j][0])
                        st = wn.synsets(stem_temp, 'n')
                        if not st:
                            pass
                        else:
                            res_m.append(st[0])
                temp = (wn.synsets(tags[j][0]),'n')
                n_synses.append(temp[0])
                keeper = j                
                nouns = nouns+1
            if tags[j][1][0:2] == 'JJ':
                temp = (wn.synsets(tags[j][0]),'a')
                v_synses.append(temp[0])
                adjs = adjs+1
            if tags[j][1][0:2] == 'VB':
                temp = (wn.synsets(tags[j][0]),'v')
                adjs_synses.append(temp[0])
                verbs = verbs+1
            if tags[j][1][0:2] == 'RB':
                temp = (wn.synsets(tags[j][0]),'r')
                advs_synses.append(temp[0])
                advs = advs+1
            #print tags[j]
            
            try:
                ind = words_only_no_dups.index(tags[j][0])
            except:
                try: 
                    ind = words_only_no_dups.index(SnowballStemmer("english").stem(tags[j][0]))
                except:
                    continue
            for k in xrange(2):
                polarity += int(wordassocs[ind*10+k+5][-1])
                if int(wordassocs[ind*10+k+5][-1]) != 0:
                    print wordassocs[ind*10+k+5][0]
                    print wordassocs[ind*10+k+5][1]
        
        #RESNIK MEASURE BELOW. USE STEMS!
        with open("f.txt","wb") as myFile:
            myFile.write(d[i])
        analyzeText('f.txt','test.txt')
        with open('test.txt','rb') as myFile:
            jjj = myFile.readlines()
        print type(jjj[1])
        tempjjj = jjj[1].split(',')
        if int(tempjjj[4]) == 0:
            tempjjj[4] = 1
        print tempjjj[4]
        complexity = (int(tempjjj[3])+int(tempjjj[8])+0.0)/int(tempjjj[4])
         
        print float(tempjjj[-1].replace('\n',''))
        complnomperclause = float(tempjjj[-1].replace('\n',''))
        
        #Find the polarity score from the polarity plus the 
        polarity_score = (0.0 + polarity)/(cardinality + 0.0)
        print "Polarity: ", str(polarity)
        print "Cardinality: ", str(cardinality)
        print "d[key][i] clean: ", str(full_sents)
        print "Polarity_score: ", str(polarity_score)                  
        #WHAT IS A CLAUSE??
        #USE CHUNKER (Stanford) to find phrases
        complexity = (math.log(nouns+verbs+1.0))/(math.log(cardinality)+1.0) #Should be clauses
        print "Complexity, using loglen: ", str(complexity)


        #Dispersion here 
        dispersion = 0.0
        resnik_m = 0.0
        grand_synses = n_synses+v_synses+adjs_synses+advs_synses
        for j in xrange(len(grand_synses)):
            dispersion = dispersion + disp(grand_synses[j])
        #for j in xrange(len((n_synses))):
        #    dispersion = dispersion + disp(n_synses[j])
        #for j in xrange(len((v_synses))):
        #    dispersion = dispersion + disp(v_synses[j])
        #for j in xrange(len((adjs_synses))):
        #    dispersion = dispersion + disp(adjs_synses[j])
        #for j in xrange(len((advs_synses))):
        #    dispersion = dispersion + disp(advs_synses[j])
        print "Dispersion: ", str(dispersion/cardinality)
        
        print res_m
        resnik_m += res(res_m,brown_ic)
        
        #We still need perplexity!!!
        
        
        #Contextual imbalance here Resnik measure, implemented in WordNet: Similarity
        #http://www.nltk.org/howto/wordnet.html
        
        #RESNIK MEASURE BELOW. USE STEMS!
        print "Resnik Measure: ", str(resnik_m)
        
        #Emotional scenarios Whissell's dictionary
        #Download on windows, port to http://www.innerworlds.50megs.com/whissel-dictionary-of-affect/index.htm
        
        #We can also use LIWC
        
        #Make the final vector
        if oo == 0:
            humorfeatures.append([polarity_score, complexity, complnomperclause, dispersion, resnik_m])
            humorfeatures[-1].extend(fftemp)
        else:
            unfunnyfeatures.append([polarity_score, complexity, complnomperclause, dispersion, resnik_m])
            unfunnyfeatures[-1].extend(fftemp)

pickle.dump(humorfeatures, open("humorfeatures.p","wb"))
pickle.dump(unfunnyfeatures, open("unfunnyfeatures.p","wb"))
