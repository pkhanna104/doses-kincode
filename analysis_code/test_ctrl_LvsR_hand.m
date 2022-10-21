% Script to compare control subjects' left vs. right hands to see if they
% can be combined 

% Load data table (made in "generate_rom_mse_datatable.m")
%%% Save out params 1       2          3    4     5     6 
% Column 1 -- subject ID
% Column 2 -- control subject? 1=yes, 0=no
% Column 3 -- joint number (#1-11)
% Column 4 -- affected hand? 1=yes, 0=no (for controls affected=L, unaff=R)
% Column 5 -- [mse_min, mse, mse_max]; 
% Column 6 -- [rom_min, rom, rom_max];
nstd = 0.5; 
load(['data/datatable' num2str(nstd) 'std_acc_samp_prec.mat'])

%% Plot 1 -- ROM vs ; 
mse_ = []; 
rom_ = []; 
jt_ = []; 
id_ = [];  

for jt = 1 : 11
    figure(jt); hold all; 
    for i = 1:length(datatable)
        rm = []; 
            % control               jt                          R hand 
        if datatable{i}{2} == 1 && datatable{i}{3} == jt && datatable{i}{4} == 0
            rm = datatable{i}{6}(2); 
            mse = datatable{i}{5}(2); 
            id2_ = 1; 
            col = 'k'; 

            % control               jt                          L hand 
        elseif datatable{i}{2} == 1 && datatable{i}{3} == jt && datatable{i}{4} == 1
            rm = datatable{i}{6}(2); 
            mse = datatable{i}{5}(2); 
            id2_ = 0; 
            col = [.8, .8, .8];
        end
        
        if ~isempty(rm)
            
            % Plot in jt-specific figure; 
            plot(rm, mse, '.', 'MarkerSize', 20, 'Color', col); 
            
            % Save for use in LME model later
            mse_ = [mse_ mse];  
            rom_ = [rom_ rm]; 
            jt_ = [jt_ jt]; 
            id_ = [id_ id2_];  
            
        end
    end
    title(['Jt # ' num2str(jt)])
    xlabel('ROM')
    ylabel('MSE')
end

%% LME stats -- see if slope*ID is significant (random effects are jt)
T = table(id_', jt_', rom_', mse_', 'VariableNames', {'id','jt','rom','mse'}); 
lme_rom = fitlme(T, 'rom~1+id+(1|jt)'); 
lme_mse = fitlme(T, 'mse~1+id+(1|jt)'); 
