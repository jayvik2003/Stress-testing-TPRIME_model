frac = 0;
target_Snr = 100000;
if frac == 0
load('DATASET1_1_TEST/mat_ax.mat','waveform_ax');
waveform_ax = waveform_ax';
waveform = waveform_ax;
end

if frac == 1
    load('DATASET1_1_TEST/mat_ax.mat','single_waveform_ax');
    waveform_ax = single_waveform_ax;
    waveform_ax = waveform_ax';
    waveform = waveform_ax;
    len = length(waveform);
    waveform = waveform(1:floor(len*x));
    if(length(waveform)< 34000) 
        len_corr = 34000 - length(waveform);
        waveform = waveform';
        waveform = [waveform ;(randn(len_corr,1) + 1i.*randn(len_corr,1))];
        waveform = waveform';
    end

end

% new_Snr = target_Snr;%(target_Snr - 20*log10(total_B/signal_B));
%waveform = apply_AWGN(new_Snr, waveform);
% waveform = awgn(waveform,new_Snr);
waveform1 = resample(waveform,2,1);%2,1

Fs = 20e6;

nwin = 256;
overlap = nwin/2;
stride = nwin - overlap;
win = hann(nwin,'periodic');
szeropad = [zeros(1,nwin) waveform1 zeros(1,nwin)];
szeropad = szeropad';
[S, ~, ~] = stft(szeropad,Fs,'Window',win,'OverlapLength',stride);


% S_smooth = medfilt2(abs(S), [3 3]);

S_smooth = abs(((S)));
% lowThreshold = 0.001;   
% highThreshold = 0.2; 
edge_S = edge(S_smooth, 'log');%, [lowThreshold, highThreshold]);

S_selected = zeros(size(S));

[row, col] = find(edge_S == 1);

for i = 1:length(row)
    S_selected(row(i), col(i)) = S(row(i), col(i));
end

[signalReconClean, ~] = stftRecon(S_selected, Fs, win, nwin, stride);
waveform = resample(signalReconClean,1,2);%1,2
plot(abs(waveform))
