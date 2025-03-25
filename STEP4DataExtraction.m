% Get list of all modified grid matrix Excel files
modifiedGridFiles = dir('*_modified.xlsx');

if isempty(modifiedGridFiles)
    disp('No modified grid files found. Exiting script.');
    return;
end

% Ask the user to choose a modified grid file
[gridIdx, gridOk] = listdlg('PromptString', 'Select a modified grid matrix:', ...
                            'SelectionMode', 'single', ...
                            'ListString', {modifiedGridFiles.name});

if ~gridOk
    disp('No grid file selected. Exiting script.');
    return;
end

% Load the selected modified grid matrix
selectedGridFile = modifiedGridFiles(gridIdx).name;
modifiedGrid = readmatrix(selectedGridFile);
disp(['Using modified grid: ', selectedGridFile]);

% Get list of all mask files (assumed to be stored as Excel files)
maskFiles = dir('*mask_layer.xlsx'); % Ensure mask files follow this naming convention

if isempty(maskFiles)
    disp('No mask files found. Exiting script.');
    return;
end

% Ask the user to choose a mask file
[maskIdx, maskOk] = listdlg('PromptString', 'Select a mask matrix:', ...
                            'SelectionMode', 'single', ...
                            'ListString', {maskFiles.name});

if ~maskOk
    disp('No mask file selected. Exiting script.');
    return;
end

% Load the selected mask matrix
selectedMaskFile = maskFiles(maskIdx).name;
maskMatrix = readmatrix(selectedMaskFile);
disp(['Using mask file: ', selectedMaskFile]);

% Ensure dimensions match before applying the mask
if ~isequal(size(modifiedGrid), size(maskMatrix))
    disp('Error: Mask dimensions do not match the grid dimensions. Exiting script.');
    return;
end

% Apply the mask (extract only the values where mask == 1)
extractedValues = modifiedGrid .* maskMatrix;

% Replace zeros with NaN to indicate unmasked areas (optional)
extractedValues(maskMatrix == 0) = NaN;

% Compute the total sum of extracted Z values (ignoring NaNs)
totalZValue = sum(extractedValues(~isnan(extractedValues)), 'all');

% Save the extracted data as a new Excel file
[~, baseFileName, ~] = fileparts(selectedGridFile);
extractedFileName = [baseFileName '_extracted.xlsx'];
writematrix(extractedValues, extractedFileName);

% Save the total Z value to a text file
summaryFileName = [baseFileName '_extracted_summary.txt'];
fid = fopen(summaryFileName, 'w');
fprintf(fid, 'Total Z Value of Selection: %.4f\n', totalZValue);
fclose(fid);

% Display the extracted data as a surface plot
figure;
surf(extractedValues, 'EdgeColor', 'none');
colormap jet;
shading interp;
colorbar;
title(['Extracted Data: ', baseFileName]);

% Save the surface plot as both JPG and FIG
jpgFileName = [baseFileName '_extracted.jpg'];
figFileName = [baseFileName '_extracted.fig'];
saveas(gcf, jpgFileName);
savefig(figFileName);

% Close the figure to avoid clutter
close(gcf);

% Display results in the command window
disp(['Saved extracted data: ', extractedFileName]);
disp(['Saved surface plot: ', jpgFileName, ' and ', figFileName]);
disp(['Total Z Value of Selection: ', num2str(totalZValue)]);
disp(['Summary saved in: ', summaryFileName]);
disp('Mask extraction process complete.');
