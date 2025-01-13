% Load the binary edge map and grayscale image
load('binary_edges.mat', 'binary_edges', 'im_gray');

% Compute gradient direction from the original grayscale image
[~, grad_dir] = imgradient(im_gray);

% Extract edge points and their orientations
[row, col] = find(binary_edges);
edges = [col, row, cosd(grad_dir(sub2ind(size(grad_dir), row, col))), ...
         sind(grad_dir(sub2ind(size(grad_dir), row, col)))];

% Initialize RANSAC parameters
tau = 2.5;         % Pixel distance threshold
delta_theta = 3.0; % Angle threshold in degrees
Cmin = 30;         % Minimum consensus points
M = 2000;          % Maximum iterations

% Variables for storing detected line models
line_models = [];
used = false(size(edges, 1), 1);

% Perform RANSAC
for m = 1:M
    unused_indices = find(~used);
    if numel(unused_indices) < Cmin, break; end

    idx = unused_indices(randi(numel(unused_indices)));
    x0 = edges(idx, 1);
    y0 = edges(idx, 2);
    orientation = edges(idx, 3:4);
    d = dot(orientation, [x0; y0]);

    % Compute consensus set
    projections = edges(unused_indices, 1:2) * orientation' - d;
    distances = abs(projections);
    angle_diffs = acosd(edges(unused_indices, 3:4) * orientation');
    consensus = unused_indices((distances <= tau) & (angle_diffs <= delta_theta));

    % Verify if consensus set is large enough
    if numel(consensus) >= Cmin
        consensus_pts = edges(consensus, 1:2);
        mean_pt = mean(consensus_pts, 1);

        % PCA to determine line direction
        cov_matrix = cov(consensus_pts - mean_pt);
        [eig_vecs, ~] = eig(cov_matrix);
        line_dir = eig_vecs(:, 2); % Largest eigenvector corresponds to line direction

        % Ensure consistent orientation
        if dot(line_dir, orientation') < 0
            line_dir = -line_dir;
        end

        % Save line model
        line_models = [line_models; struct('mean_pt', mean_pt, 'direction', line_dir)];
        used(consensus) = true;
    end
end

% Visualize the lines on the image
figure;
imshow(im_gray);
hold on;
colors = lines(numel(line_models));
for i = 1:numel(line_models)
    model = line_models(i);
    start_pt = model.mean_pt - 150 * model.direction';
    end_pt = model.mean_pt + 150 * model.direction';
    plot([start_pt(1), end_pt(1)], [start_pt(2), end_pt(2)], 'LineWidth', 1.5, 'Color', colors(i, :));
end
title('Detected Lines Using RANSAC with Enhanced Edges');
hold off;