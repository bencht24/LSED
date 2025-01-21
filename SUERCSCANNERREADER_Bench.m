% this part defines the dcy file you want to read
dcy_filename = '31TOP.dcy';  % Replace with your .dcy filename
excel_filename = '31TOP_excel.xlsx';

% The title pieces of the dcy file are removed in the excel file

dcy_data = readtable(dcy_filename, 'FileType', 'text', 'Delimiter', ', ', 'HeaderLines', 14);

% There are often near 2^24 datapoints that are errors in the scan data. These
% are identified then subtracted by 2^24
error_value = 2^24;
tolerance = 1e5;  

dcy_data{:,:} = arrayfun(@(x) ...
    x - error_value * (abs(x - error_value) < tolerance) + ...
    error_value * (abs(x + error_value) < tolerance), dcy_data{:,:});

% excel file saved
writetable(dcy_data, excel_filename, 'WriteVariableNames', true);

% new excel file read
opts = detectImportOptions(excel_filename);
opts.DataRange = 'A1';  % new starting point for relevant data

% extract table headers
data = readtable(excel_filename, opts);
headers = data.Properties.VariableNames;

% Identify Background and Laser_On columns
background_columns = contains(headers, 'background', 'IgnoreCase', true);
laser_on_columns = contains(headers, 'Laser_On', 'IgnoreCase', true);

% Extract XY, Background, and OSL data
xy_data = data(:, 1:2);  % Columns A and B for X and Y values
background_data = data{:, background_columns};  % Columns with Background in header
osl_data = data{:, laser_on_columns};  % Columns with Laser_On in header

% produce background subtracted data
background_sum = sum(background_data, 2);
osl_sum = sum(osl_data, 2);
z_values = osl_sum - background_sum;

%combine xyz into a new table
result_data = [xy_data table(z_values)];
result_filename = [excel_filename(1:end-5), '_processed_data.xlsx'];
writetable(result_data, result_filename);

%Surface Plot 
x = xy_data{:, 1};  
y = xy_data{:, 2}; 
z = z_values;       

validRows = isfinite(x) & isfinite(y) & isfinite(z);
x = x(validRows);
y = y(validRows);
z = z(validRows);

[X, Y] = meshgrid(unique(x), unique(y));
Z = griddata(x, y, z, X, Y);
surf(X, Y, Z);
xlabel('depth (um)');
ylabel('length (um)');
zlabel('(OSL - Background)');
title('Surface Plot of OSL minus Background');
shading interp;
colorbar;
colormap jet;

%{
view(2);     % Set view to 2D
camroll(-90); % Rotate the plot 90 degrees clockwise
%}