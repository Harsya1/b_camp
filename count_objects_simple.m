function [citra_asli, jumlah_objek, analisa_perhitungan] = count_objects_simple(imagePath)
    % Read the original image
    citra_asli = imread(imagePath);
    
    % Convert to grayscale if the image is RGB
    if size(citra_asli, 3) == 3
        citra_gray = rgb2gray(citra_asli);
    else
        citra_gray = citra_asli;
    end
    
    % Convert the image to binary
    bw = imbinarize(citra_gray);
    
    % Label the objects
    [L, jumlah_objek] = bwlabel(bw);
    
    % Initialize the analysis array
    analisa_perhitungan = regionprops(L, 'BoundingBox');
    
    % Display the original image with bounding boxes
    imshow(citra_asli);
    hold on;
    for k = 1:jumlah_objek
        rectangle('Position', analisa_perhitungan(k).BoundingBox, 'EdgeColor', 'r', 'LineWidth', 2);
    end
    hold off;
    
    % Return the original image, number of objects, and bounding box analysis
end
