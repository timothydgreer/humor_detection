function auc = make_ROC(svmfull,Y_full_f_h)
    %Make ROC Curve for a single episode
    fs = 48000;
    window = 100;
    %[X,Y] = get_data_single_episode(ep1start, ep1end, yep1, fs, window);
    %svm = fitcsvm(X,Y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto','CrossVal','on');
    [Y2, scores] = kfoldPredict(svmfull);
    pd = [];
    pfa = [];
    for i = -3:.05:3
        Ytemp = double((scores(:,1) < i));
        temp_mat = confusionmat(Ytemp,Y_full_f_h);
        pd = [pd, temp_mat(2,2)/sum(temp_mat(:,2),1)];
        pfa = [pfa, temp_mat(2,1)/sum(temp_mat(:,1),1)];
    end
    figure
    plot(pfa, pd);   
    hold off
    height = (pd(2:end)+pd(1:end-1))/2;
    width = (pfa(2:end)-pfa(1:end-1));
    auc = sum(height.*width)
end
