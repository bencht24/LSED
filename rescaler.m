
% Define scaling factors for resizing
scaleX = 88/135; % Scale factor along X (width), 
scaleY = 88/135; % Scale factor along Y (height), 

% ignore this part)
newRows = 100; % New number of rows for croppedMatrix
newCols = 100; % New number of columns for croppedMatrix

% Rescale the croppedMatrix using imresize
%  Using scale factors
rescaled_croppedMatrix = imresize(croppedMatrix, scaleX);


% Display the original and rescaled matrix sizes
disp('Original Matrix Size:');
disp(size(croppedMatrix));

disp('Rescaled Matrix Size:');
disp(size(rescaled_croppedMatrix));

% Display the original and rescaled matrices
figure;

surf(rescaled_croppedMatrix);
title('Rescaled Matrix');
colorbar;
shading interp;