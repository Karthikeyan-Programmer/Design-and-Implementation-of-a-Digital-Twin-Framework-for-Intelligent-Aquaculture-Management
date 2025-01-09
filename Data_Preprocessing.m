% Load sensor data
load('sensor_data_wifi.mat'); % Ensure sensor_data.mat is in the same directory or provide the path
% Check if all required variables are present
requiredVars = {'saved_dissolved_oxygen_wifi', 'saved_fish_detected_wifi', 'saved_pH_wifi', 'saved_temperature_wifi', 'saved_time_wifi'};
for i = 1:numel(requiredVars)
    if ~exist(requiredVars{i}, 'var')
        error('Variable %s not found in sensor_data_wifi.mat', requiredVars{i});
    end
end
% Extract variables
dissolved_oxygen = saved_dissolved_oxygen_wifi;
fish_detected = saved_fish_detected_wifi;
pH = saved_pH_wifi;
temperature = saved_temperature_wifi;
time = saved_time_wifi;
% Preprocess data (example: normalization)
% Normalize the data to the range [0, 1]
normalized_dissolved_oxygen = (dissolved_oxygen - min(dissolved_oxygen)) / (max(dissolved_oxygen) - min(dissolved_oxygen));
normalized_fish_detected = (fish_detected - min(fish_detected)) / (max(fish_detected) - min(fish_detected));
normalized_pH = (pH - min(pH)) / (max(pH) - min(pH));
normalized_temperature = (temperature - min(temperature)) / (max(temperature) - min(temperature));
% Create a structure to save preprocessed data
preprocessed_data = struct();
preprocessed_data.normalized_dissolved_oxygen = normalized_dissolved_oxygen;
preprocessed_data.normalized_fish_detected = normalized_fish_detected;
preprocessed_data.normalized_pH = normalized_pH;
preprocessed_data.normalized_temperature = normalized_temperature;
preprocessed_data.time = time;
% Save preprocessed data to a .mat file
save('preprocessed_sensor_data.mat', 'preprocessed_data');
% Print the preprocessed data
disp('Preprocessed Data:');
disp('Normalized Dissolved Oxygen:');
disp(preprocessed_data.normalized_dissolved_oxygen);
disp('Normalized Fish Detected:');
disp(preprocessed_data.normalized_fish_detected);
disp('Normalized pH:');
disp(preprocessed_data.normalized_pH);
disp('Normalized Temperature:');
disp(preprocessed_data.normalized_temperature);
disp('Time:');
disp(preprocessed_data.time);
disp('Data preprocessing complete. Results saved to preprocessed_sensor_data.mat');