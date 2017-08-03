function [Xbig,Ybig,NANs] = get_data_all_episodes(fs, window, yep, epstarts, epends, R, M, C, L, myflag)
    %THIS CODE IS TOTALLY RIGHT. DON'T TRY TO DEBUG AGAIN
    %THIS COULD BE 48000 TOO!! HIMYM iTunes is 44100, all else is 48000
    mywindow = window;
    seconds = window/1000;
    Tw = mywindow;           % analysis frame duration (ms)
    Ts = mywindow;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient, makes things asymmetric
    R = [100 8400];  % frequency range to consider
    M = 20;            % number of filterbank channels 
    C = 21;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    % hamming window (see Eq. (5.2) on p.73 of [1])
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    NANs = [];
    Xbig = [];
    Ybig = [];
    
    for i = 1:length(yep)
        %We have to set the sampling rate differently when using HIMYM
        %iTunes
        if i == length(yep) && myflag
            fs = 44100;
        else
            fs = 48000;
        end
        % Feature extraction (feature vectors as columns)
        MFCCs_temp = mfcc(yep{i}, fs, Tw, Ts, alpha, hamming, R, M, C, L);
        %DTW keyword spotting
        epstart = epstarts{i};
        epend = epends{i};

        %Get rid of NaN, be careful of shifts
        %b = any(isnan(MFCCs_ep2), 1);
        %MFCCs_ep2(:, b) = [];
        rounding_const = 100/mywindow;
        Y = [];
        X = [];
        roundep1start = round(epstart*rounding_const,1)/rounding_const;
        roundep1end = [round(epend(1:end-1)*rounding_const,1)/rounding_const;floor(epend(end))];
        %Why doesn't this add up in the newer code?
        -sum(roundep1start-roundep1end)*10;
        laughsecs = [];
        for i = 1:length(roundep1start)
            laughsecs = [laughsecs, roundep1start(i):seconds:roundep1end(i)-seconds];
        end
        
        for i = 3:length(MFCCs_temp(1,:))-2
            %Check NaNs
            if ~isempty(find(isnan(MFCCs_temp(:,i)))) | ~isempty(find(isnan(MFCCs_temp(:,i-1)))) | ~isempty(find(isnan(MFCCs_temp(:,i-2)))) | ~isempty(find(isnan(MFCCs_temp(:,i+1)))) | ~isempty(find(isnan(MFCCs_temp(:,i+2))))
                NANs = [NANs;1];
                continue
            end
            %Get millisecond count
            my_sec = (round(i/10,1)) - .1;
            if any(abs(my_sec-laughsecs)<1e-10)
                NANs = [NANs;0];
                Y = [Y;1];
                X = [X, [MFCCs_temp(:,i); MFCCs_temp(:,i-1); MFCCs_temp(:,i-2); ...
                    MFCCs_temp(:,i+1); MFCCs_temp(:,i+2); ...
                    norm(MFCCs_temp(:,i-1)-MFCCs_temp(:,i+1));... 
                    norm(MFCCs_temp(:,i-2)-MFCCs_temp(:,i+2)); ...
                    pdist([MFCCs_temp(:,i-2),MFCCs_temp(:,i+2)]','cosine');... 
                    pdist([MFCCs_temp(:,i-1),MFCCs_temp(:,i+1)]','cosine')]];
            else
               NANs = [NANs;0];
               Y = [Y;0];
               % X = [X, MFCCs_temp(:,i)];
               X = [X, [MFCCs_temp(:,i); MFCCs_temp(:,i-1); MFCCs_temp(:,i-2); ...
                    MFCCs_temp(:,i+1); MFCCs_temp(:,i+2); ...
                    norm(MFCCs_temp(:,i-1)-MFCCs_temp(:,i+1));... 
                    norm(MFCCs_temp(:,i-2)-MFCCs_temp(:,i+2)); ...
                    pdist([MFCCs_temp(:,i-2),MFCCs_temp(:,i+2)]','cosine');... 
                    pdist([MFCCs_temp(:,i-1),MFCCs_temp(:,i+1)]','cosine')]];
            end
        end
        X = X';
        Xbig = [Xbig; X];
        Ybig = [Ybig; Y];
    end
end
