% Step 1: Calculate column-wise average and standard deviation - can adjust if otherwise
numColsZGrid = size(ZGrid, 2);
column_numbers = (1:numColsZGrid)';  % Column indices

% Initialize arrays
col_averages = zeros(numColsZGrid, 1);
col_errors = zeros(numColsZGrid, 1);

for col = 1:numColsZGrid
    % Extract non-NaN values
    non_nan_values = ZGrid(~isnan(ZGrid(:, col)), col);
    
    % Calculate the mean and standard deviation
    if ~isempty(non_nan_values)
        col_averages(col) = mean(non_nan_values);
        col_errors(col) = std(non_nan_values);  
    else
        col_averages(col) = NaN;  
        col_errors(col) = NaN;
    end
end

% Combine the data into a table 
output_table = table(column_numbers, col_averages, col_errors, ...
    'VariableNames', {'ColumnNumber', 'Average', 'Error'});

% Save the output data to an Excel file
writetable(output_table, 'column_data.xlsx', 'Sheet', 1, 'WriteRowNames', true);

% Plot
figure;
errorbar(column_numbers, col_averages, col_errors, 'o');
title('Column Averages with Error Bars');
xlabel('Column Number');
ylabel('Average Z Value');
grid on;
