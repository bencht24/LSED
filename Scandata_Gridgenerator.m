% filename
filename = '31TOP_excel_processed_data.xlsx';

% Read the data from Excel 
dataTable = readtable(filename);

% Convert to matrix
xyzMatrix = table2array(dataTable(:, 1:3));

% data matrix generator organizer
X = xyzMatrix(:, 1);
Y = xyzMatrix(:, 2);
Z = xyzMatrix(:, 3);

% grid generator
uniqueX = unique(X);
uniqueY = unique(Y);

[XGrid, YGrid] = meshgrid(uniqueX, uniqueY);

ZGrid = griddata(X, Y, Z, XGrid, YGrid);

% Plot
figure;
surf(ZGrid); 
title('Surface Plot of ZGrid');
xlabel('X-axis');
ylabel('Y-axis');
zlabel('Z-axis');
colorbar; 
view(3); 
axis tight; 
shading interp;
