function [precision_postsmooth, recall_postsmooth, f1_score_postsmooth, svm] = get_scores_train(epstart, epend, MFCCs)

    roundep1start = round(epstart,1);
    roundep1end = [round(epend(1:end-1),1);floor(epend(end))];
    %Why doesn't this add up in the newer code?
    -sum(roundep1start-roundep1end)*10;
    laughsecs = [];
    for i = 1:length(roundep1start)
        laughsecs = [laughsecs, roundep1start(i):.1:roundep1end(i)-.1];
    end
    Y = [];
    X = [];
    for i = 1:length(MFCCs(1,:))
        %Check NaNs
        if ~isempty(find(isnan(MFCCs(:,i))))
            continue
        end
        %Get millisecond count
        my_sec = round(i/10,1);
        if any(abs(my_sec-laughsecs)<1e-10)
            Y = [Y;1];
            X = [X, MFCCs(:,i)];
        else
            Y = [Y;0];
            X = [X, MFCCs(:,i)];
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
    confusemat_presmooth = confusionmat(Y,Y2)
    tn_presmooth = confusemat_presmooth(1,1);
    tp_presmooth = confusemat_presmooth(2,2);
    fn_presmooth = confusemat_presmooth(2,1);
    fp_presmooth = confusemat_presmooth(1,2);
    precision_presmooth = tn_presmooth/(tn_presmooth+fp_presmooth)
    recall_presmooth = tp_presmooth/(tp_presmooth+fn_presmooth)
    f1_presmooth = 2*precision_presmooth*recall_presmooth/(precision_presmooth+recall_presmooth)
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
    confusemat_postsmooth = confusionmat(Y,Y3)
    tn_postsmooth = confusemat_postsmooth(1,1);
    tp_postsmooth = confusemat_postsmooth(2,2);
    fn_postsmooth = confusemat_postsmooth(2,1);
    fp_postsmooth = confusemat_postsmooth(1,2);
    allcomps = [Y,Y2,Y3];
    precision_postsmooth = tn_postsmooth/(tn_postsmooth+fp_postsmooth);
    recall_postsmooth = tp_postsmooth/(tp_postsmooth+fn_postsmooth);
    f1_score_postsmooth = 2*precision_postsmooth*recall_postsmooth/(precision_postsmooth+recall_postsmooth);
end