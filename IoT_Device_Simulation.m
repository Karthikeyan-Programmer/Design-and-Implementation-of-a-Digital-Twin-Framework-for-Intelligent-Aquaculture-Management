% IoT Device Simulation for Aquaculture Environment with Cameras
% Simulation Parameters
timeSteps = 50;  % Number of Number of sampless for the simulation
pauseTime = 0.1;  % Pause time for animation effect
% Initialize Sensor Values
temperature = zeros(1, timeSteps);
pH = zeros(1, timeSteps);
DO = zeros(1, timeSteps);
% Initialize Actuator States
feeder = zeros(1, timeSteps);
sorter = zeros(1, timeSteps);
% Initialize Camera Outputs
fishDetected = zeros(1, timeSteps);
% Set up the figure for animation
figure;
set(gcf, 'Position', get(0, 'Screensize'));
% Simulation Loop
for t = 1:timeSteps
    % Simulate Sensor Readings (Randomized for Demonstration)
    temperature(t) = 20 + 5*randn();  % Temperature in °C
    pH(t) = 7 + 0.5*randn();          % pH level
    DO(t) = 8 + 2*randn();            % Dissolved Oxygen in mg/L
    % Simulate Camera Detection (Randomized for Demonstration)
    fishDetected(t) = rand() > 0.5;  % 50% chance of detecting fish
    % Actuator Logic Based on Sensor Inputs and Camera Output
    if (temperature(t) < 18 || temperature(t) > 28) && fishDetected(t)
        feeder(t) = 1;  % Activate feeder if temperature is out of optimal range and fish are detected
    else
        feeder(t) = 0;  % Deactivate feeder
    end
    if pH(t) < 6.5 || pH(t) > 7.5
        sorter(t) = 1;  % Activate sorter if pH is out of optimal range
    else
        sorter(t) = 0;  % Deactivate sorter
    end
    % Clear the previous plot
    clf;
    % Plot Sensor Data
    subplot(4,1,1);
    plot(1:t, temperature(1:t), '-r');
    title('Temperature Sensor');
    xlabel('Number of samples');
    ylabel('Temperature (°C)');
    xlim([1 timeSteps]);
    ylim([0 40]);
    subplot(4,1,2);
    plot(1:t, pH(1:t), '-g');
    title('pH Sensor');
    xlabel('Number of samples');
    ylabel('pH Level');
    xlim([1 timeSteps]);
    ylim([0 14]);
    subplot(4,1,3);
    plot(1:t, DO(1:t), '-b');
    title('Dissolved Oxygen Sensor');
    xlabel('Number of samples');
    ylabel('Dissolved Oxygen (mg/L)');
    xlim([1 timeSteps]);
    ylim([0 20]);
    % Plot Camera Data
    subplot(4,1,4);
    stairs(1:t, fishDetected(1:t), '-m');
    title('Camera: Fish Detection');
    xlabel('Number of samples');
    ylabel('Fish Detected (Yes/No)');
    xlim([1 timeSteps]);
    ylim([-0.5 1.5]);
    % Pause to create the animation effect
    pause(pauseTime);
    % Display sensor values, camera detection, and actuator states at each Number of samples
    fprintf('Number of sample %d: Temperature = %.2f°C, pH = %.2f, DO = %.2f mg/L, Fish Detected = %d, Feeder = %d, Sorter = %d\n', ...
        t, temperature(t), pH(t), DO(t), fishDetected(t), feeder(t), sorter(t));
end