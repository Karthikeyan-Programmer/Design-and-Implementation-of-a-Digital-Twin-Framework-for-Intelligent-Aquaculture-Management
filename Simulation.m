% Open a text file for writing fish information
fileID = fopen('fish_data.txt', 'w');
% Initialize the environment
figure;
set(gcf, 'Position', get(0, 'Screensize'));
axis([0 100 0 100]);
hold on;
grid on;
numFish = 50;
% Define feeding rate adjustment based on fish size
feedingRateFactor = 0.1; % Factor to adjust feeding rate
% Initialize a matrix to store food intake for each fish
foodIntake = zeros(numFish, 1);
% Draw water background
rectangle('Position', [0, 0, 100, 100], 'FaceColor', [0.6 0.8 1]); % Light blue background
% Set up the simulation environment
sensorLocations = [20, 20; 80, 20; 50, 80];  % Locations of sensors
actuatorLocation = [50, 50];  % Location of an actuator (e.g., fish feeder)
cameraLocation = [50, 50];  % Location of a camera
cameraAngle = 45;  % Camera field of view (degrees)
cameraRadius = 30;  % Camera field of view radius
% Initialize file for saving results
fileID = fopen('fish_simulation_results.txt', 'w');
% Initialize fish properties
filename = 'numfish_value.txt'; % Specify the filename
fileID2 = fopen(filename, 'w');
fprintf(fileID2, '%d', numFish); % Write initial number of fish to file
fclose(fileID2);
fishPositions = rand(numFish, 2) * 100;  % Random initial positions
fishSpeeds = rand(numFish, 1) * 2 + 0.5;  % Random speeds
fishDirections = rand(numFish, 1) * 360;  % Random initial directions
fishSizes = rand(numFish, 1) * 3 + 1;  % Random sizes between 1 and 4
fishWeights = fishSizes * 0.5; % Example weight calculation (e.g., weight = size * 0.5)
% Track fish sizes at the end of each day
initialSizes = fishSizes; % Record the initial sizes (Day 1)
finalSizes = zeros(numFish, 1); % To store sizes at the end of the simulation (Day 2)
finalWeights = zeros(numFish, 1); % To store weights at the end of the simulation (Day 2)
diseaseAffected = zeros(numFish, 1);  % 0 - not affected, 1 - affected
% Fish shape definition (a simple fish shape)
fishBodyX = [-2, 2, 1, 2, -2, -1];  % X-coordinates of the fish shape
fishBodyY = [0, 0, 1, -1, 0, 0.5];  % Y-coordinates of the fish shape
% Simulation parameters
numSteps = 100;
sensorData = zeros(numSteps, size(sensorLocations, 1));
% Initialize arrays for food intake and size over time
foodIntakeOverTime = zeros(numSteps, numFish);
fishSizeOverTime = zeros(numSteps, numFish);
for t = 1:numSteps
    clf;
    axis([0 100 0 100]);
    hold on;
    grid on;
    % Draw water background
    rectangle('Position', [0, 0, 100, 100], 'FaceColor', [0.6 0.8 1]); % Light blue background
    % Simulate sensor data
    sensorData(t, :) = rand(1, size(sensorLocations, 1)) * 10 + 20;  % Example data
    % Plot sensors
    for i = 1:size(sensorLocations, 1)
        plot(sensorLocations(i, 1), sensorLocations(i, 2), 'ro', ...
            'MarkerSize', 10, 'MarkerFaceColor', 'r');
        text(sensorLocations(i, 1) + 2, sensorLocations(i, 2), ...
            sprintf('Sensor %d: %.2f', i, sensorData(t, i)), 'FontSize', 8);
    end
    % Simulate actuator movement (e.g., fish feeder moving)
    actuatorMovement = actuatorLocation + [sin(t/10)*10, cos(t/10)*10];
    plot(actuatorMovement(1), actuatorMovement(2), 'bo', ...
        'MarkerSize', 12, 'MarkerFaceColor', 'b');
    text(actuatorMovement(1) + 2, actuatorMovement(2), 'Actuator', 'FontSize', 8);
    % Simulate camera field of view
    theta = linspace(-cameraAngle/2, cameraAngle/2, 100);
    x = cameraRadius * cosd(theta) + cameraLocation(1);
    y = cameraRadius * sind(theta) + cameraLocation(2);
    fill([cameraLocation(1), x], [cameraLocation(2), y], 'y', 'FaceAlpha', 0.2);
    plot(cameraLocation(1), cameraLocation(2), 'gs', ...
        'MarkerSize', 10, 'MarkerFaceColor', 'g');
    text(cameraLocation(1) + 2, cameraLocation(2), 'Camera', 'FontSize', 8);
    % Simulate camera capturing a sensor reading
    if t > 20 && t < 80  % Only during certain time steps
        capturedSensorIndex = randi(size(sensorLocations, 1));
        plot(sensorLocations(capturedSensorIndex, 1), ...
            sensorLocations(capturedSensorIndex, 2), 'ko', ...
            'MarkerSize', 14, 'MarkerFaceColor', 'k');
        text(sensorLocations(capturedSensorIndex, 1) + 2, ...
            sensorLocations(capturedSensorIndex, 2) - 5, ...
            'Captured by Camera', 'FontSize', 8, 'Color', 'k');
    end
    % Update and plot fish positions
    if t == numSteps / 2  % Increase fish count on Day 2
        numFish = 60;  % Update number of fish
        fishPositions = [fishPositions; rand(10, 2) * 100];  % Add new fish positions
        fishSpeeds = [fishSpeeds; rand(10, 1) * 2 + 0.5];  % Add new fish speeds
        fishDirections = [fishDirections; rand(10, 1) * 360];  % Add new fish directions
        fishSizes = [fishSizes; rand(10, 1) * 0.1 + 0.7];
        fishWeights = [fishWeights; fishSizes(51:end) * 0.5]; % Update weights
        % Randomly select 3 to 4 of the new fish to be affected by the disease
        newFishIndices = (51:60)';
        numAffected = randi([3, 4]);  % Random number of affected fish
        affectedIndices = randsample(newFishIndices, numAffected);
        diseaseAffected = [diseaseAffected; zeros(10, 1)];  % Ensure the diseaseAffected array is large enough
        diseaseAffected(affectedIndices) = 1;  % Mark these fish as affected
    end
    % Simulate actuator influence
for i = 1:numFish
    distanceToActuator = sqrt((fishPositions(i, 1) - actuatorMovement(1))^2 + (fishPositions(i, 2) - actuatorMovement(2))^2);
    
    % Adjust food intake based on distance to actuator and fish size
    if distanceToActuator < 10  % If the fish is within 10 units of the actuator
        foodIntake(i) = feedingRateFactor * fishSizes(i);
    end
end
    % Update fish direction randomly
    fishDirections = fishDirections + randn(numFish, 1) * 10;
    % Calculate new fish positions
    fishPositions(:, 1) = fishPositions(:, 1) + fishSpeeds .* cosd(fishDirections);
    fishPositions(:, 2) = fishPositions(:, 2) + fishSpeeds .* sind(fishDirections);
    % Ensure fish stay within bounds
    fishPositions(:, 1) = mod(fishPositions(:, 1), 100);
    fishPositions(:, 2) = mod(fishPositions(:, 2), 100);
    % Initialize food intake array for this step
    foodIntake = zeros(numFish, 1);
    % Update food intake and fish size
    for i = 1:numFish
        distanceToActuator = sqrt((fishPositions(i, 1) - actuatorMovement(1))^2 + (fishPositions(i, 2) - actuatorMovement(2))^2);
        if distanceToActuator < 10  % If the fish is within 10 units of the actuator
            foodIntake(i) = feedingRateFactor * fishSizes(i);
        else
            foodIntake(i) = 0;  % No food intake if out of range
        end
        fishSizes(i) = fishSizes(i) + foodIntake(i) * 0.01;  % Increase size based on food intake
        fishWeights(i) = fishSizes(i) * 0.5;  % Update weight based on new size
    end
    % Record food intake and size
   foodIntakeOverTime(t, 1:numFish) = foodIntake;
   fishSizeOverTime(t, 1:numFish) = fishSizes;
    % Plot the fish with a rotation for direction and scaling for size
    for i = 1:numFish
        fishX = fishBodyX * fishSizes(i);  % Scale fish size
        fishY = fishBodyY * fishSizes(i);
        rotatedFishX = cosd(fishDirections(i)) * fishX - sind(fishDirections(i)) * fishY;
        rotatedFishY = sind(fishDirections(i)) * fishX + cosd(fishDirections(i)) * fishY;
        % Color fish based on the day they were added and disease status
        if i <= 50
            color = 'm';  % Day 1 fish color
        else
            if diseaseAffected(i)
                color = 'b';  % Disease-affected Day 2 fish color
            else
                color = 'c';  % Healthy Day 2 fish color
            end
        end
        fill(rotatedFishX + fishPositions(i, 1), ...
             rotatedFishY + fishPositions(i, 2), ...
             color, 'EdgeColor', 'k');
        % Write fish data to file
        fprintf(fileID, 'Fish %d: Position(%.2f, %.2f) Speed(%.2f) Direction(%.2f) Size(%.2f) Weight(%.2f) Disease(%d)\n', ...
            i, fishPositions(i, 1), fishPositions(i, 2), fishSpeeds(i), fishDirections(i), fishSizes(i), fishWeights(i), diseaseAffected(i));
    end
    % Add Day 1/Day 2 legend to the plot
    if t == numSteps / 2
        legend('Sensor', 'Actuator', 'Camera', 'Captured Sensor', 'Fish (Day 1)', 'Fish (Day 2, Healthy)', 'Fish (Day 2, Disease-Affected)', 'Location', 'northeast');
    end
      % Add Day 1/Day 2 legend to the plot
    if t <= numSteps / 2
        legend('Fish (Day 1)', 'Location', 'northeast');
    else
        legend('Fish (Day 2)', 'Location', 'northeast');
    end
    % Save the last frame of Day 2
    if t == numSteps
        lastFrame = getframe(gcf);  % Capture the last frame
        imwrite(lastFrame.cdata, 'day2_last_frame.png');  % Save the last frame as an image
    end
    pause(0.1);
end
% Finalize the simulation
fclose(fileID);
pause(1);
IoT_Device_Simulation(); % Call the IoT_Device_Simulation function
pause(1);
fprintf('\n');
% Display Data Collection and Cloud Transfer section
disp("|------------------------------------|");
disp(" Data Collection and Cloud Transfer ");
disp("|------------------------------------|");
fprintf('\n');
pause(1);
Data_Streaming(); % Call the Data_Streaming function
pause(1);
fprintf('\n');
% Display Data Preprocessing section
disp("|---------------------|");
disp(" Data Preprocessing ");
disp("|---------------------|");
fprintf('\n');
pause(1);
Data_Preprocessing(); % Call the Data_Preprocessing function
pause(1);
fprintf('\n');
% Display Digital Twin Services section
disp("|------------------------|");
disp(" Digital Twin Services ");
disp("|------------------------|");
fprintf('\n');
pause(1);
Digital_Twin_Services(); % Call the Digital_Twin_Services function
pause(1);
fprintf('\n');
% Display Optimization and Prediction Algorithms section
disp("|----------------------------------------|");
disp(" Optimization and Prediction Algorithms ");
disp("|----------------------------------------|");
fprintf('\n');
pause(1);
figure;
set(gcf, 'Position', get(0, 'Screensize'));
axis([0 100 0 100]);
hold on;
grid on;
% Draw water background
rectangle('Position', [0, 0, 100, 100], 'FaceColor', [0.6 0.8 1]); % Light blue background
% Plot fish on Day 2 with bounding boxes
for i = 1:numFish
    % Plot the fish with a rotation for direction and scaling for size
    fishX = fishBodyX * fishSizes(i);  % Scale fish size
    fishY = fishBodyY * fishSizes(i);
    rotatedFishX = cosd(fishDirections(i)) * fishX - sind(fishDirections(i)) * fishY;
    rotatedFishY = sind(fishDirections(i)) * fishX + cosd(fishDirections(i)) * fishY;
    fill(rotatedFishX + fishPositions(i, 1), ...
         rotatedFishY + fishPositions(i, 2), ...
         'm', 'EdgeColor', 'k');
    % Calculate bounding box
    minX = min(rotatedFishX) + fishPositions(i, 1);
    maxX = max(rotatedFishX) + fishPositions(i, 1);
    minY = min(rotatedFishY) + fishPositions(i, 2);
    maxY = max(rotatedFishY) + fishPositions(i, 2);
    % Plot bounding box
    rectangle('Position', [minX, minY, maxX - minX, maxY - minY], ...
              'EdgeColor', 'g', 'LineWidth', 1.5);
    % Calculate height, width, and size
    fishWidth = maxX - minX;
    fishHeight = maxY - minY;
    fishSize = fishSizes(i);
    % Print height, width, and size
    annotationText = sprintf('Width: %.2f\nHeight: %.2f\nSize: %.2f', ...
                              fishWidth, fishHeight, fishSize);
    % Place the annotation near the fish (adjust position as needed)
    text(minX + fishWidth/2, minY - 2, annotationText, ...
         'HorizontalAlignment', 'center', ...
         'VerticalAlignment', 'bottom', ...
         'BackgroundColor', 'w', ...
         'EdgeColor', 'k', ...
         'Margin', 2);
end
% Add labels and save the figure
xlabel('X Position');
ylabel('Y Position');
title('Day 2 Fish Distribution');
saveas(gcf, 'Fishs_day2.png');
pause(1);
fprintf('Statistics:\n');
% Display fish sizes if available
if exist('fishSizes', 'var')
    for i = 1:length(fishSizes)
        fprintf('Fish %d Size = %.2f\n', i, fishSizes(i));
    end
end
% Calculate and display statistics
finalSizes = fishSizes; % Sizes at the end of the simulation
finalWeights = fishWeights; % Weights at the end of the simulation
meanSizeDay1 = mean(initialSizes); % Average size on Day 1
meanSizeDay2 = mean(finalSizes); % Average size on Day 2
sizeChange = meanSizeDay2 - meanSizeDay1; % Average size change
% Count fish at the end of Day 2
numFishDay2 = numFish; % Total number of fish at the end of the simulation
pause(1);
% Display statistics
fprintf('Average fish size on Day 1: %.2f\n', meanSizeDay1);
fprintf('Average fish size on Day 2: %.2f\n', meanSizeDay2);
fprintf('Average size change: %.2f\n', sizeChange);
fprintf('Number of fish affected by disease: %d\n', sum(diseaseAffected));
pause(1);
% Day 2 Results
fprintf('\nDay 2 Results:\n');
fprintf('Total number of fish: %d\n', numFishDay2);
fprintf('Fish sizes: %s\n', num2str(finalSizes'));
fprintf('Fish weights: %s\n', num2str(finalWeights'));
pause(1);
% Display disease-affected fish details
fprintf('\nDisease-Affected Fish Details:\n');
affectedIndices = find(diseaseAffected == 1);
for i = affectedIndices'
    fprintf('Fish %d: Position(%.2f, %.2f) Size(%.2f) Weight(%.2f)\n', ...
        i, fishPositions(i, 1), fishPositions(i, 2), fishSizes(i), fishWeights(i));
end
pause(1);
% Plot food intake vs. fish size for each time step
figure('WindowState', 'maximized');
hold on;
for t = 1:numSteps
    scatter(foodIntakeOverTime(t, :), fishSizeOverTime(t, :), 'filled');
end
xlabel('Food Intake');
ylabel('Fish Size');
title('Food Intake vs. Fish Size Over Time');
grid on;
legend(arrayfun(@(x) sprintf('Time Step %d', x), 1:numSteps, 'UniformOutput', false));
hold off;
fprintf('\n');
pause(1);
Feeding();
pause(1);
disp("|-------|");
disp(" END ");
disp("|-------|");
uiwait(msgbox('END','Message Box','modal'));
