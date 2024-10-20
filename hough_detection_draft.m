% Load data
load('DATASET1_1_TEST/mat_ax.mat', 'waveform_ax');
waveform = waveform_ax';
% waveform = [zeros(1,1000) waveform zeros(1,1000)];
waveform = [zeros(1,2000) waveform(1:6800) zeros(1,2000) zeros(1,2000)];
% waveform = waveform(1:6800);
% Signal and Noise Parameters
total_B = 40e6;  % Total bandwidth
signal_B = 20e6;  % Signal bandwidth
target_snr = 10;  % Target SNR in dB
new_SNR = target_snr - 10 * log10(total_B / signal_B);  % Adjusted SNR based on bandwidth

% Apply AWGN to the resampled signal
waveform1 = resample(waveform,2,1);
% waveform1 = apply_AWGN(waveform1,new_SNR);  % Add white Gaussian noise

% STFT Parameters
fs = 20e6;  % Sampling frequency
nwin = 256;  % Window size
overlap = nwin*0.5;  % Overlap between windows
win = hann(nwin, 'periodic');  % Hann window

% waveform = W1;
% Resample waveform
% waveform1 = resample(waveform, 2, 1); % Resample
% new_Snr = 10;
% waveform1 = awgn(waveform1,new_Snr);
% % STFT parameters
% Fs = 20e6;            % Sampling frequency
% nwin = 256;          % Window length
% overlap = nwin*0.5;  % Overlap length
% win = hann(nwin, 'periodic');  % Hann window

% Zero-padding and compute STFT
szeropad = [zeros(1, nwin), waveform1, zeros(1, nwin)]';
[S, ~, ~] = stft(szeropad, fs, 'Window', win, 'OverlapLength', overlap);

% Step 1: Generate or input a 2D matrix
matrix = abs(S); % Example: A 100x100 matrix with random values
% Alternatively, you can input your own matrix here.

% Step 2: Filter the input 2D matrix to reduce false alarms (Gaussian filter)
% filtered_matrix = imgaussfilt(matrix, 0.4); % Adjust sigma value for filtering

filtered_matrix = matrix;
edges = edge(filtered_matrix,'canny',[0.35,0.45]);
edges = edge(edges,"sobel");

% Step 4: Apply the Hough Transform (HT) to the edge-detected matrix
[H, theta, rho] = hough(edges);

% Step 5: Find the peaks in the Hough Transform
% Calculate the threshold as a percentage of the maximum HT value
threshold = ceil(0.5 * max(H(:))); % Adjust 0.3 to change sensitivity
peaks = houghpeaks(H,2,'Threshold', threshold); % 5 is the number of peaks to find

% Display the results
figure;
subplot(2,2,1), imagesc(matrix), title('Original 2D Matrix');
colorbar;
subplot(2,2,2), imagesc(filtered_matrix), title('Filtered 2D Matrix');
colorbar;
subplot(2,2,3), imshow(edges), title('Canny Edges');
subplot(2,2,4), imshow(imadjust(rescale(H)), 'XData', theta, 'YData', rho, ...
      'InitialMagnification', 'fit'), title('Hough Transform');
xlabel('\theta'), ylabel('\rho');
axis on, axis normal;
hold on;
plot(theta(peaks(:,2)), rho(peaks(:,1)), 's', 'color', 'red'); % Mark peaks on HT
hold off;






% x = real(waveform);  % Extract real part
% y = imag(waveform);  % Extract imaginary part
% 
% % Plot the real and imaginary parts
% figure;
% plot(x, 'b', 'DisplayName', 'Real Part'); hold on;
% plot(y, 'r', 'DisplayName', 'Imaginary Part');
% title('Real and Imaginary Parts of Waveform');
% xlabel('Sample Index');
% ylabel('Amplitude');
% legend;
% 
% % Define the accumulator space for the Hough Transform
% theta = -90:1:89;              % Range of theta values in degrees
% rhoMax = ceil(sqrt(max(length(x), max(length(y))))); % Maximum possible rho
% rho = -rhoMax:1:rhoMax;        % Range of rho values
% 
% % Initialize the Hough Accumulator
% H = zeros(length(rho), length(theta));
% 
% % Perform Hough Transform for both real and imaginary parts
% for i = 1:length(x)
%     % Vote for real part
%     for t = 1:length(theta)
%         thetaRad = deg2rad(theta(t)); % Convert degrees to radians
%         r_real = x(i)*cos(thetaRad) + y(i)*sin(thetaRad);
%         rhoIndex_real = round(r_real + rhoMax);  % Shift by rhoMax
%         if rhoIndex_real > 0 && rhoIndex_real <= length(rho) % Check bounds
%             H(rhoIndex_real, t) = H(rhoIndex_real, t) + 1; % Vote in the accumulator
%         end
%     end
%     % Vote for imaginary part
%     for t = 1:length(theta)
%         thetaRad = deg2rad(theta(t)); % Convert degrees to radians
%         r_imag = x(i)*cos(thetaRad) + y(i)*sin(thetaRad);
%         rhoIndex_imag = round(r_imag + rhoMax);  % Shift by rhoMax
%         if rhoIndex_imag > 0 && rhoIndex_imag <= length(rho) % Check bounds
%             H(rhoIndex_imag, t) = H(rhoIndex_imag, t) + 1; % Vote in the accumulator
%         end
%     end
% end
% 
% % Display the Hough Transform result (accumulator matrix)
% figure;
% imshow(H, [], 'XData', theta, 'YData', rho, 'InitialMagnification', 'fit');
% title('Hough Transform of Waveform');
% xlabel('Theta (degrees)');
% ylabel('Rho');
% axis on;
% axis normal;
% colormap(gca, hot);
% colorbar;




















% w1 =waveform(1:6800);
% w2 =waveform(1:6800);
% w3 = waveform(1:6800);
% w4 = w3;
% 
% w1 =w1';
% w2 = w2';
% w3 = w3';
% w4 = w4';
% 
% k = zeros(1,320);
% w2 = [k w2 k w2 k w2 k w2 k w2 k];
% 
% 
% k2 = randn(1,320) + 1i*randn(1,320);
% w1 = [k2 w1 k2 w1 k2 w1 k2 w1 k2 w1 k2];
% 
% w3 = [zeros(1,6800*2) w3 zeros(1,6800*2)];
% 
% w4 = [randn(1,6800*2) w4 randn(1,6800*2)];
% 
% w1 = w1';
% w2 = w2';
% w3= w3';
% w4 = w4';

% V = [0 22 27 44 97 141 158 171 184 199 210 220];  % Voltage data
% i = [0 0.04 0.06 0.07 0.21 0.33 0.39 0.45 0.51 0.6 0.68 0.76];  % Current data
% 
% % Fit a 2nd-degree polynomial to the data (quadratic fit)
% p = polyfit(i, V, 2);  % Fit V as a function of i (V = f(i))
% 
% % Generate fitted values for plotting
% i_fine = linspace(min(i), max(i), 100);  % Generate more points for a smoother curve
% V_fitted = polyval(p, i_fine);  % Compute the fitted voltage values
% 
% % Plot the original data and the fitted curve
% figure;
% plot(i, V, 'o', 'MarkerFaceColor', 'b', 'DisplayName', 'Data');  % Original data points
% hold on;
% plot(i_fine, V_fitted, '-r', 'LineWidth', 1.5, 'DisplayName', 'Fitted Curve');  % Fitted curve
% 
% % Add vertical line at i = 0.33
% xline(0.33, '--k', 'i = 0.33', 'LabelOrientation', 'horizontal', 'LabelVerticalAlignment', 'bottom');
% 
% % Extend line from (0,0) to (0.76,220)
% slope1 = 220 / 0.76;  % Slope of the first line
% i_extended1 = linspace(0, 1, 100);  % Define a larger range for current i
% V_extended1 = slope1 * i_extended1;   % Calculate voltage using the slope
% plot(i_extended1, V_extended1, '-g', 'LineWidth', 1.5, 'DisplayName', 'Extended (0,0) to (0.76,220) Line');
% 
% % Extend line from (0,0) to (0.04,22)
% slope2 = 22 / 0.04;  % Slope of the second line
% i_extended2 = linspace(0, 1, 100);  % Define a larger range for current i
% V_extended2 = slope2 * i_extended2;   % Calculate voltage using the slope
% plot(i_extended2, V_extended2, '-m', 'LineWidth', 1.5, 'DisplayName', 'Extended (0,0) to (0.04,22) Line');
% 
% % Labels, title, and grid
% xlabel('Current (i)');
% ylabel('Voltage (V)');
% title('Curve Fitting: Voltage (V) vs Current (i)');
% legend('show');
% grid on;
% hold off;

