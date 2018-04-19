# Humor Detection
This repo has code to analyze text from Twitter and audio from situational comedy TV Shows. You must have data from Twitter or the signal from the sitcoms to be able to use this code. It is not supplied in the repository. For updated code, check USC SAIL's repo on humor detection: https://github.com/usc-sail/mica-humor-from-text/

# Text
Using 30_minutes_or_less.txt, you can experiment with Get_Features.py. This creates features for the text data for the script of "30 Minutes or Less"
Then, if you have a list of humorous and non-humorous tweets, you can run get_data_matrix_twitter.py
Then, when you have your data matrix, you can run classify_humor.py to train and test a decision tree to identify humor from text.

# Sitcoms
Using get_data_all_episodes, create your data matrices for HIMYM and Friends (you have to have the signal data to do this)
Then, use find_laugh_starts.m with this data to find the start of the laughter. From there, you can use subtitle data to find the start of the laughter.
make_ROC and find_EER will find the roc curve and equal error rate of this data, respectively
get_funny_utterances will give the humorous utterances that occur before the laugh track happens


