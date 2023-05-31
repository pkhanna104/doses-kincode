% Guide to making figures in 

% "Measuring Arm and Hand Joint Kinematics to Estimate Impairment During 
% a Functional Reach and Grasp Task after in Stroke Participants"

% Preeya Khanna, PhD1*, Tomas Oppenheim, PhD2*, Adelyn Tu-Chan, DO1,3, 
% Gary Abrams, MD1,3fig1.eps, and Karunesh Ganguly, MD, PhD1,3

% NNR 2023; 
%% Pre-processing: 
generate_rom_mse_datatable; 

%% Figure 1: 

% Fig 1ABCDF -- tracing / CAD 

% Fig 1E: 
% Saving is commented out for now
fig1; 

%% Figure 2: 
% Method to plot all subjects' affected / unaffected joint for all joints 
fig2_pk; 

% Fig 2A -- illustrator 
% Fig 2B: 
generate_fig2_traces; 

% Fig 2E
generate_norm_plots; % Section: "Plot Fig 2E --  by joint category"

% Fig 2D
generate_norm_plots: % Section: "Plot 2D -- affected/unaffected plus ellipse "

% Fig 2C
generate_norm_plots; % Section " Plot 2C -- individual jts for normal % patients"

% Fig 2F
generate_norm_plots; % Section "Plot 2F -- plot out violin plot distr of normROM / normMSE vs control"

%% Figure 3: 
individualized_polygons; 

%% Figure S1; 
% 1C
angle_validation_plots; % Section "Supplemental Figure 1C; across all sessions -- within-session reliability"
angle_validation_plots; % Section "Supplemental Figure 1C, right -- X subjects -- across session var; "

% 1B 
angle_validation_plots; % Section "Supplemental Figure 1B Left - hysteresis plots across subjects %%"
angle_validation_plots; % Section "%% Supplemental Figures 1B right -- error plots "

%% Figure S2; 
% Not sure 

%% Figure S3; 
% From Tom, not sure

%% Figure S4
generate_norm_plots; % Section "Plot Supplemental Figure S4 -- distributions of ROM and MSE ERROR bars "

%% Figure S5; 
% Illustrator