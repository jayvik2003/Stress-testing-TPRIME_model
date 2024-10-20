load('DATASET1_1_TEST/mat_ax.mat', 'waveform_ax'); 
w1 =waveform(1:6800);
w2 =waveform(1:6800);
w3 = waveform(1:6800);
w4 = w3;

w1 =w1';
w2 = w2';
w3 = w3';
w4 = w4';

k = zeros(1,320);
w2 = [k w2 k w2 k w2 k w2 k w2 k];


k2 = randn(1,320) + 1i*randn(1,320);
w1 = [k2 w1 k2 w1 k2 w1 k2 w1 k2 w1 k2];

w3 = [zeros(1,6800*2) w3 zeros(1,6800*2)];

w4 = [randn(1,6800*2) w4 randn(1,6800*2)];

w1 = w1';
w2 = w2';
w3= w3';
w4 = w4';


% Y = waveform'; % replace 'waveform' with the actual signal variable
% 
% waveform_resampled = resample(Y, 2, 1);
% 
% total_B = 40e6;  
% signal_B = 20e6; 
% target_snr = 10;
% new_SNR = target_snr - 10 * log10(total_B / signal_B);
% 
% signal_noisy = apply_AWGN(new_SNR, waveform_resampled); 
% % signal_noisy = awgn(signal_noisy,new_Snr);
% fs = 20e6;
% 
% % Parameters for STFT
% nwin = 256;            % Window size
% overlap = 196;         % Overlap between windows
% stride = nwin - overlap;
% win = hann(nwin, 'periodic'); % Hann window for STFT
% szeropad = [zeros(1, nwin), signal_noisy, zeros(1, nwin)];
% [S, F, T] = stft(szeropad, fs, 'Window', win, 'OverlapLength', overlap);
% 
% S_mag_dB = 20*log10(abs(S));
% filt= medfilt2(S_mag_dB,[5,5]);
% edges_canny = edge(filt, 'canny',[0.25,0.35]);
% 
% %S_smooth = medfilt2(edges_canny,[3,3]);
% %sigma = 3;
% %filter_size =10;
% %LoG_filter = fspecial('log',filter_size,sigma);
% %edges_log = imfilter(S_smooth,LoG_filter,'replicate');
% %threshold= 0.2;
% %edges_strong = edges_log > threshold;
% % Plot the detected edges
% figure;
% imagesc(T, F, edges_canny); % Plot the edges
% axis xy;
% xlabel('Time (s)');
% ylabel('Frequency (Hz)');
% title('Edge Detection on Spectrogram (LoG)');
% colormap gray;
% colorbar;
% 
% %}