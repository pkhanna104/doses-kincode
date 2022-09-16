function plot_errors(data)

hand_nms = {'Left', 'Right'}; 
jts = {'Thumb MCP', % dot product
'Thumb DIP', % dot product 
'Index DIP', % dot product 
'Index PIP', % dot product 
'Index MCP', % dot product 
'Palm Flex', % angle diff 
'Palm Abd', % angle diff 
'Palm Prono', % abs angle ** 
'Elbow Flex', % dot product 
'Shoulder Roll', % abs angle ** 
'Shoulder VertFlex', % abs angle ** 
'Shoulder HorzFlex'}; % abs angle ** 

colors = containers.Map({ 'DIP' 'PIP' 'MCP', 'Palm', 'Elbow', 'Shoulder'},...
    {5*[20,20,20],5*[20,20,20],[186,186,186],[186,186,186],[244,165,130], [202,0,32]}); 

% Figures: 
% 1) True angle vs. plotted angle 

% 2) Error --> for angles without abs values, assess deviation from initial
% point 

% 3) Joint error (grouped)


% Go through jts 

figure(1); hold all; 
figure(2); hold all;  
jt_ang_cnt = 0; xlab_jt_ang = {}; 

figure(3); hold all;  
jt_cnt = 0; xlab_jt = {}; 

figure(4); hold all; % differential errors

for j=1:length(jts)
    [angles,~] = jt_angle_list(jts{j}); 
    newjt = strrep(jts{j},' ','_'); 
    
    if contains(jts{j}, 'DIP')
        color = colors('DIP'); 
    elseif contains(jts{j}, 'PIP')
        color = colors('PIP');
    elseif contains(jts{j}, 'MCP')
        color = colors('MCP');
        % exception for thumb MCP
        if contains(jts{j}, 'Thumb')
            color = colors('PIP'); 
        end
    elseif contains(jts{j}, 'Palm')
        color = colors('Palm'); 
    elseif contains(jts{j}, 'Elbow')
        color = colors('Elbow'); 
    elseif contains(jts{j}, 'Shoulder')
        color = colors('Shoulder');
    else
        disp('jt error'); 
    end
    color = color/256; 
    
    jt_error = []; 
    jt_derror = []; 
    
    
    
    % loop thruogh hands
    for hand=1:2
        
        %%% Get baseline for this angle %%%
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
        
        [baseline_meas, baseline_true, ~] = get_angle_data(newjt, hand_nms{hand}, ...
            angles(ang_baseline), data); 
        
        % Correction for opposites 
        if and(contains(newjt, 'Prono'), hand == 1) % LH 
            baseline_true = baseline_true*-1;
        elseif and(contains(newjt, 'Abd'), hand == 2) % RH
            baseline_true = baseline_true*-1; 
        elseif contains(newjt, 'VertFlex') % LH
            baseline_true = baseline_true*-1;
        elseif and(contains(newjt, 'HorzFlex'), hand == 2) % RH
            baseline_true = baseline_true*-1;
        elseif and(contains(newjt, 'Roll'), hand == 1) % LH
            baseline_true = baseline_true*-1;
        end
        
        if ~isempty(baseline_meas)

            % angles 
            for a=1:length(angles)

                jt_hand_ang_error = []; 

                [ang_dat, ~, fld] = get_angle_data(newjt, hand_nms{hand}, ...
                angles(a), data);
            
                if ~isempty(ang_dat)

                    jt_hand_ang = ang_dat; 

                    %%% Calculate deviations %%% 
                    true_angle = angles(a); 
                    
                    % Prono angles go from 0, 90, 180
                    % LH angles go (-, CCW), RH angles go (+, CW)
                    if and(contains(newjt, 'Prono'), hand == 1) % lH 
                        true_angle = true_angle*-1; 
                    
                    % Abd angles go from +10, -20
                    % LH angles go (-, CCW), RH angles go (+, CW)
                    elseif and(contains(newjt, 'Abd'), hand == 2) % RH
                        true_angle = true_angle*-1;
                    
                    % angles go from 0 --> -60, but all go 0 --> +60
                    elseif contains(newjt, 'VertFlex') % LH
                        true_angle = true_angle*-1; 
                        
                    % angles go from -30 --> 30 but RH go 30 --> -30
                    elseif and(contains(newjt, 'HorzFlex'), hand == 2) % RH
                        true_angle = true_angle*-1; 
                    
                    elseif and(contains(newjt, 'Roll'), hand == 1) % LH
                        true_angle = true_angle*-1; 
                    end
            
                    true_dev = true_angle - baseline_true; 
                    meas_dev = []; 
                    ang_diff = []; 

                    for k=1:length(ang_dat)
                        meas_dev_i = ang_dat(k)-mean(baseline_meas); 
                        meas_dev = [meas_dev meas_dev_i]; 
                        ang_diff = [ang_diff circularSub(true_dev, meas_dev_i)]; 
                    end

                    % Add to jt_hand_error --> 
                    if or(contains(newjt, 'Shoulder'), contains(newjt, 'Prono'))
                        jt_hand_ang_error = [jt_hand_ang_error, ang_diff]; 
                        jt_error = [jt_error, ang_diff]; 
                    else
                        jt_hand_ang_error = [jt_hand_ang_error, true_angle - ang_dat]; 
                        jt_error = [jt_error, true_angle - ang_dat]; 
                    end

                    % All add to d-error 
                    jt_derror = [jt_derror, ang_diff]; 
                        
                    
                    % Plotting !!!! 
                    jt_ang_cnt = jt_ang_cnt + 1; 
                    xlab_jt_ang{jt_ang_cnt} = fld; 
                    
                    figure(1);
                    h = bar(jt_ang_cnt, mean(jt_hand_ang)); 
                    set(h,'FaceColor',color)
                    plot(randn(1, length(jt_hand_ang))*.1 + jt_ang_cnt, jt_hand_ang, 'k.')
                    
                    figure(2);
                    h = bar(jt_ang_cnt, mean(jt_hand_ang_error));
                    set(h,'FaceColor',color)
                    plot(randn(1, length(jt_hand_ang_error))*.1 + jt_ang_cnt, jt_hand_ang_error, 'k.')
                end
            end
        end
    end
    
    if ~isempty(jt_error)
        jt_cnt = jt_cnt + 1; 
        xlab_jt{jt_cnt} = newjt; 
        
        figure(3); 
        h = bar(jt_cnt, mean(jt_error)); 
        set(h,'FaceColor',color)
        plot(randn(1, length(jt_error))*.1 + jt_cnt, jt_error, 'k.')
        
        figure(4); 
        h = bar(jt_cnt, mean(jt_derror)); 
        set(h,'FaceColor',color)
        plot(randn(1, length(jt_derror))*.1 + jt_cnt, jt_derror, 'k.')

    end
end

figure(1); 
xticks(1:length(xlab_jt_ang));
xticklabels(xlab_jt_ang);
xtickangle(90); 

figure(2); 
xticks(1:length(xlab_jt_ang));
xticklabels(xlab_jt_ang); 
xtickangle(90); 
        
figure(3); 
xticks(1:length(xlab_jt));
xticklabels(xlab_jt); 
xtickangle(90); 

figure(4); 
xticks(1:length(xlab_jt));
xticklabels(xlab_jt); 
xtickangle(90); 
                    
                    
                    
                    
                    
                    
                    
                    
                    
                