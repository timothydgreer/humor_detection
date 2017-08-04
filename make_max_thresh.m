function [max, best_thresh] = make_max_thresh(svmfull,Y_full_f_h)
    %Make ROC Curve for a single episode
    fs = 48000;
    window = 100;
    %Prediction used to find score (likelihood) to be used later
    [Y2, scores] = kfoldPredict(svmfull);
    %precision and recall
    prec = [];
    rec = [];
    max = 0;
    %sweep threshold
    for i = -3:.05:3
    %grabs the first score (likelhood)
        Ytemp = double((scores(:,1) < i));
        %Gets precision, recall, and f1 scores for this threshold by comparing
        %scores below threshold and truth data
        [temp_prec, temp_rec, temp_f] = getPRF(Ytemp,Y_full_f_h);
        %records precision for this threshold
        prec = [prec, temp_prec];
        %records recall for this threshold
        rec = [rec, temp_rec];
        %updates max f1 score
        if temp_f > max
            max = temp_f;
            best_thresh = i;
        end
    end
    %plot
    figure
    plot(rec, prec);   
    hold off
    %reimman sum to find the AUC
    height = (prec(2:end)+prec(1:end-1))/2;
    width = (rec(2:end)-rec(1:end-1));
    auc = sum(height.*width)
end
