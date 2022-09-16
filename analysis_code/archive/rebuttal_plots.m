% Plot to show repeated measurements reliability %
% Pooling over (L/R hand), (days) measurements, show individual measurement
% vs. session mean is reliable

sessions = {'pk-8-24', 'pk-8-24', 'pk-8-25-v2', 'pk-8-26',...
    'pk-8-26-R', 'pk-8-26-R2-edited'};

hand = {'Left', 'Right', 'Left', 'Left', 'Right', 'Right'};

jts = {'Thumb MCP', % dot product
    'Thumb DIP', % dot product
    'Index DIP', % dot product
    'Index PIP', % dot product
    'Index MCP', % dot product
    'Palm Flex', % angle diff
    'Palm Abd', % angle diff
    'Palm Prono', % abs angle **
    'Elbow Flex'};

%% Make datatable 
datatable = make_table(sessions, hand, jts);

%% Figure 1; make plot for each jt -- showing hysteresis;
for j = 1:length(jts)
    newjt = strrep(jts{j},' ','_');
    
    figure; hold all;
    angles = [];
    
    for i = 1:length(datatable)
        if contains(datatable{i}{3}, newjt)
            
            t = datatable{i}{4};
            m = datatable{i}{5};
            
            if contains(datatable{i}{2}, 'Left')
                plot(t, m, 'b.');
            elseif contains(datatable{i}{2}, 'Right')
                plot(t, m, 'r.');
            end
            angles = [angles t];
        end
    end
    
    xlim([min(angles) - 5, max(angles) + 5]);
    ylim([min(angles) - 5, max(angles) + 5]);
    plot([min(angles), max(angles)], [min(angles), max(angles)], 'k--');
    title(jts{j});
    xlabel('True Angle')
    ylabel('Measured Angle')
    
end

%% Figure 2; across all sessions -- within-session reliability
figure; hold all
xoff = 1;
xlab = {};

for j=1:length(jts)
    newjt = strrep(jts{j},' ','_');
    [angles,~] = jt_angle_list(jts{j});
    
    jt_error = [];
    
    for s=1:length(sessions)
        data = load([sessions{s} '/valid_data.mat' ]);
        data = data.data;
        
        hd = hand{s};
        
        for a=1:length(angles)
            
            [ang_dat, ~, fld] = get_angle_data(newjt, hd, angles(a),...
                data);
            
            % mean
            ang_dat_mn = mean(ang_dat);
            diff = ang_dat - ang_dat_mn;
            jt_error = [jt_error diff];
        end
        
    end
    
    h = bar(xoff, mean(jt_error));
    set(h,'FaceColor',[150, 150, 150]/255);
    plot(xoff + randn(1, length(jt_error))*.1, jt_error, 'k.');
    xlab{end+1} = newjt;
    
    xoff = xoff + 1;
    
end
xticks(1:xoff);
xticklabels(xlab);
xtickangle(90);

%% Figure 3; Repeated subject -- across session var 
jt_error = struct();

for s=1:length(sessions)
    data = load([sessions{s} '/valid_data.mat' ]);
    data = data.data;
    
    hd = hand{s};
    
    for j=1:length(jts)
        newjt = strrep(jts{j},' ','_');
        [angles,~] = jt_angle_list(jts{j});
        
        for a=1:length(angles)
            
            [ang_dat, ~, fld] = get_angle_data(newjt, hd, angles(a),...
                data);
            newang = strrep(num2str(angles(a)), '-', 'n');
            
            fld = [newjt '_' newang]; 
            
            if isfield(jt_error, fld)
                jt_error.(fld) = [jt_error.(fld) ang_dat]; 
            else
                jt_error.(fld) = [ang_dat]; 
            end
            
        end
    end
end

figure; hold all
xoff = 1;
xlab = {};

for j=1:length(jts)
    newjt = strrep(jts{j},' ','_');
    [angles,~] = jt_angle_list(jts{j});
    
    jt_error_xsess = []; 
    
    for a=1:length(angles)
        newang = strrep(num2str(angles(a)), '-', 'n');
        fld = [newjt '_' newang];
        
        mean_ang = circMean(jt_error.(fld)); 
        
        % Demean 
        diffs = []; 
        for i = 1:length(jt_error.(fld))
            diffs = [diffs circularSub(jt_error.(fld)(i), mean_ang)];
        end
        jt_error_xsess = [jt_error_xsess diffs]; 
    end
    
    h = bar(xoff, mean(jt_error_xsess)); hold all; 
    set(h,'FaceColor',[150, 150, 150]/255);
    errorbar(xoff, mean(jt_error), std(jt_error), 'color','k')
    %plot(xoff + randn(1, length(jt_error))*.1, jt_error, 'k.');
    %boxplot(jt_error, 'positions', [xoff], 'colors','k')
    newjt2 = strrep(newjt, '_', ' '); 
    xlab{end+1} = newjt2;
    xoff = xoff + 1;
    
end

xticks(1:xoff);
xticklabels(xlab);
xtickangle(90);
ylim([-10, 10])
ylabel('Degrees')

%% Figure 4; plot across sesssion joint errors 
figure; subplot(2, 1, 1); hold all; 
subplot(2, 1, 2); hold all; 

% Get baseline for prono for each hand / session 
baseline_prono = struct(); 
newjt = 'Palm_Prono'; 
for s = 1:length(sessions)
    sess = sessions{s}; 
    newsess = strrep(sess, '-', '_'); 
    
    hd = hand{s}; 
    
    for i=1:length(datatable)
        if contains(datatable{i}{3}, newjt) && contains(datatable{i}{1}, sess) && contains(datatable{i}{2}, hd)
            
            if abs(datatable{i}{4}) == 90
                
                fld = [newsess '_' hd ]; 
                fld2 = [newsess '_' hd '_true_ang']; 
                
                if isfield(baseline_prono, fld)
                    baseline_prono.(fld) = [baseline_prono.(fld) datatable{i}{5}]; 
                else
                    baseline_prono.(fld) = [datatable{i}{5}]; 
                    baseline_prono.(fld2) = datatable{i}{4}; 
                end
            end
        end
    end
end

xoff = 1; 
xs = []; 
xlabs = {}; 

for j = 1:length(jts)
    newjt = strrep(jts{j},' ','_');
    R = 0; 
    L = 0;     
    
    for s = 1:length(sessions)
        hd = hand{s}; 
        jt_error = []; 


        for i = 1:length(datatable)
            if contains(datatable{i}{3}, newjt) && contains(datatable{i}{1}, sessions{s}) && contains(datatable{i}{2}, hd)

                t = datatable{i}{4}; % true 
                m = datatable{i}{5}; % measured

                if contains(newjt, 'Palm_Prono')
                    newsess = strrep(datatable{i}{1}, '-', '_'); 
                    hd = datatable{i}{2}; 
                    fld = [newsess '_' hd]; 
                    fld2 = [newsess '_' hd '_true_ang']; 

                    true_baseline = baseline_prono.(fld2); 
                    meas_baseline = mean(baseline_prono.(fld)); 

                    true_dev = datatable{i}{4} - true_baseline; 
                    meas_dev = datatable{i}{5} - meas_baseline; 
                    jt_error = [jt_error circularSub(meas_dev, true_dev)]; 

                else
                    jt_error = [jt_error m-t]; 
                end
            end
        end
        
        if contains(hd, 'Left')
            subplot(2, 1, 1); 
            h = bar(xoff + L*.25, mean(jt_error), .25); 
            set(h,'FaceColor',(L*50 + [100,100,100])/255);
            L = L + 1; 
        elseif contains(hd, 'Right')
            disp(['R ' sessions{s} ', ' newjt]); 
            subplot(2, 1, 2); 
            h = bar(xoff + R*.25, mean(jt_error), .25); 
            set(h,'FaceColor',(R*50 + [100,100,100])/255);
            R = R + 1; 
        end
            
    end
    xs = [xs xoff]; 
    xlabs{end+1} = newjt; 
    xoff = xoff + 1;
end
subplot(2, 1, 1); 
ylabel('Left hand angular errors'); 
xticks([1:9] + 0.5)
xticklabels(xlabs)
xtickangle(90);
xlim([0, 10])

subplot(2, 1, 2); 
ylabel('Right hand angular errors'); 
xticks([1:9] + 0.5)
xticklabels(xlabs)
xtickangle(90);

%% Figure 5; plot across sesssion joint deviation errors 
figure; subplot(2, 1, 1); hold all; 
subplot(2, 1, 2); hold all; 

% Get baseline for prono for each hand / session 
baseline = struct(); 
for j = 1:length(jts)
    newjt = strrep(jts{j},' ','_');
    [angles,~] = jt_angle_list(jts{j}); 

    switch length(angles)
        case 2
            ang_baseline = 1;
        case 3
            ang_baseline = 2;
        case 4
            ang_baseline = 2;
        case 5
            ang_baseline = 3;
    end
    
    for s = 1:length(sessions)
        
        sess = sessions{s}; 
        newsess = strrep(sess, '-', '_'); 

        hd = hand{s}; 
        
        % Baseline angle 
        baseline_angle = angles(ang_baseline);
        
        if and(contains(newjt, 'Prono'), contains(hd, 'Left')) % lH
            baseline_angle = baseline_angle*-1;
        elseif and(contains(newjt, 'Abd'), contains(hd, 'Right'))
            baseline_angle = baseline_angle*-1;
        end
        

        for i=1:length(datatable)
            if contains(datatable{i}{3}, newjt) && contains(datatable{i}{1}, sess) && contains(datatable{i}{2}, hd)

                if datatable{i}{4} == baseline_angle

                    fld = [newjt '_' newsess '_' hd ]; 
                    fld2 = [newjt '_' newsess '_' hd '_true_ang']; 

                    if isfield(baseline, fld)
                        baseline.(fld) = [baseline.(fld) datatable{i}{5}]; 
                    else
                        baseline.(fld) = [datatable{i}{5}]; 
                        baseline.(fld2) = datatable{i}{4}; 
                    end
                end
            end
        end
    end
end

xoff = 1; 
xs = []; 
xlabs = {}; 

for j = 1:length(jts)
    newjt = strrep(jts{j},' ','_');
    R = 0; 
    L = 0;     
    
    for s = 1:length(sessions)
        hd = hand{s}; 
        jt_error = []; 

        for i = 1:length(datatable)
            if contains(datatable{i}{3}, newjt) && contains(datatable{i}{1}, sessions{s}) && contains(datatable{i}{2}, hd)

                t = datatable{i}{4}; % true 
                m = datatable{i}{5}; % measured

                
                newsess = strrep(datatable{i}{1}, '-', '_'); 
                hd = datatable{i}{2}; 
                fld = [newjt '_' newsess '_' hd]; 
                fld2 = [newjt '_' newsess '_' hd '_true_ang']; 

                if isfield(baseline, fld2)
                    true_baseline = baseline.(fld2); 
                    meas_baseline = mean(baseline.(fld)); 

                    true_dev = datatable{i}{4} - true_baseline; 
                    meas_dev = datatable{i}{5} - meas_baseline; 
                    jt_error = [jt_error circularSub(meas_dev, true_dev)]; 
                end

            end
        end
        
        if contains(hd, 'Left')
            subplot(2, 1, 1); 
            h = bar(xoff + L*.25, mean(jt_error), .25); 
            set(h,'FaceColor',(L*50 + [100,100,100])/255);
            %plot(xoff + L*.25 + randn(1, length(jt_error))*.05, jt_error, 'k.')
            errorbar(xoff + L*.25, mean(jt_error), std(jt_error)/sqrt(length(jt_error)))
            L = L + 1; 
        
        elseif contains(hd, 'Right')
            disp(['R ' sessions{s} ', ' newjt]); 
            subplot(2, 1, 2); 
            h = bar(xoff + R*.25, mean(jt_error), .25); 
            %plot(xoff + R*.25 + randn(1, length(jt_error))*.05, jt_error, 'k.')
            set(h,'FaceColor',(R*50 + [100,100,100])/255);
            errorbar(xoff + R*.25, mean(jt_error), std(jt_error)/sqrt(length(jt_error)))
            R = R + 1; 
        end
            
    end
    xs = [xs xoff]; 
    xlabs{end+1} = newjt; 
    xoff = xoff + 1;
end
subplot(2, 1, 1); 
ylabel('Left hand angular deviations'); 
xticks([1:9] + 0.5)
xticklabels(xlabs)
xtickangle(90);
xlim([0, 10])

subplot(2, 1, 2); 
ylabel('Right hand angular deviations'); 
xticks([1:9] + 0.5)
xticklabels(xlabs)
xtickangle(90);
