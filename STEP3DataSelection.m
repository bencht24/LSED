function crop_image_selection()
    % Load image
    [file, path] = uigetfile({'*.*', 'All Files'}, 'Select an Image');
    if isequal(file, 0)
        disp('No file selected.');
        return;
    end
    img = imread(fullfile(path, file));
    
    % Display image
    figure, imshow(img);
    title('Select Crop Type: 1 - Circle, 2 - Square, 3 - Custom Polygon');
    
    % Ask user for selection type
    selectionType = input('Enter selection type (1-Circle, 2-Square, 3-Polygon): ');
    
    % Create mask based on selection type
    switch selectionType
        case 1  % Circle Selection
            h = drawcircle();
        case 2  % Square Selection
            h = drawrectangle();
        case 3  % Custom Polygon Selection
            h = drawpolygon();
        otherwise
            disp('Invalid selection.');
            return;
    end
    
    % Add a confirmation button
    uicontrol('Style', 'pushbutton', 'String', 'Confirm Selection', ...
        'Position', [20 20 120 30], ...
        'Callback', @(src, event)confirmSelection(h, img));

end

function confirmSelection(h, img)
    % Create mask from user selection
    mask = createMask(h);
    
    % Apply mask to image
    croppedImage = img;
    if size(img, 3) == 3  % If RGB, apply mask to all channels
        for c = 1:3
            tempChannel = croppedImage(:,:,c);
            tempChannel(~mask) = 0;
            croppedImage(:,:,c) = tempChannel;
        end
    else  % Grayscale
        croppedImage(~mask) = 0;
    end
    
    % Display results
    figure, imshow(mask);
    title('Mask Layer');
    
    figure, imshow(croppedImage);
    title('Cropped Image');
    
    % Save outputs
    imwrite(mask, 'mask_layer.png');
    imwrite(croppedImage, 'cropped_image.png');
    
    % Convert mask to double for Excel saving (Excel does not support logical data)
    maskNumeric = double(mask);
    
    % Save mask as an Excel file
    maskFileName = 'mask_layer.xlsx';
    writematrix(maskNumeric, maskFileName);
    
    disp(['Mask layer saved as PNG and Excel file: ', maskFileName]);
end
