% Define the time vector and simulated sensor data
time = linspace(0, 48, 100); % Simulate 48 hours with 100 time points
temperature = 20 + 2*sin(2*pi*time/24); % Example temperature data (°C)
pH = 7 + 0.3*sin(2*pi*time/12); % Example pH data
dissolved_oxygen = 8 + 0.5*sin(2*pi*time/6); % Example DO data (mg/L)

% Initialize arrays to save results for Wi-Fi
saved_time_wifi = time;
saved_temperature_wifi = temperature;
saved_pH_wifi = pH;
saved_dissolved_oxygen_wifi = dissolved_oxygen;
saved_fish_detected_wifi = zeros(1, length(time));

% Wi-Fi Protocol Simulation
delay_wifi = 0.1; % Simulate Wi-Fi protocol delay (seconds)

figure;
set(gcf, 'Position', get(0, 'Screensize'));
set(gcf, 'Color', [0.95 0.95 0.95]); % Light gray background

for t = 1:length(time)
    % Simulate fish detection (0 = no fish detected, 1 = fish detected)
    saved_fish_detected_wifi(t) = randi([0, 1]);

    % Print simulated data streaming for Wi-Fi
    fprintf('Streaming Data to Cloud (Wi-Fi) at Time: %.1f hours\n', time(t));
    fprintf('Temperature: %.2f °C, pH: %.2f, Dissolved Oxygen: %.2f mg/L, Fish Detected: %d\n', ...
            temperature(t), pH(t), dissolved_oxygen(t), saved_fish_detected_wifi(t));

    % Update plots for Wi-Fi
    subplot(4,1,1);
    plot(time(1:t), temperature(1:t), 'r', 'LineWidth', 2);
    title('Wi-Fi Real-time Temperature Data', 'FontWeight', 'bold');
    xlabel('Time (hours)', 'FontWeight', 'bold');
    ylabel('Temperature (°C)', 'FontWeight', 'bold');
    xlim([0, 48]);
    ylim([min(temperature)-1, max(temperature)+1]);
    grid on;

    subplot(4,1,2);
    plot(time(1:t), pH(1:t), 'g', 'LineWidth', 2);
    title('Wi-Fi Real-time pH Data', 'FontWeight', 'bold');
    xlabel('Time (hours)', 'FontWeight', 'bold');
    ylabel('pH', 'FontWeight', 'bold');
    xlim([0, 48]);
    ylim([min(pH)-0.5, max(pH)+0.5]);
    grid on;

    subplot(4,1,3);
    plot(time(1:t), dissolved_oxygen(1:t), 'b', 'LineWidth', 2);
    title('Wi-Fi Real-time Dissolved Oxygen Data', 'FontWeight', 'bold');
    xlabel('Time (hours)', 'FontWeight', 'bold');
    ylabel('DO (mg/L)', 'FontWeight', 'bold');
    xlim([0, 48]);
    ylim([min(dissolved_oxygen)-1, max(dissolved_oxygen)+1]);
    grid on;

    subplot(4,1,4);
    stairs(time(1:t), saved_fish_detected_wifi(1:t), 'm', 'LineWidth', 2);
    title('Wi-Fi Real-time Fish Detection Data', 'FontWeight', 'bold');
    xlabel('Time (hours)', 'FontWeight', 'bold');
    ylabel('Fish Detected (0 or 1)', 'FontWeight', 'bold');
    xlim([0, 48]);
    ylim([-0.1, 1.1]);
    grid on;
    
    drawnow; % Update plots in real-time
    pause(delay_wifi); % Simulate Wi-Fi protocol delay
end

% Save results to a .mat file
save('sensor_data_wifi.mat', 'saved_time_wifi', 'saved_temperature_wifi', 'saved_pH_wifi', 'saved_dissolved_oxygen_wifi', 'saved_fish_detected_wifi');
