% Define your matrices, assuming ZGrid and rescaled_croppedMatrix are loaded

% Define alignment points
refRow_ZGrid = 32;
refCol_ZGrid = 258;
refRow_rescaled = 5;
refCol_rescaled = 210;

% Calculate offsets for alignment
[rowOffset, colOffset] = deal(refRow_ZGrid - refRow_rescaled, refCol_ZGrid - refCol_rescaled);

% Resize, pad rescaled_croppedMatrix to match ZGrid
rescaled_padded = zeros(size(ZGrid));  % padded matrix will have zeros
[numRows, numCols] = size(rescaled_croppedMatrix);

% Insert rescaled_croppedMatrix into the padded matrix with alignment
rowStart = max(1, 1 + rowOffset);
colStart = max(1, 1 + colOffset);
rowEnd = min(size(ZGrid, 1), rowStart + numRows - 1);
colEnd = min(size(ZGrid, 2), colStart + numCols - 1);

% Apply rescaled_croppedMatrix into the padded area within ZGrid's dimensions
rescaled_padded(rowStart:rowEnd, colStart:colEnd) = rescaled_croppedMatrix(1:(rowEnd - rowStart + 1), 1:(colEnd - colStart + 1));

% Apply mask: Set ZGrid cells to zero where rescaled_padded values are <= 0.1
ZGrid(rescaled_padded <= 0.1) = NaN;

% Optionally: Set values in ZGrid below zero to NaN for custom coloring
% ZGrid_negative = ZGrid;  % Copy ZGrid for modification
% ZGrid_negative(ZGrid >= 0) = NaN;  % Set non-negative values to NaN in this copy

% Create surface plot
figure;
surf(ZGrid, 'EdgeColor', 'none'); hold on;
% surf(ZGrid_negative, 'EdgeColor', 'none'); 

title('Sample 3-1 Top');
xlabel('X');
ylabel('Y');
zlabel('Z');

% Optional: Set colormap and color axis limits
% caxis([min(ZGrid(ZGrid ~= 0)), max(ZGrid(:))]);  
% colormap([0 0 0; 0 0 1; jet]);  % Add white for zero, blue for negative, and jet colormap
% shading interp;
colorbar;

% Save ZGrid to an Excel file
writematrix(ZGrid, 'ZGrid_Output.xlsx');
