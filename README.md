# Brain MRI Segmentation and Modeling
The following MATLAB file reads in a brain MRI, segments it, and generates an STL model ready for 3D printing. This was a lab assignment during my time at the Johns Hopkins Applied Biomedical Engineering program. 

First, we have to load the image and crop out extraneous black pixels. We do this by obtain the min and max coordinates of all dimensions with pixels that aren't black. Crop the image accordindgly. 

![](https://raw.githubusercontent.com/aznxed/brain-mri-segmentation/master/img/Montage%20of%20Normalized%20Brain%20MRI.png)

Susequently, we normalize the image and perform histogram equalization to increase the contrast of an image by modifying the intensity distribution of the histogram.

![](https://raw.githubusercontent.com/aznxed/brain-mri-segmentation/master/img/Histogram%20Equalized%20Brain%20MRI.png)

We then denoise the image by convolving the image with an average filter. Finally, we perform image thresholding, padding, and generate an isosurface from the slices. 

![](https://raw.githubusercontent.com/aznxed/brain-mri-segmentation/master/img/Brain%20Isosurface.png)

**Upcoming**

As a current student at the Alabama College of Osteopathic Medicine, I will be 3D printing the STL file and using it to study for neuroanatomy. Hopefully, the resolution is sufficient. 

**Credit**

Lab was completed along with Kenneth Weintraub, Jackie Woznicki, and Krupali Patel. 
imshow3D was created by Maysam Shahedi and can be found [here](https://www.mathworks.com/matlabcentral/fileexchange/41334-imshow3d)
