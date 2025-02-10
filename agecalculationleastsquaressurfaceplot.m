clear all
% Given Data
x = [1.04, 2.22333333333333, 3.39333333333333, 4.02, 5.38333333333333, ...
     6.67666666666667, 8.18, 9.70333333333333, 11.09, 12.2533333333333, ...
     13.8166666666667, 15.3233333333333, 16.8133333333333, 18.1266666666667, ...
     19.6733333333333, 21.3233333333333, 22.7233333333333, 25.3966666666667, ...
     26.8966666666667, 29.03, 30.28];

L = [0, 0.00975636438163995, 0.057361433427564, 0.026750329314909, 0.0428537112846817, ...
     0.0704960988239085, 0.0536668017915828, 0.29002388452717, 0.196744879360554, ...
     0.870901138416643, 0.689029148093359, 1.29947849236274, 1.34463973607678, ...
     1.03999901248472, 1.03982721712197, 0.846011962927814, 0.863685623563919, ...
     0.863494357098247, 1.19505927274062, 1.09116551538459, 0.986595231212624];

error_L = [0.00320479846460689, 0.00204303182499297, 0.00582706141037327, 0.00318581787205527, ...
           0.00447290991270651, 0.00469713442372092, 0.00343600806930636, 0.0073486853235461, ...
           0.00493909963444319, 0.0190504014580511, 0.0226953268078108, 0.029364716836165, ...
           0.0321851673329639, 0.0227169586825521, 0.0270864460301806, 0.0378114693514792, ...
           0.0321960471452477, 0.0270317039389524, 0.0307029347158349, 0.0359358303023111, ...
           0.0400564535020012];

% Known value of t
t = 100000; % Change this as needed

% User-defined range for ps and u
ps_range = linspace(0, 0.001, 10000); % Example: 100 values from 0.001 to 1
u_range = linspace(0, 1, 10000);  % Example: 100 values from 0.001 to 1

% Initialize misfit matrix
misfit = zeros(length(u_range), length(ps_range));

% Loop over all combinations of ps and u
for i = 1:length(u_range)
    for j = 1:length(ps_range)
        u = u_range(i);
        ps = ps_range(j);
        
        % Compute model predictions
        L_model = exp(-ps * t * exp(-u * x));
        
        % Compute misfit (sum of squared errors)
        misfit(i, j) = sum(((L - L_model) ./ error_L).^2);
    end
end

% Find best-fit parameters
[min_misfit, min_index] = min(misfit(:));
[best_u_idx, best_ps_idx] = ind2sub(size(misfit), min_index);
best_u = u_range(best_u_idx);
best_ps = ps_range(best_ps_idx);

% Normalize and invert misfit values
misfit_inv = 1 ./ misfit; 
misfit_inv = misfit_inv / max(misfit_inv(:)); % Normalize

% Compute 1-sigma confidence interval (Δχ² = 1 threshold)
threshold = min_misfit + 1;
valid_indices = find(misfit <= threshold);
[u_valid_idx, ps_valid_idx] = ind2sub(size(misfit), valid_indices);

% Extract confidence interval range
u_min = min(u_range(u_valid_idx));
u_max = max(u_range(u_valid_idx));
ps_min = min(ps_range(ps_valid_idx));
ps_max = max(ps_range(ps_valid_idx));

% Compute uncertainties as half-range
u_uncertainty = (u_max - u_min) / 2;
ps_uncertainty = (ps_max - ps_min) / 2;

% Display results
fprintf('Best-fit parameters:\n');
fprintf('  u  = %.5f ± %.5f\n', best_u, u_uncertainty);
fprintf('  ps = %.5f ± %.5f\n', best_ps, ps_uncertainty);

% Surface plot
figure;
surf(ps_range, u_range, misfit_inv);
xlabel('ps');
ylabel('u');
zlabel('Normalized Inverse Misfit');
title('Parameter Space Exploration');
colorbar;
shading interp;
hold on;
scatter3(best_ps, best_u, 1, 100, 'r', 'filled'); % Mark best fit
view (2);
