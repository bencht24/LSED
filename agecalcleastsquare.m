% parameter input
ps = input('Enter the value for ps (s-1): ');
u = input('Enter the value for u (mm-1): ');

% Provided data
x = [1.04, 2.22333333333333, 3.39333333333333, 4.02, 5.38333333333333, 6.67666666666667, 8.18, 9.70333333333333, 11.09, 12.2533333333333, 13.8166666666667, 15.3233333333333, 16.8133333333333, 18.1266666666667, 19.6733333333333, 21.3233333333333, 22.7233333333333, 25.3966666666667, 26.8966666666667, 29.03, 30.28];
L = [0, 0.00975636438163995, 0.057361433427564, 0.026750329314909, 0.0428537112846817, 0.0704960988239085, 0.0536668017915828, 0.29002388452717, 0.196744879360554, 0.870901138416643, 0.689029148093359, 1.29947849236274, 1.34463973607678, 1.03999901248472, 1.03982721712197, 0.846011962927814, 0.863685623563919, 0.863494357098247, 1.19505927274062, 1.09116551538459, 0.986595231212624];
error_L = [0.00320479846460689, 0.00204303182499297, 0.00582706141037327, 0.00318581787205527, 0.00447290991270651, 0.00469713442372092, 0.00343600806930636, 0.0073486853235461, 0.00493909963444319, 0.0190504014580511, 0.0226953268078108, 0.029364716836165, 0.0321851673329639, 0.0227169586825521, 0.0270864460301806, 0.0378114693514792, 0.0321960471452477, 0.0270317039389524, 0.0307029347158349, 0.0359358303023111, 0.0400564535020012];

% Initial guess time parameter
t0 = input('Enter a starting guess value for time (s): '); % You can modify this as needed

% Define the model function
model = @(t, x) exp(-ps * t * exp(-u * x));

% Define the weighted least-squares objective function
objective = @(t) sum(((L - model(t, x)) ./ error_L).^2);

% Use fminsearch to minimize the objective function
options = optimset('Display', 'iter'); % Show iteration details
[t_fit, resnorm, ~, output] = fminsearch(objective, t0, options);

% Display the results
fprintf('Fitted parameter t: %.6f\n', t_fit);

% Calculate the fitted curve
L_fit = model(t_fit, x);

% Calculate uncertainties for the fitted parameter
J = -(ps * exp(-u * x) .* exp(-ps * t_fit * exp(-u * x)))'; % Jacobian of the model w.r.t. t
residuals = (L - L_fit) ./ error_L; % Normalized residuals
sigma2 = sum(residuals.^2) / (length(L) - 1); % Variance of residuals
cov_t = inv(J' * J) * sigma2; % Covariance matrix
t_uncertainty = sqrt(cov_t); % Standard error of t

% Display uncertainties
fprintf('Uncertainty in fitted parameter t: ±%.6f\n', t_uncertainty);

% Plot the data and the fit
figure;
errorbar(x, L, error_L, 'o', 'DisplayName', 'Data with Error'); % Data with error bars
hold on;
plot(x, L_fit, '-', 'LineWidth', 2, 'DisplayName', 'Fitted Curve'); % Fitted curve
hold off;
legend;
xlabel('x');
ylabel('L');
title('Least Squares Curve Fitting with Error');
grid on;
