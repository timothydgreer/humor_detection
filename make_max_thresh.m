function [max, best_thresh] = make_max_thresh(svmfull,Y_full_f_h)
    %Make ROC Curve for a single episode
    fs = 48000;
    window = 100;
    %[X,Y] = get_data_single_episode(ep1start, ep1end, yep1, fs, window);
    %svm = fitcsvm(X,Y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto','CrossVal','on');
    [Y2, scores] = kfoldPredict(svmfull);
    prec = [];
    rec = [];
    max = 0;
    for i = -3:.05:3
        Ytemp = double((scores(:,1) < i));
        [temp_prec, temp_rec, temp_f] = getPRF(Ytemp,Y_full_f_h);
        prec = [prec, temp_prec];
        rec = [rec, temp_rec];
        if temp_f > max
            max = temp_f;
            best_thresh = i;
        end
    end
    figure
    plot(rec, prec);   
    hold off
    height = (prec(2:end)+prec(1:end-1))/2;
    width = (rec(2:end)-rec(1:end-1));
    auc = sum(height.*width)
end
