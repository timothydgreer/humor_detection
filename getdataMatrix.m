roundep1start = round(ep1start,1);
roundep1end = [round(ep1end(1:end-1),1);floor(ep1end(end))];
%Why doesn't this add up in the newer code?
-sum(roundep1start-roundep1end)*10
laughsecs = [];
for i = 1:length(roundep1start)
    laughsecs = [laughsecs, roundep1start(i):.1:roundep1end(i)-.1];
end
Y = [];
X = [];
for i = 1:length(MFCCs_ep1(1,:))
    %Get millisecond count
    my_sec = round(i/10,1);
    if any(abs(my_sec-laughsecs)<1e-10)
        Y = [Y;1];
        X = [X, MFCCs_ep1(:,i)];
    else
        Y = [Y;0];
        X = [X, MFCCs_ep1(:,i)];
    end
end
X = X';
    

% Y = ones(3828,1);
% Y = [Y;zeros(13408-3828,1)];
% X = zeros(13,13408);
% k = 1;
% %Fill in laughter
% for i = 1:length(roundep1start)
%     for j = 1:round(round(roundep1end(i)*10)-round(roundep1start(i)*10))
%         X(:,k) = MFCCs_ep1(:,round(roundep1start(i)*10)+j);
%         k = k+1;
%     end
% end
% %Fill in non-laughter
% k = 3829;
% for i = 1:length(roundep1end)-1
%     for j = 1:round(round(roundep1start(i+1)*10)-round(roundep1end(i)*10))
%         X(:,k) = MFCCs_ep1(:,round(roundep1end(i)*10)+j);
%         k = k+1;
%     end
% end
% 
% %Don't forget to lop off the silence after second-to-last laugh!
% X = X';



%%TODO
%Look at false negatives and positives. How many are lb and ls?
%Consider removing samples from non-laughter to balance the classes more.
%Rounding the laughter starts to better capture the data. (Maybe remove
%non-laughter that interferes?)
%DTW keyword spotting
%Overlapping windows?
%Use data from other episodes?
%Use more Friends datasets for training
%Test on HIMYM

%%
svm = fitcsvm(X,Y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto');
cv = crossval(svm);
kfoldLoss(cv)
%%
Y2 = predict(svm,X);
comps = [Y,Y2];
confusemat = confusionmat(Y,Y2)
tn = confusemat(1,1);
tp = confusemat(2,2);
fn = confusemat(2,1);
fp = confusemat(1,2);
precision = tn/(tn+fp)
recall = tp/(tp+fn)
f1 = 2*precision*recall/(precision+recall)
%%
%Make Y3 so that if it's surrounded by laughter or non-laughter and it 
%defects, it now conforms.
Y3 = [];
Y3(1) = Y2(1);
for i = 2:length(Y2)-1
    if Y3(i-1) == 0 && Y2(i+1) == 0 && Y2(i) == 1
        Y3(i) = 0;
    elseif Y3(i-1) == 1 && Y2(i+1) == 1 && Y2(i) == 0
        Y3(i) = 1;
    else
        Y3(i) = Y2(i);
    end
end
Y3 = [Y3, Y2(end)];
Y3 = Y3';
comps = [Y,Y3];
confusemat = confusionmat(Y,Y3)
tn = confusemat(1,1);
tp = confusemat(2,2);
fn = confusemat(2,1);
fp = confusemat(1,2);
precision = tn/(tn+fp)
recall = tp/(tp+fn)
f1 = 2*precision*recall/(precision+recall)
        