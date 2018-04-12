function success = BFM_compile_error(landmarks, names, images, iterations, type)
    format short g      % for number formatting
    format compact
    warning('off', 'Images:initSize:adjustingMag');


    for name_counter = 1:size(names, 2)
        name = char(names(name_counter));
        for image_counter = 1:size(images, 2)
            image = char(images(image_counter));
            file_path = [lower(name) '\results\' image '\'];
            folder = new_dir(fullfile([file_path lower(name) '_' image '_' iterations '_' type '.csv'])); 
            %% section for dealing with folders that contain cropped and uncropped images together
            % used to avoid issues where if a folder contains file with image 2
            % and 2_cropped, it won't include the 2_cropped images while
            % parsing through image 2
            counter = 1;
            while (~isempty(folder))
                if(~contains(image, 'cropped') && contains(folder(counter).name, 'cropped'))
                    folder(counter) = [];
                    counter = max(1, counter-1);
                end
                if(counter >= length(folder))
                    break;
                end
                counter = counter + 1;
            end
            %%
            sgn_sub_std = [];
            abs_sub_avg = [];
            for counter = 1:length(folder)
                current_file = csvread([file_path folder(counter).name]);
                sgn_sub_std = [sgn_sub_std [str2double(folder(counter).name(2+length(image)+strfind(folder(counter).name, ['_' image '_']):strfind(folder(counter).name, ['_' type])-1)); current_file(:, 2)]];
                abs_sub_avg = [abs_sub_avg [str2double(folder(counter).name(2+length(image)+strfind(folder(counter).name, ['_' image '_']):strfind(folder(counter).name, ['_' type])-1)); current_file(:, 3)]];
            end
            if(length(folder) > 0)
                summary_folder = fullfile([lower(name) '\results\error_summary\']);
                if(~exist(summary_folder, 'dir'))
                    mkdir(summary_folder);
                end
                export_file = [summary_folder folder(counter).name(1:1+length(image)+strfind(folder(counter).name, ['_' image '_'])) type '_sgn_std_error_summary.csv'];
                export_data = sgn_sub_std;
                csvwrite(export_file, export_data);
                export_file = [summary_folder folder(counter).name(1:1+length(image)+strfind(folder(counter).name, ['_' image '_'])) type '_abs_avg_error_summary.csv'];
                export_data = abs_sub_avg;
                csvwrite(export_file, export_data);
            end
        end
    end
    success = true
end