function [rom_min, rom_max, rom] = calc_rom_w_bootstrapped_error(jt, min_ratio, max_ratio)

% original ROM, calculating to make sure one at the end matches this one
rom = std(jt);

% min ratio is min of std_meas/std_true
% e(std_true) = std_meas * factor(std_true/std_meas)
% e(std_true) = std_meas * 1/ratio 
min_factor = min([1., min_ratio]); 
max_factor = max([1., max_ratio]); 
rom_min = rom*min_factor; 
rom_max = rom*max_factor; 

