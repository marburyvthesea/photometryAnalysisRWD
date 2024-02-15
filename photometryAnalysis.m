%load photometry data

fluorescenceData = readtable('/Users/johnmarshall/Documents/Analysis/ObservationalFCData/2024_01_18-15_55_50/Fluorescence.csv');

footShockTimes = readtable('/Users/johnmarshall/Documents/Analysis/ObservationalFCData/2024_01_18-15_55_50/Events.csv');

%%
% select events from the whole trace

midpointIndiciesOfEvents = [3150, 3250, 3350];
numberOfSamplesToSelectPerEvent = 40; 

%% select regions from trace
% subregions from the trace will be stored in the "demonstrationEvents" structure

for i=1:size(midpointIndiciesOfEvents, 2)

    %eval(['region' num2str(i)  '= fluorescenceData(midpointIndiciesOfEvents(i)-numberOfSamplesToSelectPerEvent:midpointIndiciesOfEvents(i)+numberOfSamplesToSelectPerEvent, :); ']);
    regionName = ['region' num2str(i)];
    demonstrationEvents.(regionName) = fluorescenceData(midpointIndiciesOfEvents(i)-numberOfSamplesToSelectPerEvent:midpointIndiciesOfEvents(i)+numberOfSamplesToSelectPerEvent, :);

end 

%% normalize the values in each trace region selected to a baseline, 
% here the first half of the region, can play around with that
% normalized subregions will be stored in the "normalizedDemonstrationEvents" structure

for i=1:size(midpointIndiciesOfEvents, 2)

    fieldName = ['region' num2str(i)];

    normalizedRegion = demonstrationEvents.(fieldName) ;

    halfwayIndex = ceil(size(normalizedRegion, 1) / 2);
    % Preallocate array for means to optimize performance
    means = zeros(1, 3);
    % Calculate means of the first half for columns 3 to 5
    for col = 3:5
        means(col-2) = mean(normalizedRegion{1:halfwayIndex, col});
    end
    % Normalize values in columns 3 to 5
    for col = 3:5
        normalizedRegion{:, col} = normalizedRegion{:, col} / means(col-2);
    end
    % normalizedRegion now contains the normalized values for columns 3 to 5

    normalizedDemonstrationEvents.(fieldName) = normalizedRegion ; 

end