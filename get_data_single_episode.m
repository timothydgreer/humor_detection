function [X,Y] = get_data_single_episode(epstart, epend, yep, fs, window)
    %THIS CODE IS TOTALLY RIGHT. DON'T TRY TO DEBUG AGAIN
    %THIS COULD BE 48000 TOO!! HIMYM iTunes is 44100, all else is 48000
    mywindow = window
    seconds = window/1000;
    Tw = mywindow;           % analysis frame duration (ms)
    Ts = mywindow;           % analysis frame shift (ms)
    alpha = 0.97;      % preemphasis coefficient, makes things asymmetric
    R = [ 200 8000 ];  % frequency range to consider
    M = 20;            % number of filterbank channels 
    C = 13;            % number of cepstral coefficients
    L = 22;            % cepstral sine lifter parameter
    % hamming window (see Eq. (5.2) on p.73 of [1])
    hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
    % Feature extraction (feature vectors as columns)
    MFCCs_temp = mfcc(yep, fs, Tw, Ts, alpha, hamming, R, M, C, L);
    %DTW keyword spotting

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
    for i = 1:length(MFCCs_temp(1,:))
        %Check NaNs
        if ~isempty(find(isnan(MFCCs_temp(:,i))))
            continue
        end
        %Get millisecond count
        my_sec = (round(i/10,1)/rounding_const) - seconds;
        if any(abs(my_sec-laughsecs)<1e-10)
            Y = [Y;1];
            X = [X, MFCCs_temp(:,i)];
        else
            Y = [Y;0];
            X = [X, MFCCs_temp(:,i)];
        end
    end
    X = X';
end
