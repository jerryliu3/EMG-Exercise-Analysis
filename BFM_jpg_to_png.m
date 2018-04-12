function success = jpg_to_png(crop, folder_name, listing)
    success = false;
    %% Zach Fishman and Jerry Liu edits - OBL lab - February 15 2018
    % Face & Skull photo scan project - 2D pictures -> 3D scan with
    % photogrammetry

    % [pathstr,nameonly,ext] = fileparts(listing(1).name) 

    %% Reading in images, into struct format to account for varying image sizes

    steps = size(listing,1);
    h = waitbar(0,'Reading Folder Images: Please wait...');
    for i = 1:1:size(listing,1)

        [pathstr,nameonly,ext] = fileparts(listing(i).name);
        imstruct(i).file_name = nameonly; %#ok<SAGROW>
        imstruct(i).info = imfinfo([folder_name '\' listing(i).name]);
        imstruct(i).img_original = imread( [folder_name '\' listing(i).name] ); %#ok<SAGROW>

        waitbar(i/steps)
    end
    close(h)

    %%

    steps = size(listing,1);
    h = waitbar(0,'Reading Folder Images: Please wait...');
    for i = 1:1:size(listing,1)

        if isfield(imstruct(i).info,'Orientation')
           orient = imstruct(i).info.Orientation;
           switch orient
             case 1
                %normal, leave the data alone
             case 2
                imstruct(i).img_original = imstruct(i).img_original(:,end:-1:1,:);         %right to left
             case 3
                imstruct(i).img_original = imstruct(i).img_original(end:-1:1,end:-1:1,:);  %180 degree rotation
             case 4
                imstruct(i).img_original = imstruct(i).img_original(end:-1:1,:,:);         %bottom to top
             case 5
                imstruct(i).img_original = permute(imstruct(i).img_original, [2 1 3]);     %counterclockwise and upside down
             case 6
                imstruct(i).img_original = rot90(imstruct(i).img_original,3);              %undo 90 degree by rotating 270
             case 7
                imstruct(i).img_original = rot90(imstruct(i).img_original(end:-1:1,:,:));  %undo counterclockwise and left/right
             case 8
                imstruct(i).img_original = rot90(imstruct(i).img_original);                %undo 270 rotation by rotating 90
             otherwise
                warning(sprintf('unknown orientation %g ignored\n', orient));
           end
         end

        waitbar(i/steps)
    end
    close(h)



    %% Image stack file size check

    varStats = whos('imstruct');
    varSize = varStats.bytes /1e6; %MB

    %% Choose main patient image - head on

    % [FileName,PathName] 
    patient_photo_file = uigetfile('*.jpg','Select a front-view photo of the patient');
    [patient_pathstr, patient_nameonly, ext] = fileparts(patient_photo_file);
    % patient_img = imread( [folder_name '\' listing(i).name] );

    % add imcrop manual or combine with face detection single check
    % combine with same as folder selection


    %% Image view check

    img_num = 1;
    img = imstruct(img_num).img_original;
    figure; imshow(img); axis image; title('Original image')

    % Face detection single image test

    detector = buildDetector();
    [bbox, bbimg, faces, bbfaces] = detectFaceParts(detector,img,2);

    figure;imshow(bbimg);
    axis image
    title('Detected Image: Faces, Eyes, Nose, Mouth')

    imstruct(img_num).bbox = bbox; %bounding box coordinate matrix for full image - see detectFaceParts.m for guide
    imstruct(img_num).bbimg = bbimg; %full image with all face parts detected & boxed
    imstruct(img_num).bbfaces = bbfaces; %cropped image to just face parts detected & boxed
    imstruct(img_num).faces = faces; %cropped image to just face parts detected, not boxed

    for i=1:size(faces,1)
        figure;imshow(faces{i});
    end

    for i=1:size(bbfaces,1)
        figure;imshow(bbfaces{i});
    end

    %% Face detection full image library

    detector = buildDetector();

    steps = size(listing,1);
    h = waitbar(0,'Detecting Faces in Images: Please wait...');
    for i = 1:1:size(listing,1)

        [imstruct(i).bbox, imstruct(i).bbimg, imstruct(i).faces, imstruct(i).bbfaces] = detectFaceParts(detector, imstruct(i).img_original, 2);

    %     figure; imshow(imstruct(i).bbimg);

        waitbar(i/steps)
    end
    close(h)

    %%

    i = 1; % picture #
    j = 1; % face #

    figure; imshow(imstruct(i).bbimg);
    set(gcf,'WindowStyle','docked') % 'normal'
    title(['Image:', imstruct(i).file_name, ', Original:' num2str(j) ])

    figure; imshow(imstruct(i).faces{j});
    set(gcf,'WindowStyle','docked') % 'normal'
    title(['Image:', imstruct(i).file_name, ', Face:' num2str(j) ])

    % Igray = rgb2gray(imstruct(i).faces{j});
    % figure; imshow(Igray);
    % set(gcf,'WindowStyle','docked') % 'normal'

    %% Convert to grayscale images

    % steps = size(listing,1);
    % h = waitbar(0,'Displaying Faces in Images: Please wait...');
    % for i = 1:1:size(listing,1)
    %     for j = 1:size(imstruct(i).faces,1)
    %         imstruct(i).faces_gray{j} = rgb2gray(imstruct(i).faces{j});
    %     end
    %     waitbar(i/steps)
    % end
    % close(h)

    %%
    steps = size(listing,1);
    h = waitbar(0,'Displaying Faces in Images: Please wait...');
    for i = 1:1:size(listing,1)
    % for i = 1:3

    %     figure;
    %     imshow(imstruct(i).bbimg);
    %     set(gcf,'WindowStyle','docked') % 'normal'
    %     if isempty(imstruct(i).bbox)
    %        title('No Face Found') 
    %     else
    %        title('Face Detected')
    %     end

        for j = 1:size(imstruct(i).faces,1)
            figure;imshow(imstruct(i).faces{j});
            set(gcf,'WindowStyle','docked') % 'normal'
            title(['Image:', imstruct(i).file_name, ', Face:' num2str(j) ])
        end

    %     for j = 1:size(imstruct(i).faces,1) % Greyscale
    %         figure;imshow(imstruct(i).faces_gray{j});
    %         set(gcf,'WindowStyle','docked') % 'normal'
    %         title(['Image:', imstruct(i).file_name, ', Face:' num2str(j) ])
    %     end

        for j = 1:size(imstruct(i).bbfaces,1)
            figure;imshow(imstruct(i).bbfaces{j});
            set(gcf,'WindowStyle','docked') % 'normal'
            title(['Image:', imstruct(i).file_name, ', Face:' num2str(j) ])
        end
    %     
        waitbar(i/steps)
    end
    close(h)
    if(crop)
        %% Export: Writing out Cropped Face Images into subfolder

        mkdir([folder_name '\CropFaces']);
        % mkdir([folder_name '\Mikhail_CropFaces']);

        formatSpec = '0%g'; 

        steps = size(listing,1);
        h = waitbar(0,'Writing Face Images: Please wait...');
        counter = 0;
        for i = 1:1:size(listing,1)

            for j = 1:size(imstruct(i).faces,1)
        %         figure;imshow(imstruct(i).faces{j});
                counter = counter + 1;
                file_name = [char(extractAfter(folder_name, 'data\')) num2str(counter)];
                mkdir([folder_name '\results']);
                mkdir([folder_name '\results\' num2str(counter)]);
                cropped_image = imresize(imstruct(i).faces{j}, [512 NaN]);
        %         imwrite(imstruct(i).faces{j}, [folder_name '\Mikhail_CropFaces\Image' imstruct(i).file_name '_Face_', num2str((j),formatSpec),'.jpg'], 'jpg' );
                imwrite(cropped_image, [folder_name '\CropFaces\' file_name,'.png'], 'png' );

            end

            waitbar(i/steps)
        end
        close(h)
    else
        %% Export: Writing out Face Images into subfolder

        mkdir([folder_name '\Faces']);
        % mkdir([folder_name '\Mikhail_CropFaces']);

        formatSpec = '0%g'; 

        steps = size(listing,1);
        h = waitbar(0,'Writing Face Images: Please wait...');
        counter = 0;
        for i = 1:1:size(listing,1)

            for j = 1:size(imstruct(i).faces,1)
        %         figure;imshow(imstruct(i).faces{j});
                counter = counter + 1;
                file_name = [char(extractAfter(folder_name, 'data\')) num2str(counter)];
                cropped_image = imstruct(i).img_original;
        %         imwrite(imstruct(i).faces{j}, [folder_name '\Mikhail_CropFaces\Image' imstruct(i).file_name '_Face_', num2str((j),formatSpec),'.jpg'], 'jpg' );
                imwrite(cropped_image, [folder_name '\Faces\' file_name,'.png'], 'png' );

            end

            waitbar(i/steps)
        end
        close(h)
    end
    %%

    % img_num = 11;
    % img = imstruct(img_num).img_original;
    % 
    % faceLBPDetector = vision.CascadeObjectDetector('FrontalFaceLBP');
    % bboxes = step(faceLBPDetector, img);
    % 
    % IFaces = insertObjectAnnotation(img, 'rectangle', bboxes, 'Face');
    % figure, imshow(IFaces), title('Detected faces');

    %%

    % ProfileFaceDetector = vision.CascadeObjectDetector('ProfileFace');
    % bboxes = step(ProfileFaceDetector, img);
    % 
    % IProfileFace = insertObjectAnnotation(img, 'rectangle', bboxes, 'ProfileFace');
    % figure, imshow(IProfileFace), title('Detected ProfileFace');
    success = true;
end