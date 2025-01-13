% Load and preprocess the grayscale image
im = imread('test_image.jpg');
im_gray = imresize(rgb2gray(im), 0.5);

% Define convolution kernel for edge enhancement
kernel = [-0.3, 0.6, -0.3;
           0.0,  1.0,  0.0;
           0.0,  0.0,  0.0];

% Apply convolution
enhanced_edges = conv2(double(im_gray), kernel, 'same');

% Normalize the enhanced edges to [0, 1] for thresholding
enhanced_edges = mat2gray(enhanced_edges);

% Threshold the enhanced edges to create a binary edge map
binary_edges = enhanced_edges > 0.3;  % Experiment with threshold value

% Save the binary edge map to a file
save('binary_edges.mat', 'binary_edges', 'im_gray');
disp('Binary edge map saved as "binary_edges.mat".');

% Visualize the binary edge map
figure;
imshow(binary_edges);
title('Binary Edge Map (Enhanced Edges)');
