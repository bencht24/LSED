% Least-absolute residuals curve fitting to estimate ps and u with known age t

% User-provided known parameter
t = input('Enter the known value for t: ');

% Provided data
x = [1.04, 2.22333333333333, 3.39333333333333, 4.02, 5.38333333333333, 6.67666666666667, 8.18, 9.70333333333333, 11.09, 12.2533333333333, 13.8166666666667, 15.3233333333333, 16.8133333333333, 18.1266666666667, 19.6733333333333, 21.3233333333333, 22.7233333333333, 25.3966666666667, 26.8966666666667, 29.03, 30.28];
L = [0, 0.00975636438163995, 0.057361433427564, 0.026750329314909, 0.0428537112846817, 0.0704960988239085, 0.0536668017915828, 0.29002388452717, 0.196744879360554, 0.870901138416643, 0.689029148093359, 1.29947849236274, 1.34463973607678, 1.03999901248472, 1.03982721712197, 0.846011962927814, 0.863685623563919, 0.863494357098247, 1.19505927274062, 1.09116551538459, 0.986595231212624];
error_L = [0.00320479846460689, 0.00204303182499297, 0.00582706141037327, 0.00318581787205527, 0.00447290991270651, 0.00469713442372092, 0.00343600806930636, 0.0073486853235461, 0.00493909963444319, 0.0190504014580511, 0.0226953268078108, 0.029364716836165, 0.0321851673329639, 0.0227169586825521, 0.0270864460301806, 0.0378114693514792, 0.0321960471452477, 0.0270317039389524, 0.0307029347158349, 0.0359358303023111, 0.0400564535020012];

% Initial guesses for parameters ps and u
initial_guess = [1, 1]; % [ps, u]

% Define the model function
model = @(params, x) exp(-params(1) * t * exp(-params(2) * x));

% Define the least-absolute residuals objective function
objective = @(params) sum(abs((L - model(params, x)) ./ error_L));

% Use fminsearch to minimize the objective function
options = optimset('Display', 'iter'); % Show iteration details
[params_fit, resnorm] = fminsearch(objective, initial_guess, options);

% Extract the fitted parameters
ps_fit = params_fit(1);
u_fit = params_fit(2);

% Estimate uncertainties using the Jacobian and residuals
J = zeros(length(x), 2); % Jacobian matrix
for i = 1:length(x)
    J(i, 1) = -t * exp(-u_fit * x(i)) * exp(-ps_fit * t * exp(-u_fit * x(i))); % Partial derivative w.r.t. ps
    J(i, 2) = ps_fit * t * x(i) * exp(-u_fit * x(i)) * exp(-ps_fit * t * exp(-u_fit * x(i))); % Partial derivative w.r.t. u
end

% Residuals
residuals = (L - model(params_fit, x)) ./ error_L;

% Covariance matrix
cov_matrix = inv(J' * J) * var(residuals);

% Standard errors (square root of diagonal elements of the covariance matrix)
ps_uncertainty = sqrt(cov_matrix(1, 1));
u_uncertainty = sqrt(cov_matrix(2, 2));

% Display the results
fprintf('Fitted parameter ps: %.6f ± %.6f\n', ps_fit, ps_uncertainty);
fprintf('Fitted parameter u: %.6f ± %.6f\n', u_fit, u_uncertainty);

% Calculate the fitted curve
L_fit = model(params_fit, x);

% Plot the data and the fit
figure;
errorbar(x, L, error_L, 'o', 'DisplayName', 'Data with Error'); % Data with error bars
hold on;
plot(x, L_fit, '-', 'LineWidth', 2, 'DisplayName', 'Fitted Curve'); % Fitted curve
hold off;
legend;
xlabel('x');
ylabel('L');
title('Least Absolute Residuals Curve Fitting for ps and u');
grid on;
