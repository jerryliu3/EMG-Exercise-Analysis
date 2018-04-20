%% format a specific file

filename = 'back_row_9600_Andrew_4chan.csv';
filename2 = 'back_row_9600_Andrew_4chan_formatted.csv'
data = csvread(filename);
data = data(:, 2);
channels = 4;
channel_repeats = floor(length(data)/4000);
matrix = zeros(channel_repeats*1000, 4);
for i=0:channel_repeats-1
    for j=0:channels-1
        rows = (i*4000 + j*1000+1):(i*4000+(j+1)*1000);
        disp(rows);
        matrix(i*1000+1:(i+1)*1000, j+1) = data(rows);
    end
end

csvwrite(filename2, matrix);

%% combine a directory of files together
foldername = 'test'
filepath = ['C:/Users/andre/Desktop/' foldername '/'];
cd(filepath);
folder = dir([filepath '*.csv']);
matrix = [];
for i = 1:length(folder)
    filename = folder(i).name;
    matrix = [matrix;csvread(filename)];
end
[filepath, name, ext] = fileparts(folder(1).name);
disp(length(matrix));
csvwrite([filepath foldername '_combined.csv'], matrix);
