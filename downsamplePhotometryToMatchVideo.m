%load photometry data

fluorescenceData = readtable('/Users/johnmarshall/Documents/Analysis/SPRT_data/Fluorescence.csv');

%%
% Downsampling factor
downsampleFactor = 10;

% Number of rows in the table
numRows = size(fluorescenceData, 1);

% Calculate the number of groups
numGroups = ceil(numRows / downsampleFactor);

% Initialize a table for the downsampled data
downsampledTable = table([], [], [], [],'VariableNames', fluorescenceData.Properties.VariableNames);

% Loop through each group and calculate the mean
for i = 1:numGroups
    startIdx = (i - 1) * downsampleFactor + 1;
    endIdx = min(i * downsampleFactor, numRows);
    group = fluorescenceData(startIdx:endIdx, :);
    
    % Calculate the mean of each column in the group
    meanRow = varfun(@mean, group, 'InputVariables', fluorescenceData.Properties.VariableNames);
    
    % Append the mean row to the downsampled table
    downsampledTable = [downsampledTable; meanRow];
end

% Display the downsampled table
disp(downsampledTable);

%%
% Initialize an empty array to hold the downsampled data
downsampledData = [];

% Loop through each group and calculate the mean
for i = 1:numGroups
    startIdx = (i - 1) * downsampleFactor + 1;
    endIdx = min(i * downsampleFactor, numRows);
    group = fluorescenceData(startIdx:endIdx, :);
    
    % Calculate the mean of each column in the group directly
    meanValues = varfun(@mean, group);
    
    % Append the mean values to the downsampled data array
    downsampledData = [downsampledData; table2array(meanValues)];
end

% Convert the downsampled data back into a table with the original variable names
downsampledTable = array2table(downsampledData, 'VariableNames', fluorescenceData.Properties.VariableNames);

% Display the downsampled table
disp(downsampledTable);