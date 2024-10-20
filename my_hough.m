function my_hough(stft_matrix)
    % Step 1: Edge Detection
    edges = edge(abs(stft_matrix), 'Canny'); % Apply Canny edge detection
    
    % Step 2: Hough Transform
    [H, theta, rho] = hough(edges); % Perform Hough Transform
    
    % Step 3: Hough Accumulator
    % H is the Hough accumulator, theta is the angles, and rho is the distances
    
    % Step 4: Finding Peaks
    peaks = houghpeaks(H, 5); % Find peaks in the Hough accumulator
    
    % Step 5: Lines extraction
    lines = houghlines(edges, theta, rho, peaks); % Extract lines
    
    % Visualization
    figure;
    imshow(abs(stft_matrix), []);
    hold on;
    
    % Overlay the detected lines on the original image
    for k = 1:length(lines)
        xy = [lines(k).point1; lines(k).point2];
        plot(xy(:,1), xy(:,2), 'LineWidth', 2, 'Color', 'green');
    end
    hold off;
    
    % Display the Hough accumulator
    figure;
    imshow(imadjust(mat2gray(H)), [], 'XData', theta, 'YData', rho, ...
           'InitialMagnification', 'fit');
    xlabel('Theta (degrees)');
    ylabel('Rho (pixels)');
    axis on;
    axis normal;
    colormap('hot');
end
