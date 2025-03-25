% Get list of all .spe files in the current folder
speFiles = dir('*.spe');

% Initialize a structure to store frames data for each .spe file
framesData = struct();

% Loop through each .spe file
for k = 1:length(speFiles)
    % Get the current filename
    speFileName = speFiles(k).name;
    
    % Initialize the SpeReader with the current .spe file
    readerobj = SpeReader(speFileName);
    
    % Read all video frames
    vidFrames = readerobj.read();
    
    % Display the number of frames
    numFrames = readerobj.NumberOfFrames;
    
    % Read specific frames, for example, the first 5 frames
    frames = readerobj.read([1 5]);

    % Get video dimensions
    width = readerobj.Width;
    height = readerobj.Height;
    disp(['Video dimensions: ', num2str(width), 'x', num2str(height)]);
    
    % Create a filename for the Excel file based on the .spe file name
    [~, baseFileName, ~] = fileparts(speFileName);
    
    % Store the frames in the structured array using the base filename as a field
    framesData.(baseFileName) = frames;
    
    % Save the frames data to an Excel file
    outputFileName = [baseFileName '_dataextract.xlsx'];
    writematrix(frames, outputFileName, 'Sheet', 1, 'Range', 'A1');

    % Create a grid matrix of the same dimensions
    [X, Y] = meshgrid(1:width, 1:height);
    

    % Convert the first frame to JPG and save it
    jpgFileName = [baseFileName '_frame1.jpg'];
    imwrite(mat2gray(frames(:,:,1)), jpgFileName);
    
    %disp(['Saved: ' outputFileName ', ' gridFileName ', and ' jpgFileName]);
end

% After this, you can access individual matrices like:
% framesData.File1Name for the matrix of the file named "File1Name.spe"
