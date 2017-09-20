# -*- coding: utf-8 -*-
"""
Created on Mon Sep 11 19:44:20 2017

@author: greert
"""

import pandas as pd
import csv
import os
import re


scenes = []
fluent = []
native = []
scores = []
with open('mturk_movies.csv', 'rb') as csvfile:
    reader = csv.reader(csvfile)
    for row in reader:
        scenes.append(row[29])
        fluent.append(row[30])
        scores.append(row[31])
        native.append(row[34])

scenes = scenes[1:]
fluent = fluent[1:]
scores = scores[1:]
native = native[1:]
fluent = [int(x) for x in fluent]
scores = [int(x) for x in scores]
native = [int(x) for x in native]
print sum(fluent)
print len(fluent)
print sum(native)
print len(native)
scenes.insert(771,"http://harmonica.usc.edu/scenes/antz_42.txt")
scores.insert(771,0)
fluent.insert(771,1)
native.insert(771,1)
scenes.insert(870,"http://harmonica.usc.edu/scenes/final_destination_2_83.txt")
scores.insert(870,0)
fluent.insert(870,1)
native.insert(870,1)
scenes.insert(1425,"http://harmonica.usc.edu/scenes/inglourious_basterds_85.txt")
scores.insert(1425,0)
fluent.insert(1425,1)
native.insert(1425,1)
scenes.insert(1563,"http://harmonica.usc.edu/scenes/girl_with_the_dragon_tattoo_the_24.txt")
scores.insert(1563,0)
fluent.insert(1563,1)
native.insert(1563,1)
scenes.insert(2127,"http://harmonica.usc.edu/scenes/wonder_boys_43.txt")
scores.insert(2127,0)
fluent.insert(2127,1)
native.insert(2127,1)
scenes.insert(2349,"http://harmonica.usc.edu/scenes/croupier_59.txt")
scores.insert(2349,0)
fluent.insert(2349,1)
native.insert(2349,1)
scenes.insert(2529,"http://harmonica.usc.edu/scenes/distinguished_gentleman_the_22.txt")
scores.insert(2529,0)
fluent.insert(2529,1)
native.insert(2529,1)

i = 0
scenes_unanimous= []
while i < (len(scores)):
    #temp_scores = [scores[i], scores[i+1], scores[i+2]]
    #temp_native = [native[i], native[i+1], native[i+2]]
    #temp_ands = [temp_scores[j] and temp_native[j] for j in xrange(len(temp_scores))]
    #if (sum(temp_ands)+0.0)/sum(temp_native) > .6:
    if scores[i] + scores[i+1] + scores[i+2] == 3:
        scenes_unanimous.append(1)
    else:
        scenes_unanimous.append(0)
         
    i = i+3

i= 0
while i < (len(scores)-2):
    if scenes[i]==scenes[i+1] and scenes[i+1] == scenes[i+2]:
        i = i+3
        continue
    else:
        print i
        print "GOT HERE"
        break
        #if ((native[i] == 0) & (scores[i] == 0  
    i = i+3

fluent_scores = []
fluent_scenes = []
for i in xrange(len(fluent)):
    if fluent[i] == 1:
        fluent_scores.append(scores[i])
        fluent_scenes.append(scenes[i])
        
native_scores = []
native_scenes = []
for i in xrange(len(native)):
    if native[i] == 1:
        native_scores.append(scores[i])
        native_scenes.append(scenes[i])
    i = i+3

i = 0

scenes_text = []
while i < (len(scenes)):
    tempscene = scenes[i]
    tempscene = tempscene[32:]
    with open('/home/greert/Desktop/scenes/'+str(tempscene), 'rb') as myFile:
        temp_text = myFile.readlines()
        scenes_text.append(temp_text)
    i = i+3
print len(scenes_text[0])    
for i in xrange(len(scenes_text)):
    for j in xrange(len(scenes_text[i])):
        scenes_text[i][j] = scenes_text[i][j].replace('\t','')
        scenes_text[i][j] = scenes_text[i][j].replace('\n','')
for i in xrange(len(scenes_text)):      
    scenes_text[i] = [x for x in scenes_text[i] if x != '']
print scenes_text[7]
print scenes_text[9]
for i in xrange(len(scenes_text)):      
    for j in xrange(len(scenes_text[i])):
        if re.match(r'^\w+(?=.*:)+',scenes_text[i][j]) == None:
            scenes_text[i][j] = 'BLOCKING: ' + str(scenes_text[i][j])

print scenes_text[7]
print scenes_text[9]
            
for i in xrange(len(scenes_unanimous)):
    #temp_scores = [scores[i], scores[i+1], scores[i+2]]
    #temp_native = [native[i], native[i+1], native[i+2]]
    #temp_ands = [temp_scores[j] and temp_native[j] for j in xrange(len(temp_scores))]
    #if (sum(temp_ands)+0.0)/sum(temp_native) > .6:
    if scenes_unanimous[i] == 1:
        temp = ("|").join(scenes_text[i])
        with open('humor_scenes.txt','a') as myFile:
            myFile.write(temp+'\n')
    else:
        temp = ("|").join(scenes_text[i])
        with open('nonhumor_scenes.txt','a') as myFile:
            myFile.write(temp+'\n')
    