function angles = mod_true_angles(angles, jt, hand)

    if and(contains(jt, 'Prono'), contains(hand, 'Left')) % lH 
       angles = angles*-1; 

    % Abd angles go from +10, -20
    % LH angles go (-, CCW), RH angles go (+, CW)
    elseif and(contains(jt, 'Abd'), contains(hand, 'Right')) % RH
        angles = angles*-1;

    % Horiz angles go from -30, 0, 30, + flex is inwards
    elseif and(contains(jt, 'HorzFlex'), contains(hand, 'Right'))
        angles = angles*-1; 

    % Vert angles go from 0, -30, -60,  + is flex upward, - is flex downard 
    elseif contains(jt, 'VertFlex')
        angles = angles*-1; 

    % Roll: (-30, 0, 30): + roll is inwards';
    elseif and(contains(jt, 'Roll'), contains(hand, 'Left'))
        angles = angles*-1; 
    end
end
                
