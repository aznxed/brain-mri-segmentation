clc
clear
close all

%% Brain MRI Segmentation and Modeling 

%% Load, Crop, and Display image
%Load the .img file and assign the 3D data to a variable 
%We can visualize the data using the imshow3D and montage function
%Crop the data to a smaller volume including mostly non-zero values
   
brainMRI = double(analyze75read('KKI2009-01-MPRAGE_stripped.img'));
montage(brainMRI)
title ('Montage of original brainMRI');

imshow3D(brainMRI)

[I,J,K] = ind2sub(size(brainMRI),find(brainMRI>0));
Imin = min(I); Imax = max(I);
Jmin = min(J); Jmax = max(J);
Kmin = min(K); Kmax = max(K);
cropimage = brainMRI (Imin:Imax, Jmin:Jmax, Kmin:Kmax);

%% Normalize the Image to [0, 1]
% formula: normalized_data = (data - data_min) / (data_max - data_min)
     
data_min = min(cropimage(:));
data_max = max(cropimage(:));
normalized_brainMRI = (cropimage - data_min)./(data_max - data_min);
normalized_brainMRI (normalized_brainMRI<0.05) = 0.05;

%% Display Volume and Histogram

figure(2)
imshow3D(normalized_brainMRI)
title ('Normalized_brainMRI')

figure(3)
montage(normalized_brainMRI)
title ('Montage of normalized brain MRI')

figure(4)
imhist(normalized_brainMRI);
title ('Histogram of normalized brain MRI')

caxis('auto')
xlim([0.05 0.85])
ylim([0.05 20000])
colorbar ('northoutside')

%% Perform Histogram Equalization
% Here we perform histogram equalization to increase the contrast of an image by modifying the intensity distribution of the histogram
% Display the enhanced volume and histogram

histimage = histeq(normalized_brainMRI(:));
histimagenew = reshape(histimage,size(normalized_brainMRI));

figure(5)
imshow3D(histimagenew)
title ('Histogram equalization of brain MRI')
caxis('auto')
colorbar ('northoutside')

figure (6)
imhist(histimagenew)
title ('Histogram of histogram equalized brain MRI')
caxis('auto')
xlim([0.55 1.01])
ylim([0, 55000])
colorbar ('northoutside')

figure (7)
montage(histimagenew)
title ('Montage of histogram equalized brain MRI')

%% Denoise by Filtering    
%Convolve the image with an average filter (parameter=3)

filter = fspecial3('average',3);
denoised_mri = convn (cropimage, filter, 'same');

%% Perform Image Thresholding

y = hist(denoised_mri(:), 25);
[peak, l] = findpeaks(y);
image_threshold_mri = denoised_mri > peak(1);

figure(8)
imshow3D(image_threshold_mri)
title ('Denoised Threshold Image')

%% Convert the Segmentation to STL File
% Pad the volume with zeros using the padarray function
% Extract isosurface data from the image volume (isovalue=0.5)
    
paddedimage = padarray(image_threshold_mri,[2 2 2],'both');

figure(9)
isosurface(paddedimage,0.5)

stlimg = isosurface (paddedimage, 0.5);
stlwrite('Brain.stl', stlimg)

%% Perform Edge Detection Using the Sobel Method

%New scaled histogram eq. image
scaledbrainMRI = histimagenew .*800;
edgefactor = zeros (size(scaledbrainMRI)); 

for i = 1:117

    [~, threshold] = edge (scaledbrainMRI(:,:,i),'sobel');
     edgefactor(:,:,i) = edge (scaledbrainMRI(:,:,i),'sobel', threshold * 0.5);
end

figure(10)
imshow3D(edgefactor)
title ('Edge detection of scaled brain MRI')