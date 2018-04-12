%% run entire BFM workflow 
success = false;
%% initializations
clear;  %clear workspace variables
close all;
clc;    %clear Command Window

format short g      % for number formatting
format compact
warning('off', 'Images:initSize:adjustingMag');

root_path = [fileparts(which(mfilename)) '\'];

%% case specific variables
%names = ["Jerry"];
%names = ["jerry", "andrew", "zach", "josh", "hanieh", "normand", "earvin", "kathak", "tom", "stewart"];
names = ["jerry"];
photos = ["1"];
path_to_fitscript = 'C:\Users\window\IdeaProjects\FinalCodeRefactored\';

fileID = fopen('names.txt', 'w');
fprintf(fileID, '%s\r\n', int2str(names.length));
for i=1:names.length
    fprintf(fileID, '%s\r\n', char(names(i)));
end
for i= 1:photos.length
    fprintf(fileID, '%s\r\n', char(photos(i)));
end
fclose(fileID);

%% prepare images for fitting

for i = 1:names.length
    folder_name = [path_to_fitscript 'data\' lower(char(names(i)))];
    %folder_name = uigetdir();
    index = strfind(folder_name, '\');
    person_name = extractAfter(folder_name, index(end));

    BFM_prepare_images(folder_name);
    image_path = [folder_name '\CropFaces\'];
    cd(image_path);
    copyfile * ..;
    cd(root_path);
end
%% call fitting algorithm
cd(path_to_fitscript);
[status] = dos('sbt assembly', '-echo');
delete executable.jar
movefile target\scala-2.12\executable.jar;
[status] = dos('java -Xmx4g -jar executable.jar', '-echo');
disp('Ready to perform registration');
cd(root_path);

%% perform registration
%names = ["Jerry"];
%images = ["1", "2", "2_cropped", "3", "3_cropped", "4"];
images = photos;
iterations = ['*'];
type = 'builtin';
landmarks = '41';

%script to perform the registration and save the error calculations
%registration is based on the assumption that the output model from BFM is
%not altered in any way, and that the scan is done through the default
%methods on the EinScan and the nose is the minimum y value after rotation

BFM_FaceVsFace_withICP(landmarks, names, images, type, iterations);
%% put all the data together

BFM_compile_error(landmarks, names, images, iterations, type);

%% plot and save the compiled data into one struct
[xdata, ydata] = BFM_plot_compiled_error(landmarks, names, type);

%% analysis of data
%ydata = BFM_statistical_analysis_avg(ydata);

%[p, t, stats] = anova1(ydata.overall_avg);
%[c, m, h, nms] = multcompare(stats);

%%
success = true
