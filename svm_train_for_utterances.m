epstarts = {ep1start, ep2start, ep3start, ep8start, ep9start, ...
ep10start, ep12start, ep13start, ep14start};
epends = {ep1end, ep2end, ep3end, ep8end, ep9end, ...
ep10end, ep12end, ep13end, ep14end};
yep = {yep1, yep2, yep3, yep8, yep9, yep10, yep12, yep13, yep14};

[Xfriends,Yfriends] = get_data_all_episodes(48000,100,yep,epstarts,epends,R,20,21,22,0);


epstarts = {himym1start, himym5start, himym9start, himymstart};
epends = {himym1end, himym5end, himym9end, himymend};
yep =  {yhimym01, yhimym05, yhimym09, yhimym};


[Xhimym,Yhimym] = get_data_all_episodes(48000,100,yep,epstarts,epends,R,20,21,22,1);


svmfriends = fitcsvm(Xfriends,Yfriends,'Standardize',true,'KernelFunction','RBF','KernelScale','auto','CrossVal','on');
Y2 = kfoldPredict(svmfriends);
[precision_presmooth_fffeat, recall_presmooth_fffeat, f1_presmooth_fffeat] = getPRF(Y2,Yfriends)

Y3 = post_smooth(Y2,1);
[precision_postsmooth_fffeat, recall_postsmooth_fffeat, f1_postsmooth_fffeat] = getPRF(Y3,Yfriends)
Y3 = post_smooth_average(Y2,3,.5);
[precision_postsmooth_ff_2feat, recall_postsmooth_ff_2feat, f1_postsmooth_ff_2feat] = getPRF(Y3,Yfriends)

%%
svmhimym = fitcsvm(Xhimym,Yhimym,'Standardize',true,'KernelFunction','RBF','KernelScale','auto','CrossVal','on');
Y2 = kfoldPredict(svmhimym);
[precision_presmooth_hhfeat, recall_presmooth_hhfeat, f1_presmooth_hhfeat] = getPRF(Y2,Yhimym)

Y3 = post_smooth(Y2,1);
[precision_postsmooth_hhfeat, recall_postsmooth_hhfeat, f1_postsmooth_hhfeat] = getPRF(Y3,Yhimym)
Y3 = post_smooth_average(Y2,3,.5);
[precision_postsmooth_hh_2feat, recall_postsmooth_hh_2feat, f1_postsmooth_hh_2feat] = getPRF(Y3,Yhimym)
