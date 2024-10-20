load('DATASET1_1_TEST/mat_ax.mat', 'waveform_ax');
waveform = waveform_ax;
waveform = waveform';
new_Snr = 10;
% waveform = fadedSignal_ray';
waveform1 = resample(waveform, 2, 1);
waveform1 = apply_AWGN(waveform1,new_Snr);
Fs = 20e6;
nwin = 256;
overlap = 256/4;
stride = nwin - overlap;
win = hann(nwin, 'periodic');
szeropad = [zeros(1, nwin) waveform1 zeros(1, nwin)];
szeropad = szeropad';

[S, F, T] = stft(szeropad, Fs, 'Window', win, 'OverlapLength', stride);
figure
surf(T, F, 20*log10(abs(S)), 'EdgeColor', 'none');
axis xy;
axis tight;
view(0, 90);

% S_mag_dB = abs(S);
% filt= medfilt2(S_mag_dB,[2,2]);
% edge_S = edge(filt, 'canny',[0.35,0.48]);

S_mag_dB = 20*log10(abs(S));
filt= medfilt2(S_mag_dB,[5,5]);
edge_S = edge(filt, 'canny',[0.25,0.35]); 
% edge_S = edge(edge_S, 'log');

S_selected = zeros(size(S));

[row, col] = find(edge_S == 1);

rowSum = sum(edge_S,1);
colSum = sum(edge_S,2);

threshold = 0.5;  % Set your threshold 

[peaks_row, locs_row] = findpeaks(rowSum, 'MinPeakHeight', threshold);
peaksOnly_row = zeros(size(rowSum)); 
peaksOnly_row(locs_row) = peaks_row;


[peaks_col, locs_col] = findpeaks(colSum, 'MinPeakHeight', threshold);
peaksOnly = zeros(size(colSum)); 
peaksOnly_col(locs_col) = peaks_col;

for i = 1:length(row)
    S_selected(row(i), col(i)) = S(row(i), col(i));
end

figure;imshow(edge_S)
[signalReconClean, TreconClean] = stftRecon(S_selected, Fs, win, nwin, stride);
waveform = signalReconClean;
%waveform = waveform';
% Plot the original and reconstructed signals for comparison
% save("DATASET1_1_TEST/802_11ax/802.11ax_IQ_frame_1.mat","waveform");