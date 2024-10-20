function [] = edge_tester(target_Snr,frac,x)

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

new_Snr = target_Snr;%(target_Snr - 20*log10(total_B/signal_B));
%waveform = apply_AWGN(new_Snr, waveform);
waveform = awgn(waveform,new_Snr);
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
% S_smooth = abs(S);

S_mag_dB = abs(S);
filt= medfilt2(S_mag_dB,[3,3]);
edge_S = edge(filt, 'canny',[0.35,0.48]); 
% edge_S = edge(edge_S, 'log');

S_selected = zeros(size(S));

[row, col] = find(edge_S == 1);

for i = 1:length(row)
    S_selected(row(i), col(i)) = S(row(i), col(i));
end

[signalReconClean, ~] = stftRecon(S_selected, Fs, win, nwin, stride);
waveform = resample(signalReconClean,1,2);%1,2

save("DATASET1_1_TEST/802_11ax/802.11ax_IQ_frame_1.mat","waveform");
%clear;
%load("DATASET1_1_TEST/802_11ax/802.11ax_IQ_frame_1.mat","waveform");

end

