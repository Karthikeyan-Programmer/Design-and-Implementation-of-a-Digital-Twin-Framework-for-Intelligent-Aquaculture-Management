% Fish feedback parameters
feedbackSensitivity = 0.05;  % Sensitivity of fish to feedback (affects speed and direction change)
maxSpeed = 3;  % Maximum speed a fish can reach (units: m/s)
numFish = 50;  % Number of fish in the simulation
numSteps = 100;  % Number of time steps in the simulation
feedingThreshold = 5;  % Distance (units: m) within which fish receive food
% Initialize fish positions, speeds, and directions
fishPositions = 100 * rand(numFish, 2);
fishSpeeds = maxSpeed * rand(numFish, 1);
fishDirections = 360 * rand(numFish, 1);
fishSizes = 1 + rand(numFish, 1);
diseaseAffected = rand(numFish, 1) < 0.1;
% Sensor and actuator initialization
sensorLocations = [10 10; 20 30; 30 50; 40 70; 50 90];
sensorData = zeros(numSteps, size(sensorLocations, 1));
actuatorLocation = [25 25];  % Example actuator location (units: m)
% Feedback result storage
feedingResults = cell(numSteps, 1);
for t = 1:numSteps
    % Simulate sensor data
    sensorData(t, :) = rand(1, size(sensorLocations, 1)) * 10 + 20;
    % Simulate actuator movement (e.g., fish feeder moving)
    actuatorMovement = actuatorLocation + [sin(t/10)*10, cos(t/10)*10];
    % Initialize feeding results for the current time step
    feedingResults{t} = [];
    totalFoodFed = 0;
    % Fish feedback loop
    for i = 1:numFish
        % Feedback: Adjust speed based on distance to actuator and size
        distanceToActuator = sqrt((fishPositions(i, 1) - actuatorMovement(1))^2 + (fishPositions(i, 2) - actuatorMovement(2))^2);  % Distance (units: m)
        if distanceToActuator < 10  % Close to the actuator (units: m)
            fishSpeeds(i) = min(maxSpeed, fishSpeeds(i) + feedbackSensitivity * (10 - distanceToActuator));  % Speed (units: m/s)
        else
            fishSpeeds(i) = max(0.5, fishSpeeds(i) - feedbackSensitivity * (distanceToActuator - 10));  % Speed (units: m/s)
        end
        % Check if fish is within feeding range
        if distanceToActuator < feedingThreshold
            % Calculate the amount of food based on fish size (example calculation)
            foodAmount = 1 * fishSizes(i);  % Food amount (units: arbitrary)
            totalFoodFed = totalFoodFed + foodAmount;
            feedingResults{t}{end+1} = sprintf('Fish %d: Position (%.2f m, %.2f m), Speed: %.2f m/s, Direction: %.2f degrees, Food Amount: %.2f units', ...
                i, fishPositions(i, 1), fishPositions(i, 2), fishSpeeds(i), fishDirections(i), foodAmount);
        end
    end
    % Store total food fed in the results
    feedingResults{t}{end+1} = sprintf('Total Food Fed at Time Step %d: %.2f units', t, totalFoodFed);
end
% Print feeding results
for t = 1:numSteps
    if ~isempty(feedingResults{t})
        fprintf('Feeding Results for Time Step %d:\n', t);
        for k = 1:length(feedingResults{t})
            fprintf('%s\n', feedingResults{t}{k});
        end
        fprintf('\n');
    end
end