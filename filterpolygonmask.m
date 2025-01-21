

% Original Matrix
originalMatrix = rearrangedCoordinates;

% Find the indices of the 1 values
[rowIndices, colIndices] = find(originalMatrix == 1);

% Specify the padding size
padding_size = 2; % Adjust this value for more or less padding

% Determine the bounding box for cropping
if ~isempty(rowIndices) && ~isempty(colIndices)
    minRow = max(min(rowIndices) - padding_size, 1); % Add padding and ensure it doesn't go out of bounds
    maxRow = min(max(rowIndices) + padding_size, size(originalMatrix, 1)); % Add padding and ensure it doesn't go out of bounds
    minCol = max(min(colIndices) - padding_size, 1); % Add padding and ensure it doesn't go out of bounds
    maxCol = min(max(colIndices) + padding_size, size(originalMatrix, 2)); % Add padding and ensure it doesn't go out of bounds

    % Create the cropped matrix with padding
    croppedMatrix = originalMatrix(minRow:maxRow, minCol:maxCol);
else
    error('No 1 values found in the matrix.');
end

% Create surface plots
figure;

% Original matrix surface plot
subplot(1, 2, 1);
surf(originalMatrix, 'EdgeColor', 'none');
title('Original Matrix');
xlabel('Columns');
ylabel('Rows');
zlabel('Value');
view(2); % View from above
axis tight;
colorbar;
colormap(gray);

% Cropped matrix surface plot
subplot(1, 2, 2);
surf(croppedMatrix, 'EdgeColor', 'none');
title(['Cropped Matrix with ' num2str(padding_size) ' Pixel Padding']);
xlabel('Columns');
ylabel('Rows');
zlabel('Value');
view(2); % View from above
axis tight;
colorbar;
colormap(gray);

figure;
surf(croppedMatrix, 'EdgeColor', 'none');
title(['Cropped Matrix with ' num2str(padding_size) ' Pixel Padding']);
xlabel('Columns');
ylabel('Rows');
zlabel('Value');
view(2); % View from above
