function [] = spector(waveform)
    % Spectrogram generation without displaying the figure
    
    waveform = waveform';
    % new_Snr = 10;
    % waveform = awgn(waveform,new_Snr);
    waveform1 = resample(waveform, 2, 1); % Resample

    Fs = 20e6;  % Sampling frequency

    nwin = 256;  % Window length
    overlap = nwin / 2;  % Overlap length
    stride = nwin - overlap;  % Stride length
    win = hann(nwin, 'periodic');  % Hann window
    
    szeropad = [zeros(1, nwin) waveform1 zeros(1, nwin)];
    szeropad = szeropad';
    
    [S, F, T] = stft(szeropad, Fs, 'Window', win, 'OverlapLength', stride);  % STFT

    % Create a figure but keep it invisible
    %figure('Visible', 'off');  
    
    % Generate and configure the spectrogram plot
    surf(T, F, (abs(S)), 'EdgeColor', 'none');
    % imagesc(T, F, (abs(S)));
    axis xy;
    axis tight;
    view(0, 90);
end
