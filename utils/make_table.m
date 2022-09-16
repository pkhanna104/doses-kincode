function datatable = make_table(sessions, hands, jts, path_to_data)

datatable = {};
for i_s = 1:length(sessions) 
    
    sess = sessions{i_s}; 
    hand = hands{i_s}; 
    data = load([path_to_data sess '/valid_data.mat' ]); 
    data = data.data; 
    for j=1:length(jts)
        
        [angles,~] = jt_angle_list(jts{j}); 
        newjt = strrep(jts{j},' ','_'); 
        
        for a=1:length(angles)
    
            [ang_dat, ~, fld] = get_angle_data(newjt, hand, ...
                angles(a), data);
            
            for c = 1:length(ang_dat)
                
                true_angle = angles(a); 
                
                if and(contains(newjt, 'Prono'), contains(hand, 'Left')) % lH 
                   true_angle = true_angle*-1; 
                    
                % Abd angles go from +10, -20
                % LH angles go (-, CCW), RH angles go (+, CW)
                elseif and(contains(newjt, 'Abd'), contains(hand, 'Right')) % RH
                    true_angle = true_angle*-1;
                    
                % Horiz angles go from -30, 0, 30, + flex is inwards
                elseif and(contains(newjt, 'HorzFlex'), contains(hand, 'Right'))
                    true_angle = true_angle*-1; 
                    
                % Vert angles go from 0, -30, -60,  + is flex upward, - is flex downard 
                elseif contains(newjt, 'VertFlex')
                    true_angle = true_angle*-1; 
                   
                % Roll: (-30, 0, 30): + roll is inwards';
                elseif and(contains(newjt, 'Roll'), contains(hand, 'Left'))
                    true_angle = true_angle*-1; 
                end
                
                datatable{end+1} = {sess, hand, newjt, true_angle, ang_dat(c)}; 
            end
        end
    end
end


        