addpath('./mfcc')
fs = 48000;
Tw = 100;           % analysis frame duration (ms)
Ts = 100;           % analysis frame shift (ms)
alpha = 0.97;      % preemphasis coefficient
R = [ 200 8000 ];  % frequency range to consider
M = 20;            % number of filterbank channels 
C = 13;            % number of cepstral coefficients
L = 22;            % cepstral sine lifter parameter
% hamming window (see Eq. (5.2) on p.73 of [1])
hamming = @(N)(0.54-0.46*cos(2*pi*[0:N-1].'/(N-1)));
% Feature extraction (feature vectors as columns)
MFCCs_ep8 = mfcc(yep8, fs, Tw, Ts, alpha, hamming, R, M, C, L);
%DTW keyword spotting

%Get rid of NaN, be careful of shifts
%b = any(isnan(MFCCs_ep2), 1);
%MFCCs_ep2(:, b) = [];