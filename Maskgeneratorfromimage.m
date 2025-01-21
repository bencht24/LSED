% image
img = imread('Xerox Scan_31052023144524_page-0001.jpg');
hFigOriginal = figure; % Create a figure for the original image
imshow(img);
title('Draw a polygon around the object');

% interactive polygon drawing
hPolygon = drawpolygon('Color', 'r', 'LineWidth', 2);

% button to finish mask
uicontrol('Style', 'pushbutton', 'String', 'Create Mask', ...
    'Position', [20 20 100 30], 'Callback', @(src, event) finishPolygon(hPolygon, hFigOriginal, img));

% close figure
function finishPolygon(hPolygon, hFigOriginal, img)
    % Get the vertices of  polygon
    polygonVertices = hPolygon.Position;  

    
    firstNode = polygonVertices(1, :); % Coordinates of the first node
    disp(['First Node Selected - Column (X): ', num2str(firstNode(1)), ', Row (Y): ', num2str(firstNode(2))]);

    % Create  mask from polygon
    mask = roipoly(img, polygonVertices(:, 1), polygonVertices(:, 2));

    % Convert mask to boolean grid
    booleanMask = logical(mask);  

    
    figure; % Create figure for the mask
    imshow(booleanMask);
    title('Polygon Boolean Mask');

    imwrite(booleanMask, 'polygon_boolean_mask.png'); % Save as PNG

    % surface plot of boolean mask
    [rows, cols] = size(booleanMask);
    [X, Y] = meshgrid(1:cols, 1:rows); % Create meshgrid for surface plot

    % Adjust the Boolean mask to keep the original Y-axis orientation
    aligned_mask = booleanMask; % Ensure the Boolean mask is the same
    aligned_mask = flipud(aligned_mask); % Flip the mask vertically if needed

   
    figure; 
    surf(X, Y, double(aligned_mask), 'EdgeColor', 'none'); 
    colormap(gray); % U
    colorbar; 
    title('Surface Plot of the Aligned Boolean Mask');
    xlabel('X (columns)');
    ylabel('Y (rows)');
    zlabel('Mask Value');
    axis equal; 

  
    set(gca, 'YDir', 'normal'); % Set the Y-axis direction to normal

    % Create a grid matrix
    rearrangedCoordinates = double(aligned_mask);  

    assignin('base', 'rearrangedCoordinates', rearrangedCoordinates); % Make variable available in workspace

    % Display size of boolean mask 
    disp(['Boolean Mask Size: ', num2str(size(booleanMask))]);
    disp(['Rearranged Coordinates (Grid) Size: ', num2str(size(rearrangedCoordinates))]);

    close(hFigOriginal);
end
