function [baseline_meas, angle, fld] = get_angle_data(newjt, hand_nm, ...
    angle, data)

ang = num2str(angle);
newang = strrep(ang, '-', 'n');
fld = [hand_nm '_' newjt '_' newang];

if isfield(data, fld)
    cnt = data.(fld).cnt;
    for c = 1:cnt
        ang_str = ['Ang' num2str(c)];
        angle_struct = get_jt_angles(data.(fld).(ang_str), 'angle_validation');
        ang_dat = angle_struct.(newjt);
        
        switch c
            case 1 % First count of first joint -- make array
                baseline_meas = [mean(ang_dat)];
            otherwise % else add data to baseline
                baseline_meas = [baseline_meas mean(ang_dat)];
        end
    end
else
    baseline_meas = []; 
end