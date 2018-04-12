function [xdata, ydata] = BFM_plot_compiled_error(landmarks, names, type)
    %% plot compiled error
    
    %% 
    set(0,'DefaulttextInterpreter','none'); % so underscore in title doesn't format as subscripts vs. Interpreter 'Tex'

    set(0,'DefaultFigureWindowStyle','docked')
    % set(0,'DefaultFigureWindowStyle','normal')

    format short g      % for number formatting
    format compact
    warning('off', 'Images:initSize:adjustingMag');
    %%
    sgn_sub_std = zeros(12, 3);
    abs_sub_avg = zeros(12, 3);
    sgn_sub_std_overall = figure;
    title(['Overall face std of error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    abs_sub_avg_overall = figure;
    title(['Overall face average error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    sgn_sub_std_midface = figure;
    title(['Mid face std of error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    abs_sub_avg_midface = figure;
    title(['Mid face average error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    sgn_sub_std_nose = figure;
    title(['Nose std of error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    abs_sub_avg_nose = figure;
    title(['Nose average error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    sgn_sub_std_outerface = figure;
    title(['Outer face std of error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    abs_sub_avg_outerface = figure;
    title(['Outer face average error with ' landmarks ' landmarks']);
    ylim([1 10]); xlabel('Iterations (# in thousands)'); ylabel('Error (cm)');
    hold on;
    ydata.overall_std = [];
    ydata.nose_std = [];
    ydata.midface_std = [];
    ydata.outerface_std = [];
    ydata.overall_avg = [];
    ydata.nose_avg = [];
    ydata.midface_avg = [];
    ydata.outerface_avg = [];
    for name_counter = 1:size(names, 2)
        name = char(names(name_counter));
        file_path = [lower(name) '\results\error_summary\'];
        folder = new_dir(fullfile([file_path name '*' 'sgn_std_error_summary.csv'])); 
        for counter = 1:length(folder)
            file = [file_path folder(counter).name];
            current_file = csvread(file);
            ydata.overall_std = plot_results(current_file, sgn_sub_std_overall, 2, ydata.overall_std);
            ydata.nose_std = plot_results(current_file, sgn_sub_std_nose, 6, ydata.nose_std);
            ydata.midface_std = plot_results(current_file, sgn_sub_std_midface, 11, ydata.midface_std);
            ydata.outerface_std = plot_results(current_file, sgn_sub_std_outerface, 12, ydata.outerface_std);
            %sgn_sub_std = sgn_sub_std + current_file;
        end
        folder = dir(fullfile([file_path name '*' 'abs_avg_error_summary.csv'])); 
        for counter = 1:length(folder)
            file = [file_path folder(counter).name];
            current_file = csvread(file);
            ydata.overall_avg = plot_results(current_file, abs_sub_avg_overall, 2, ydata.overall_avg);
            ydata.nose_avg = plot_results(current_file, abs_sub_avg_nose, 6, ydata.nose_avg);
            ydata.midface_avg = plot_results(current_file, abs_sub_avg_midface, 11, ydata.midface_avg);
            ydata.outerface_avg = plot_results(current_file, abs_sub_avg_outerface, 12, ydata.outerface_avg);
            %abs_sub_avg = abs_sub_avg + current_file;
        end
    end
    
    xdata = current_file(1, :)./1000;
    %ydata_std = struct(ydata_overall_std, ydata_nose_std, ydata_midface_std, ydata_outerface_std);
    %ydata_avg = struct(ydata_overall_avg, ydata_nose_avg, ydata_midface_avg, ydata_outerface_avg);
    
end
%sgn_sub_std = sgn_sub_std ./ (sgn_sub_std(1)/12000);
%abs_sub_avg = abs_sub_avg ./ (abs_sub_avg(1)/12000);
function ydata = plot_results(current_file, foi, row, ydata)
        figure(foi);
        hold on;
        overall = current_file(row, :);
        plot(current_file(1, :)./1000,overall);
        ydata = [ydata; overall];
end