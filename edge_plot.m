function [] = edge_plot(waveform)

frac =0;
if(frac == 1)
    new_Snr = 10;
    waveform = awgn(waveform,new_Snr);
end

waveform = waveform';
waveform1 = resample(waveform, 2, 1);
Fs = 20e6;
nwin = 256;
overlap = nwin / 4;
stride = nwin - overlap;
win = hann(nwin, 'periodic');
szeropad = [zeros(1, nwin) waveform1 zeros(1, nwin)];
szeropad = szeropad';

[S, F, T] = stft(szeropad, Fs, 'Window', win, 'OverlapLength', stride);
% figure
% imagesc(T, F, (abs(S)));

S_mag_dB = (abs(S));
filt= medfilt2(S_mag_dB,[5,5]);
edge_S = edge(filt, 'canny',[0.25,0.46]); 
edge_S = edge(edge_S,"log");

% edge_S = edge(abs((S)),"log");

figure
imshow(abs(edge_S));

end

