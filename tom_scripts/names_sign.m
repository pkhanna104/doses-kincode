function [input1 input sign] = names_sign(Filename);

    names = ["W16H","S13J","R15J"];
    str = convertCharsToStrings(Filename);

    if contains(str,names)
        input1 = extractBefore(str,"_small_pinch_data.mat"); %reference to excell sheet number/file doesn't have "_small"... in excel sheet name
    else
        input1 = extractBefore(str,"_pinch_data.mat");
    end
    
    if any(convertCharsToStrings(input1) == names)
        input = string(strcat(input1,'_small')); %reference to angles produced from Preeya and parsed using my function jt_angle_calc(_aff)
        %needed for obtaining (input)_jt_angle_un( or aff).mat
    else
        input = input1;
    end
    
    pos = ["B8M","C9K","B12J","W16H","S13J","R15J"];
    
    if any(convertCharsToStrings(input1) == pos)
        sign = 1; %1 for patients, -1 for controls -> z-axis flipped!!!
    else
        sign = -1; %1 for patients, -1 for controls -> z-axis flipped!!!
    end