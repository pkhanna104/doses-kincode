% Plot DIP vs. PIP roll during the task period for all subjects
subjects = ["PK","FR","AV","SB", "B8M","C9K","B12J","W16H_small","S13J_small","R15J_small"];

s_index_pip = 6;
s_index_dip = 7;
figure; hold all;
cnt = 0; 
n = 10; 
for a = 1:3 %size(subjects,2)
    for m = 2:2

        % Gather the angle data
        disp([num2str(cnt), subjects(n)])

        if m == 1
            data_key = 'unaffected';
        else
            data_key = 'affected';
        end

        if n <= 4
            add_to_task_name = '_ctrl';
            folder = 'controls';
        else
            add_to_task_name = '';
            folder = 'patient';
        end

        fname = strcat('data/task_data/', folder, '/',subjects(n),...
            add_to_task_name, '_pinch_data.mat');

        dat = load(fname);
        %pip_roll = (dat.(data_key).pos_data(:, a, s_index_pip));
        dip_roll = (dat.(data_key).angle_data(:, a, s_index_dip));
        
        % Unroll 
        %pip = unroll_sensor(pip_roll);
        %dip = unroll_sensor(dip_roll);
        
        % Variance 
        %bar(cnt, var(dip))
        plot(dip_roll)
        cnt = cnt + 1; 


    end
end

