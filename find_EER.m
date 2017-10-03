function [FARfinal, FRRfinal] = find_EER(svmfull,Y_full_f_h)
    %Make ROC Curve for a single episode
    fs = 48000;
    window = 100;
    %[X,Y] = get_data_single_episode(ep1start, ep1end, yep1, fs, window);
    %svm = fitcsvm(X,Y,'Standardize',true,'KernelFunction','RBF','KernelScale','auto','CrossVal','on');
    [Y2, scores] = kfoldPredict(svmfull);
    prec = [];
    rec = [];
    max = 0;
    for i = -3:.03:3
        Ytemp = double((scores(:,1) < i));
        confusemat = confusionmat(Ytemp,Y_full_f_h);
        FRR = confusemat(1,2)/(confusemat(1,2)+confusemat(2,2));
        FAR = confusemat(2,1)/(confusemat(1,1)+confusemat(2,1));
        if abs(FRR-FAR) < .005
            FRRfinal = FRR
            FARfinal = FAR
            confusemat
        end
    end
end