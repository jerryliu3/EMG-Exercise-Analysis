function success = BFM_FaceVsFace_withICP(landmarks, names, images, type, number_iterations)
%% Run this script to compare a 3D facescan (Einscan) to an EXPORTED 3D Face Model
% This script will measure Euclidian distances between 2 face sufaces
% The noICP assumes that the 2 faces are already aligned & registered in
% another program prior to this measurment

% created by Joshua Pope July 13,2017
% Modified by Zach Fishman Feb 12,2018
% Modified by Jerry Liu March 20,2018
%%
set(0,'DefaulttextInterpreter','none'); % so underscore in title doesn't format as subscripts vs. Interpreter 'Tex'

set(0,'DefaultFigureWindowStyle','docked')
% set(0,'DefaultFigureWindowStyle','normal')

%% Select 3D scan file to be read into Matlab workspace - True Face

% [scan_PathName,scan_FileName] = uigetfile('*.ply','Select the PLY 3D scan data file');

% Zach Compare
% scan_PathName = 'C:\Users\Zach\Google Drive\OBL lab - Summer 2017 research\Face_Einscan_data_projects\Zach\';
% scan_FileName = 'zach_face_crop_repair.ply';

% Jerry Compare
% scan_PathName = 'G:\Dropbox\IBBME\Face Morph Models\FaceVsFace\';
% scan_PathName = 'G:\Dropbox\IBBME\Co Op Student 2018 - Jerry\';
scan_PathName = ['OBL_scans_updated\'];
for name_counter = 1:size(names, 2)
    name = char(names(name_counter));
    scan_FileName = [name '\' name '_face_crop_repair_aligned.ply'];
    for image_counter = 1:size(images, 1)
        image = char(images(image_counter));
        % scan_FileName = 'Jerry_face_crop_repair_rot.ply';
        % scan_FileName = 'Jerry_face_crop_repair_rot_crop2.ply';
        % scan_FileName = 'Jerry_face_crop_repair_rot_crop2_align2.ply';
        % scan_FileName = 'Jerry_face_crop_repair_rot_crop2_align_jerry8.ply';
        
        % scan_FileName = 'Mikail_face_crop_repair_align_mikhail3_10000.ply';
        
        %% Select 3D MODEL file to be read into Matlab workspace - Model Face
        
        % [model_PathName, model_FileName] = uigetfile('*.ply','Select the PLY 3D scan data file');
        
        % Jerry Model
        % model_PathName = 'G:\Dropbox\IBBME\Face Morph Models\FaceVsFace\';
        model_PathName = [name '\results\' image '\'];
        
        % model_FileName = 'Jerry_10000_img3.ply';
        % model_FileName = 'Jerry_10000_img3_crop2.ply';
        % model_FileName = 'Jerry_10000_img3_crop2_align2.ply';
        % model_FileName = 'jerry8_10000_combined_repair.ply';
        
        %turn all meshes into .ply to compare, but this is very slow so when it is
        %not being used, make sure to comment it out
        
        
        
        %folder = dir(fullfile([model_PathName '*_' type '.ply']));
%         iterations = new_dir(fullfile([model_PathName '*' lower(name) '_' image '_' number_iterations '_' type '.ply']));
%         stl_count = new_dir(fullfile([model_PathName '*' lower(name) '_' image '_' number_iterations '_' type '.stl']));
%         if(length(stl_count) > length(iterations))
%             writeMeshToPly(model_PathName);
%             iterations = new_dir(fullfile([model_PathName '*' lower(name) '_' image '_' number_iterations '_' type '.ply']));           
%         end
        iterations = new_dir(fullfile([model_PathName '*' lower(name) '_' image '_' number_iterations '_' type '.stl']));
        % for counter = 1:2:1
        for counter = 1:length(iterations)
            
            %model_FileName = 'jerry_3_cropped_10000_builtin_crop.ply';
            %scan_FileName = ['Jerry_face_crop_repair_BFM_align_crop_' model_FileName(1:length(model_FileName)-4) '.ply'];
            
            %model_FileName = scan_FileName(strfind(scan_FileName, lower(name)):end);
            model_FileName = iterations(counter).name;
            disp(strcat('working on  ', model_FileName));
            %% Read PLY with file exchange code % from plyUtilities https://www.mathworks.com/matlabcentral/fileexchange/55968-ply-file-utilities
            % note: the color values array seems to export different from MeshLab than
            % from MeshMixer software. PlyRead_ZF currently reads export from MeshLab.
            if(image_counter == 1 && counter == 1)
            [scan_verts, scan_faces, scan_vert_color] = plyRead_ZF( [scan_PathName, scan_FileName] , 1); % from plyUtilities
            scan_vert_color_normalized = scan_vert_color/255; %normalize the vert color data
            %% Rotate face & Visualize the 3D Scan Ply file
            
            % Flip X & Y, invert Z so scene orientation match EOS model
            scan_verts2 = [scan_verts(:,2), -scan_verts(:,3), scan_verts(:,1)];
            
            % Centre to match scene of BFM Face Model, origin based on tip of nose
            [nose_ymax, nose_pt] = min(scan_verts2(:,2)); %nose_pt is the index (position)
            nose_origin = scan_verts2(nose_pt,:);

            % Re-zero vertices so origin is on nose tip
            scan_verts2 = [scan_verts2(:,1) - nose_origin(1), scan_verts2(:,2) - nose_origin(2), scan_verts2(:,3) - nose_origin(3)];
            
            TR_scan = triangulation(scan_faces, scan_verts2);
            end
            %%
            
            % Read PLY with file exchange code % from plyUtilities https://www.mathworks.com/matlabcentral/fileexchange/55968-ply-file-utilities
            %[model_verts, model_faces, model_vert_color] = plyRead_ZF( [model_PathName, model_FileName] , 1); % from plyUtilities
            %model_vert_color_normalized = model_vert_color/255; %normalize the vert color data
            [model_faces, model_verts] = stlread([model_PathName, model_FileName]);
            [model_faces, model_verts] = reducepatch(model_faces, model_verts, 1);
            %%
            
            % iColor_skin = [1 ,0.75,0.65]; %caucasian skin tone old
            iColor_skin = [1 ,0.878,0.741]; %caucasian skin tone new
            
            skin_asian = [199 151 120]/255;
            skin_cauasian = [227 176 149]/255;
                       
            %% Rotate face & Visualize the 3D Model Ply file
            
            % Flip X & Y, invert Z so scene orientation match EOS model
            model_verts2 = [model_verts(:,1), -model_verts(:,3), model_verts(:,2)];
            
            % Centre to match scene of BFM Face Model, origin based on tip of nose
            [nose_ymax, nose_pt] = min(model_verts2(:,2)); %nose_pt is the index (position)
            nose_origin = model_verts2(nose_pt,:);            

            % Re-zero vertices so origin is on nose tip
            model_verts2 = [model_verts2(:,1) - nose_origin(1), model_verts2(:,2) - nose_origin(2), model_verts2(:,3) - nose_origin(3)];            
            
            TR_model = triangulation(model_faces, model_verts2);
            
            %% Visualize the 3D Scan & Model together with translucency
            
            % Plot face surface with vertex colors at new origin
            figure;
            % patch('Faces',scan_faces,'Vertices',scan_verts2,'FaceColor','interp','FaceVertexCData',scan_vert_color_normalized,'edgecolor','none');
            % patch('Faces',scan_faces,'Vertices',scan_verts2,'FaceColor','interp','FaceVertexCData',scan_vert_color_normalized,'edgecolor','none', 'FaceAlpha', 0.5);
            patch('Faces',scan_faces,'Vertices',scan_verts2,'FaceColor',skin_asian,'edgecolor','none');
            
            hold on
            patch('Faces',model_faces,'Vertices',model_verts2,'FaceColor', [0.5 0.5 0.5],'edgecolor','none');
            % patch('Faces',model_faces,'Vertices',model_verts3,'FaceColor', [0.5 0.5 0.5],'edgecolor','none', 'FaceAlpha', 0.5);
            
            xlabel('X'); ylabel('Y'); zlabel('Z'); grid on;
            title('3D Face Scan vs Model')
            axis image; grid on;
            
            view(3) %az = –37.5, el = 30.
            % view([90 0 0]) % profile sideways % fix XYZ so profile is up & down
            % view([0 0 90]) % top view
            % view([0 90 0]) % back view
            % view([0 -90 0]) % front view
            
            
            camlight(0,0);
            % camlight(-37.5,30);
            
            % camlight right;
            camlight('headlight');
            lighting gouraud; material dull;
            
            % camproj('perspective')
            camproj('orthographic')
            %% edited section that is adding registration to the no ICP code
            Options.gamm = 1;
            Options.epsilon = 1;
            Options.lamda = 1;
            Options.alphaSet = 1;
            Options.biDirectional = 1;
            Options.useNormals = 0;
            Options.plot = 0; %note that plotting is turned off
            Options.rigidInit = 1;

            tic %this will take a couple minutes to register 

            %chose which model you would like to rigidly register
            
            %% get subsections
            
            [face_sub] = getSubsections(scan_verts2, 'male');
            
            %%         
            
            Source.vertices = scan_verts2;
            Source.faces = scan_faces;
            TR_scan2 = triangulation(Source.faces,Source.vertices);
            
            %Source.vertices = face_sub(11).verts;
            scan_faces2 = vertexAttachments(TR_scan2, face_sub(11).ind);
            Source.faces = unique( TR_scan2([scan_faces2{:}],:) ,'rows');
%             model_faces3 = [];
%             for x = 1:length(model_faces)
%                    if(~(any(ismember(model_faces(x, :),face_sub(11).ind'))==0))
%                    model_faces3 = [model_faces3; model_faces(x, :)];
%                    end
%             end
%             Source.vertices = face_sub(11).verts;
            Source.vertices = scan_verts2;

%%

            % Plot face surface with vertex colors at new origin
            figure;
            patch('Faces',Source.faces,'Vertices',Source.vertices,'FaceColor',skin_asian,'edgecolor','none');
     
            xlabel('X'); ylabel('Y'); zlabel('Z'); grid on;
            title('3D Face - MidFace')
            axis image; grid on;
            
            view(3) %az = –37.5, el = 30.
            % view([90 0 0]) % profile sideways % fix XYZ so profile is up & down
            % view([0 0 90]) % top view
            % view([0 90 0]) % back view
            % view([0 -90 0]) % front view
            
            camlight(0,0);
            % camlight(-37.5,30);
            
            % camlight right;
            camlight('headlight');
            lighting gouraud; material dull;
            
            camproj('orthographic')



%%

            TR_scan2 = triangulation(Source.faces,Source.vertices);

            %the target will alawys be the loaded scan chosen above
            Target.vertices = model_verts2;
            Target.faces = model_faces;

            %MODEL IS SOURCE
            Source.normals = vertexNormal(TR_scan2);
            %TARGET IS SCAN
            Target.normals = vertexNormal(TR_model);

            %OUTPUT IS SOURCE TRANSFORMED TO CORRECT TILT OF HEAD
            [ vertsTransformed_centreface, X_centreface, D_centreface, R, t ] = Rigid_icp_JP(Source, Target, Options); % as Josh had set up
            fprintf('Complete rigid registration \n')
            % this works properly, now if you plot vertsTransformed with
            % Source.faces then it will plot the rotated centre face to
            % match the target. Now just need to apply the same rotations
            % and transformation onto the entire face
            toc
            %this part takes a very long time
            tic
            
            vertsSource = scan_verts2;
            nVertsSource = size(vertsSource, 1);

            % Set matrix D (equation (8) in Amberg et al.)
            D_fullface = sparse(nVertsSource, 4 * nVertsSource);
            for i = 1:nVertsSource
                D_fullface(i,(4 * i-3):(4 * i)) = [vertsSource(i,:) 1];
            end         
            X_fullface = repmat([R'; t'], nVertsSource, 1);
            vertsTransformed_fullface = D_fullface*X_fullface;
            %X_fullface2 = repmat([[R'; t']';[0 0 0 1]]', nVertsSource, 1);            
            %vertsTransformed_fullface2 = transformPointsInverse(X_fullface2, D_fullface);
            %vertsTransformed_fullface3 = transformPointsInverse(D_fullface*X_fullface;
            
            Source.faces = scan_faces;
            Source.vertices = vertsTransformed_fullface;
            scan_verts2 = vertsTransformed_fullface;
            TR_scan = triangulation(Source.faces,Source.vertices);
            toc    
            %% Compute the distance using nearest neighbour and sign using dot product of vertex normal and the nearestneighbour distance
            
            
            %MODEL IS SOURCE
            model_normals = vertexNormal(TR_model);
            %TARGET IS SCAN
            scan_normals = vertexNormal(TR_scan);
            
            tic
            
            %find the index and absolute distance between each vertex on the model and the true face (einscan)
            [vertex_i, distance_neighbour_modeltoscan] = nearestNeighbor(TR_model, Source.vertices);
            % model_verts2 = model_verts2;
            
            % [vertex_i, distance_neighbour_modeltoscan] = nearestNeighbor(TR_scan, vertsTransformed);
            
            % make a new variable to store the signed distances
            %     distance_mod2scan = zeros(3448,1);
            
            for i=1:length(Source.vertices)
                
                %compute the X Y and Z component subtractions
                distanceX = Source.vertices(i, 1) - model_verts2(vertex_i(i), 1);
                distanceY = Source.vertices(i, 2) - model_verts2(vertex_i(i), 2);
                distanceZ = Source.vertices(i, 3) - model_verts2(vertex_i(i), 3);
                
                %calculate euclidian length
                len = sqrt(distanceX^2 + distanceY^2 + distanceZ^2);
                
                % distance vector betweenscan and model with tail at scan and head at model
                vec = [distanceX distanceY distanceZ];
                
                %use the normal vector dot with the distance to find the sign
                n = [ scan_normals(i,1) scan_normals(i,2) scan_normals(i,3)];
                dotprod = dot(n, vec);
                sgn = sign(dotprod);
                
                %length calculated above * sign determined by dot product
                D = len*sgn;
                
                %         distance_mod2scan(i,1) = D; %row,column
                distance_mod2scan(i,1) = D;
                %distance_mod2scan = distance_mod2scan(distance_mod2scan > -8);
                
                for p=1:3
                    %store the vector distance for each point on the model to the scan for plotting later using quiver
                    nearestneighbourVec(i,p) = vec(p);
                    
                    %store the nearest point on source scan
                    nearestPointOnSourceScan(i,p) = model_verts2(vertex_i(i),p);
                end
                
            end
            
            toc
            
            % clear len; clear distanceX; clear distanceY; clear distanceZ; clear k;
            % clear vec; clear sgn; clear dotprod; clear len; clear n; clear i; clear D; clear p;
            % clear vertex_i
            
            
            %% Compare distance with the BFM face model
            
            
            figure;
            set(gcf,'WindowStyle','docked') %'normal' to undock?
            
            %   plot scan with full face data and filled in texture
            % patch(PlotTarget,'FaceColor','interp','FaceVertexCData', scan_vert_color_normalized,'edgecolor','none',  'FaceAlpha', 0.7);
            % hold on
            
            %     plot scan with transparency green
            %  patch(PlotTarget,'FaceColor','black','edgecolor','none', 'FaceAlpha', 0.5);
            %     hold on
            
            % patch('Faces', model_faces ,'Vertices', model_verts2 ,'FaceColor','interp','FaceVertexCData', distance_mod2scan  ,'EdgeColor','none');
            % %     patch('Faces',combinedModels(i).Source.faces ,'Vertices',combinedModels(i).vertsTransformed ,'FaceColor','interp','FaceVertexCData',combinedModels(i).distance_mod2scan  ,'EdgeColor','none');
            
            %    showPointCloud(combinedModels(i).vertsTransformed , 'Markersize', 600 );
            %     title(['St Dev: ' num2str(distance_std) ' mm for Combination: ' combinedModels(i).Type]);
            % patch('Faces', Source.faces ,'Vertices', vertsTransformed ,'FaceColor','interp' ,'EdgeColor','none');
            
            patch('Faces', Source.faces ,'Vertices', Source.vertices ,'FaceColor','interp','FaceVertexCData', distance_neighbour_modeltoscan  ,'EdgeColor','none');
            
            
            hold on
            
            % pt 3421 is the nose point with no deviation in position between
            % models. this becasue the nose tip has been set to 0,0,0 in the
            % image2eosmodel_JP function
            %     scatter3(combinedModels(i).vertsTransformed(3421,1), combinedModels(i).vertsTransformed(3421,2), combinedModels(i).vertsTransformed(3421,3), 'r*')
            
            %from model to scan
            
            %     quiver3(combinedModels(i).vertsTransformed(:,1),combinedModels(i).vertsTransformed(:,2),combinedModels(i).vertsTransformed(:,3),-combinedModels(i).nearestneighbourVec(:,1),-combinedModels(i).nearestneighbourVec(:,2),-combinedModels(i).nearestneighbourVec(:,3), 0)
            %     from scan to model
            %     quiver3(combinedModels(i).nearestPointOnSourceScan(:,1),combinedModels(i).nearestPointOnSourceScan(:,2),combinedModels(i).nearestPointOnSourceScan(:,3),combinedModels(i).nearestneighbourVec(:,1),combinedModels(i).nearestneighbourVec(:,2),combinedModels(i).nearestneighbourVec(:,3), 0)
            
            
            hbar = colorbar; ylabel(hbar,'Distance Offset (mm)','FontSize',12);
            % colormap redblue
            % caxis([-5 5])
            
            colormap jet
            caxis([0 5])
            
            % caxis([-10 10])
            
            axis image; grid on;
            xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
            
            %     view([90 -90 180]); axis image;
            %     view([0 -90]); axis image;axis ij;
            
            % view([90 0 0]); %XZ view
            % view([90 -90 180]);
            
            view([0 -90 0]) % front view
            % view([0 0 -90]); axis ij % back view
            
            %in order to flip image
            %axis ij
            %axis xy
            
            % camlight right; camlight('headlight');
            camlight(0,0)
            lighting gouraud; material dull;
            
            distance_std = std( distance_mod2scan );
            title(['St Dev: ' num2str(distance_std) ' mm ']);
            
            % clear i; clear distance_std
            saveas(gcf, [model_PathName model_FileName(1:length(model_FileName)-4) '_error.png']);
            %change to export_fig in the future because it is much better and has more
            %options
            %% Calculate Statistics/Histogram from distance Data
            
            
            distance_mean = mean(distance_mod2scan);
            distance_std = std(distance_mod2scan);
            distance_median = median(distance_mod2scan);
            
%             figure
%             set(gcf,'WindowStyle','docked') %'normal' to undock?
%             hist(distance_mod2scan, length(distance_mod2scan)) %chose bin count here
%             xlabel('Distance offset (mm)'); ylabel('Count');
%             %     xlim([-10 10])
%             title(['Distance Histogram - St Dev: ' num2str(distance_std)])
%             
%             % clear i;
            
            %%
            
            %return
            
            %%
            [face_sub] = getSubsections(Source.vertices, 'male');
            
            %%
            
            for i = 1:length(face_sub)
                
                face_sub(i).dist_NN_sgn_sub = distance_mod2scan(face_sub(i).ind);
                face_sub(i).dist_NN_sgn_sub_avg = mean(face_sub(i).dist_NN_sgn_sub);
                face_sub(i).dist_NN_sgn_sub_std = std(face_sub(i).dist_NN_sgn_sub);
                
                face_sub(i).dist_NN_abs_sub = distance_neighbour_modeltoscan(face_sub(i).ind);
                face_sub(i).dist_NN_abs_sub_avg = mean(face_sub(i).dist_NN_abs_sub);
                face_sub(i).dist_NN_abs_sub_std = std(face_sub(i).dist_NN_abs_sub);
                face_sub(i).dist_NN_abs_sub_rms = rms(face_sub(i).dist_NN_abs_sub);
                
            end
            
            
            %% Compare distance with the EOS face model - ABSOLUTE - REGION
            
            % face_sub(1).name = 'forehead';
            % face_sub(2).name = 'right_eye';
            % face_sub(3).name = 'left_eye';
            % face_sub(4).name = 'nose';
            % face_sub(5).name = 'right_cheek';
            % face_sub(6).name = 'left_cheek';
            % face_sub(7).name = 'mouth';
            % face_sub(8).name = 'chin';
            % face_sub(9).name = 'mid_face';
            % face_sub(10).name = 'outer_face';
            % face_sub(11).name = 'center_face';
            
            sub = 11;
            figure;
            showPointCloud(face_sub(sub).verts, face_sub(sub).dist_NN_abs_sub, 'Markersize', 500 );
            
            % hold on
            % patch('Faces',scan_faces,'Vertices',scan_vertices_flip,'FaceColor',[0.5 0.5 0.5],'edgecolor','none', 'FaceAlpha', 0.4); %scan
            % patch(PlotTarget2,'FaceColor','interp','FaceVertexCData',vert_color_normalized,'edgecolor','none');
            % patch('Faces',scan_faces,'Vertices',scan_vertices_flip,'FaceColor',[0.5 0.5 0.5],'edgecolor','none'); %scan
            
            % the following one is glitchy:
            % patch('Faces', correctValFaces, 'Vertices', vertsT_1cm2,'FaceColor','interp','FaceVertexCData',distance_NN_sgn_new,'EdgeColor','none'); % this is glitchy
            distance_abs_std = face_sub(sub).dist_NN_abs_sub_std;
            distance_abs_rms = face_sub(sub).dist_NN_abs_sub_rms;
            title(['Avg: ' num2str( face_sub(sub).dist_NN_abs_sub_avg) ' mm ± St Dev: ' num2str(distance_abs_std) ' mm | RMS: ' num2str(distance_abs_rms) ' mm']);
            
            axis image; grid on;
            hbar = colorbar; ylabel(hbar,'Distance Offset (mm)','FontSize',12);
            colormap jet
            caxis([0 5])
            
            xlabel('X (mm)'); ylabel('Y (mm)'); zlabel('Z (mm)');
            
            % view(3)
            % view([90 0 0]); %side view
            view([0 -90 0]) %back
            % view([0 90 0]) %front
            
            camlight right; camlight('headlight');
            lighting gouraud; material dull;
            
            %     camproj('perspective')
            camproj('orthographic')
            
            %     set (gcf, 'Units', 'normalized', 'Position', [0,0,1,1]);    %to maximize window
            %     export_fig(['Compare_'], '-png', '-transparent' ,'-p 0.5',figure) % no padding & transparent
            
            
            %% Calculate Statistics/Histogram from distance Data - Signed
            
            distance_mod2scan_10 = distance_mod2scan(distance_mod2scan>-10 & distance_mod2scan<10);
            
            
%             figure;
%             % distance_NN_sgn_new = zeros(length(distance_mod2scan),1);
%             % distance_std_new = std(distance_NN_sgn_new);
%             
%             hist(distance_mod2scan_10, length(distance_mod2scan_10)) %chose bin count here
%             title(['Distance Histogram for Signed: St Dev: ' num2str(std(distance_mod2scan_10))])
%             xlabel('Distance offset (mm)'); ylabel('Count');
%             % xlim([-5 5])
%             
%             [N,edges] = histcounts(distance_mod2scan_10);
%             pd = fitdist(distance_mod2scan_10,'Normal');
%             y = pdf(pd, edges);
%             
%             figure;
%             h = histogram(distance_mod2scan_10,'Normalization','pdf','EdgeColor','none','FaceColor',[0.5 0.5 0.5]);
%             title(['Histogram - StDev: ',num2str(std(distance_mod2scan_10)),  ' mm']);
%             xlabel('Distance Offset (mm)'); %ylabel('Counts (#)');
%             hold on; plot(edges, y, 'b-', 'LineWidth', 4)
%             % xlim([-5 5])
            
            %% Calculate Statistics/Histogram from distance Data - Absolute
            
            distance_NN_abs_new = distance_neighbour_modeltoscan;
            distance_abs_avg = mean(distance_NN_abs_new);
            distance_abs_std = std(distance_NN_abs_new);
            distance_abs_rms = rms(distance_NN_abs_new);
            
%             figure;
%             hist(distance_NN_abs_new, length(distance_NN_abs_new)) %chose bin count here
%             xlabel('Distance offset (mm)'); ylabel('Count');
%             xlim([0 5])
%             title(['Distance Histogram for Absolute: Avg: ' num2str(distance_abs_avg) ' mm ± St Dev: ' num2str(distance_abs_std) ' mm | RMS: ' num2str(distance_abs_rms) ' mm']);
%             
%             [N,edges] = histcounts(distance_NN_abs_new);
%             pd = fitdist(distance_NN_abs_new,'Normal');
%             y = pdf(pd, edges);
%             
%             figure;
%             h = histogram(distance_NN_abs_new,'Normalization','pdf','EdgeColor','none','FaceColor',[0.5 0.5 0.5]);
%             title(['Distance Histogram for Absolute: Avg: ' num2str(distance_abs_avg) ' mm ± St Dev: ' num2str(distance_abs_std) ' mm | RMS: ' num2str(distance_abs_rms) ' mm']);
%             xlabel('Distance Offset (mm)'); %ylabel('Counts (#)');
%             hold on; plot(edges, y, 'b-', 'LineWidth', 4)
%             xlim([0 5])
            
            %% Histogram with Cumulative distribution
            
            % [N,edges] = histcounts(distance_NN_abs_new);
            % pd = fitdist(distance_NN_abs_new,'Normal');
            % y_pdf = pdf(pd, edges);
            % y_cdf = cdf(pd, edges);
            %
            % figure;
            % h = histogram(distance_NN_abs_new,'Normalization','pdf','EdgeColor','none','FaceColor',[0.5 0.5 0.5]);
            % title(['Distance Histogram for Absolute: Avg: ' num2str(distance_abs_avg) ' mm ± St Dev: ' num2str(distance_abs_std) ' mm | RMS: ' num2str(distance_abs_rms) ' mm']);
            % xlabel('Distance Offset (mm)'); %ylabel('Counts (#)');
            % hold on;
            % % plot(edges, y_pdf, 'b-', 'LineWidth', 4)
            % % plot(edges, y_cdf, 'g--', 'LineWidth', 4)
            %
            % [HAX,HY1,HY2] = plotyy(edges,y_pdf, edges,y_cdf);
            % HY1.LineStyle = '-'; HY2.LineStyle = '--';
            % HY1.LineWidth = 4; HY2.LineWidth = 4;
            % HY1.Color = 'b'; HY2.Color = 'g';
            % HAX(1).YColor = 'b'; HAX(2).YColor = 'g';
            % ylabel(HAX(1),'PDF') % left y-axis
            % ylabel(HAX(2),'CDF') % right y-axis
            % xlim([0 5])
            
            %% Histogram with Cumulative distribution
            
            % [N,edges] = histcounts(distance_NN_sgn_new);
            % pd = fitdist(distance_NN_sgn_new,'Normal');
            % y_pdf = pdf(pd, edges);
            % y_cdf = cdf(pd, edges);
            %
            % figure;
            % h = histogram(distance_NN_sgn_new, edges, 'Normalization','pdf','EdgeColor','none','FaceColor',[0.5 0.5 0.5]);
            % title(['Distance Histogram for Absolute: Avg: ' num2str(distance_abs_avg) ' mm ± St Dev: ' num2str(distance_abs_std) ' mm | RMS: ' num2str(distance_abs_rms) ' mm']);
            % xlabel('Distance Offset (mm)'); %ylabel('Counts (#)');
            % hold on;
            % % plot(edges, y_pdf, 'b-', 'LineWidth', 4)
            % % plot(edges, y_cdf, 'g--', 'LineWidth', 4)
            %
            % [HAX,HY1,HY2] = plotyy(edges,y_pdf, edges,y_cdf,'plot');
            % HY1.LineStyle = '-'; HY2.LineStyle = '--';
            % HY1.LineWidth = 4; HY2.LineWidth = 4;
            % HY1.Color = 'b'; HY2.Color = 'g';
            % HAX(1).YColor = 'b'; HAX(2).YColor = 'g';
            % ylabel(HAX(1),'PDF') % left y-axis
            % ylabel(HAX(2),'CDF') % right y-axis
            % xlim([-5 5])
            
            
            
            %% Full face data export
            
            model_FileName
            
            export_data = [distance_abs_avg, distance_abs_std, distance_abs_rms, distance_std]
            
            export_face_sub = rmfield(face_sub, {'ind'; 'verts'; 'dist_NN_sgn_sub'; 'dist_NN_abs_sub'} );
            
            temp = struct2cell(export_face_sub);
            table = cell2mat(squeeze(temp(2:6, :, :)))';
            
            export_file = [model_PathName model_FileName(1:length(model_FileName)-4) '.csv'];
            
            csvwrite(export_file, [0 export_data]);
            
            dlmwrite(export_file,table,'delimiter',',','-append');
            
        end
    end
end
success = true;
end