function auc = make_ROC(svmfull,Y_full_f_h)
    %Make ROC Curve for a single episode
    fs = 48000;
    window = 100;
    %Predict with scores (likelihoods). Will be used to make ROC
    [Y2, scores] = kfoldPredict(svmfull);
    %Probability of detection, probability of false alarm
    pd = [];
    pfa = [];
    %Sweep a threshold
    for i = -3:.05:3
        %Get the predictions according to the threshold
        Ytemp = double((scores(:,1) < i));
        %Make confusion matrix to find tp and fp
        temp_mat = confusionmat(Ytemp,Y_full_f_h);
        %Compute pd and pfa for this threshold
        pd = [pd, temp_mat(2,2)/sum(temp_mat(:,2),1)];
        pfa = [pfa, temp_mat(2,1)/sum(temp_mat(:,1),1)];
    end
    %Plot
    figure
    plot(pfa, pd);   
    hold off
    %Reimann sum to find AUC
    height = (pd(2:end)+pd(1:end-1))/2;
    width = (pfa(2:end)-pfa(1:end-1));
    auc = sum(height.*width)
end
