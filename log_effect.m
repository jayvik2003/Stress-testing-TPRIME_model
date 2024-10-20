% Step 1: Load your waveform (1x34000) - example for a 1D signal
load('DATASET1_1_TEST/mat_ax.mat', 'waveform_ax');  % Replace with the actual file path
waveform = waveform_ax;
% Step 2: Define parameters for the Gaussian filter and Laplacian
sigma = 2;  % Standard deviation for Gaussian smoothing
filterSize = 2*ceil(3*sigma)+1;  % Filter size (typically 6*sigma + 1)

% Step 3: Create a 1D Laplacian of Gaussian (LoG) filter
% Using a combination of Gaussian and Laplacian in 1D
x = -ceil(3*sigma):ceil(3*sigma);  % Define the 1D filter axis
gaussian = exp(-(x.^2) / (2*sigma^2));  % 1D Gaussian filter
gaussian = gaussian / sum(gaussian);    % Normalize the Gaussian
laplacian = -x .* exp(-(x.^2) / (2*sigma^2));  % 1D Laplacian operator

% Combine the Gaussian and Laplacian to create the LoG filter
LoG = laplacian .* gaussian;

% Step 4: Apply the LoG filter to the waveform
Swaveform = conv(waveform, LoG, 'same');  % 'same' keeps output size same as input

