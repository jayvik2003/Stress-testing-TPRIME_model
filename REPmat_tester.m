function [] = REPmat_tester(target_Snr,rep)

%TESTER Summary of this function goes here
%   Detailed explanation goes here

load('DATASET1_1_TEST/mat_ax.mat','single_waveform');
waveform = single_waveform;
waveform = waveform';

%method-2
total_B = 40e6;
signal_B = 20e6;
new_Snr = (target_Snr - 20*log10(total_B/signal_B));
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

SClean = S;
[row_low, col] = size(SClean(1:50,:));
[row_high, ~] = size(SClean(205:end,:));

%method-1 of attenuation
noise_low = randn(row_low, col) + 1i .* randn(row_low, col);
noise_high = randn(row_high, col) + 1i .* randn(row_high, col);

%method-1 of attenuation
%noise_low = zeros(row_low, col);% + 1i .* zeros(row_low, col);
%noise_high = zeros(row_high, col);% + 1i .* zeros(row_high, col);

%method-1 of awgn addtion 
%noise_low = apply_AWGN(new_Snr, noise_low);
%noise_high = apply_AWGN(new_Snr, noise_high);

%method-2 of awgn addition
noise_low = awgn(noise_low,new_Snr);
noise_high = awgn(noise_high,new_Snr);


SClean(1:50,:) = noise_low;
SClean(205:end,:) = noise_high;


[signalReconClean, ~] = stftRecon(SClean, Fs, win, nwin, stride);
waveform = resample(signalReconClean,1,2);%1,2

if rep > 1
    waveform = repmat(waveform,rep,1);
end


% if rep < 1
%     waveform = repmat(waveform,1,1./rep);
% elseif rep >= 1
%     waveform = repmat(waveform,rep,1);
% end
save("DATASET1_1_TEST/802_11ax/802.11ax_IQ_frame_1.mat","waveform");
%clear;
%load("DATASET1_1_TEST/802_11ax/802.11ax_IQ_frame_1.mat","waveform");

end

