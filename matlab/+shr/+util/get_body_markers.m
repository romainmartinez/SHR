function DoF = get_body_markers(model)
% get DoF and markers associated with each body
switch model
    case 2
        DoF.pelvis = 1:6;
        DoF.thorax = 7:12;
        DoF.ac = 13:15;
        DoF.sc = 16:18;
        DoF.gh = 19:24;
        DoF.lowerarm1 = 25;
        DoF.lowerarm2 = 26;
        DoF.hand = 27:28;
    otherwise
        disp('choose a valid model (2 or 3)')
end

% | num | DoF            | segment   | seq |
% |----------------------------------------|
% | 1   | Pelvis_TransX  | Pelvis    | x   |
% | 2   | Pelvis_TransY  | Pelvis    | y   |
% | 3   | Pelvis_TransZ  | Pelvis    | z   |
% | 4   | Pelvis_RotX    | Pelvis    | x   |
% | 5   | Pelvis_RotY    | Pelvis    | y   |
% | 6   | Pelvis_RotZ    | Pelvis    | z   |
% |----------------------------------------|
% | 7   | Thorax_TransX  | Thorax    | x   |
% | 8   | Thorax_TransY  | Thorax    | y   |
% | 9   | Thorax_TransZ  | Thorax    | z   |
% | 10  | Thorax_RotX    | Thorax    | x   |
% | 11  | Thorax_RotY    | Thorax    | y   |
% | 12  | Thorax_RotZ    | Thorax    | z   |
% |----------------------------------------|
% | 13  | Clavicule_RotZ | Clavicule | z   |
% | 14  | Clavicule_RotY | Clavicule | y   |
% | 15  | Clavicule_RotX | Clavicule | x   |
% |----------------------------------------|
% | 16  | Scapula_RotZ   | Scapula   | z   |
% | 17  | Scapula_RotY   | Scapula   | y   |
% | 18  | Scapula_RotX   | Scapula   | x   |
% |----------------------------------------|
% | 19  | Arm_TransX     | Arm       | x   |
% | 20  | Arm_TransY     | Arm       | y   |
% | 21  | Arm_TransZ     | Arm       | z   |
% | 22  | Arm_RotZ       | Arm       | z   |
% | 23  | Arm_RotY       | Arm       | y   |
% | 24  | Arm_RotZ       | Arm       | z   |
% |----------------------------------------|
% | 25  | LowerArm1_RotX | LowerArm1 | x   |
% |----------------------------------------|
% | 26  | LowerArm2_RotZ | LowerArm2 | z   |
% |----------------------------------------|
% | 27  | Hand_RotX      | Hand      | x   |
% | 28  | Hand_RotY      | Hand      | y   |