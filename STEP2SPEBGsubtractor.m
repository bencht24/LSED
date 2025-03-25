% Get list of all generated grid matrix Excel files
gridFiles = dir('*_dataextract.xlsx');

% Ask the user to choose a reference grid file
[selectionIdx, ok] = listdlg('PromptString', 'Select a background grid matrix', ...
                             'SelectionMode', 'single', ...
                             'ListString', {gridFiles.name});

if ~ok
    disp('No file selected. Exiting script.');
    return;
end

% Load the reference grid matrix
referenceGridFile = gridFiles(selectionIdx).name;
referenceGrid = readmatrix(referenceGridFile);

% Extract grid size from reference file
[rows, cols] = size(referenceGrid);
disp(['Using reference grid: ', referenceGridFile]);

% Loop through each grid file and subtract the reference grid
for k = 1:length(gridFiles)
    gridFileName = gridFiles(k).name;
    
    % Skip the reference grid itself
    if strcmp(gridFileName, referenceGridFile)
        continue;
    end
    
    % Load the current grid matrix
    currentGrid = readmatrix(gridFileName);
    
    % Ensure dimensions match before subtraction
    if size(currentGrid) ~= size(referenceGrid)
        disp(['Skipping ', gridFileName, ' (dimension mismatch).']);
        continue;
    end

    % Subtract the reference grid from the current grid
    subtractedGrid = currentGrid - referenceGrid;
    
    % Create a filename for the new modified grid matrix
    [~, baseFileName, ~] = fileparts(gridFileName);
    modifiedGridFile = [baseFileName '_modified.xlsx'];
    writematrix(subtractedGrid, modifiedGridFile);

    % Surface plot the modified grid matrix
    figure;
    surf(subtractedGrid);
    colormap jet;
    shading interp;
    colorbar;
    title(['Modified Grid: ', baseFileName]);
    view(2);
    
    % Save the surface plot as a JPG
    jpgFileName = [baseFileName '_modified.jpg'];
    saveas(gcf, jpgFileName);

    figFileName = [baseFileName '_modified.fig'];
    savefig(figFileName);
    
    % Close the figure to avoid clutter
    close(gcf);
    
    disp(['Saved modified grid: ', modifiedGridFile, ' and JPG: ', jpgFileName]);
end

disp('Processing complete. All modified grids have been saved.');
