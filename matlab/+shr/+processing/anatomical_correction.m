function q_optim = anatomical_correction(model, conf, participant)

path2anato = sprintf('%sProjet_Reconstructions/DATA/Romain/%sd/MODEL%d/',...
    conf.eDrive, participant{:}, conf.modelnumber);

filename = dir(sprintf('%s%sd1_*d*.Q*', path2anato, participant{:}));
Q = load(sprintf('%s%s', path2anato, filename.name), '-mat');

% mean
Q0 = mean(Q.Q2,2);

% anatomical correction
q_optim = positionanato(model, Q0);

    function q_optim = positionanato(model, Q0)
        
        %  | r�f�rence | align� |
        %  |-----------|--------|
        % 1| zThorax   | zArm   |
        % 2| xScapula  | xArm   |
        % 3| xWrist    | xLoArm |
        % 4| zArm      | zLoArm |
        
        % DoF
        Arm    = 22:24;
        loArm1 = 25;
        loArm2 = 26;
        Wrist = 27:28;
        
        % lsqnonlin parameters
        options = optimoptions('lsqnonlin');

        function val = obj1(x)
            q = Q0;
            q(Arm(1:2)) = x;
            
            RL = S2M_rbdl('globalJCS', model ,q);
            
            zArm = RL(1:3,3,5);
            val  = zThorax-zArm;
        end
        
        function val = obj2(x)
            q = Q0;
            q(Arm(3)) = x;
            
            RL = S2M_rbdl('globalJCS', model ,q);
            
            xArm = RL(1:3,1,5);
            val  = xScapula-xArm;
        end
        
        function val = obj3(x)
            q = Q0;
            q(loArm1) = x;
            
            RL = S2M_rbdl('globalJCS', model ,q);
            zLoArm = RL(1:3,3,7);
            
            val    = zArm-zLoArm;
        end
        
        function val = obj4(x)
            q = Q0;
            q(loArm2) = x;
            
            RL = S2M_rbdl('globalJCS', model ,q);
            xLowArm2 = RL(1:3,1,7);
            
            val    = xLowArm2-xArm;
        end
        
        function val = obj5(x)
            q = Q0;
            q(Wrist) = x;
            
            RL = S2M_rbdl('globalJCS', model ,q);
            RWrist  = RL(1:3,2:3,8); RWrist = RWrist(:);
            val    = RWrist-RLowArm2;
        end
        
        % 1. | zThorax | zArm |
        RL = S2M_rbdl('globalJCS', model ,Q0);
        zThorax  = [0 0 1]'; %RL(1:3,3,2);
        Q0(Arm(1:2)) = lsqnonlin(@obj1,[0,0],[],[],options);
        
        % 2. | xScapula | xArm |
        RL = S2M_rbdl('globalJCS', model ,Q0);
        xScapula = RL(1:3,1,4);
        Q0(Arm(3))   = lsqnonlin(@obj2,0,[],[],options);
        
        % 3. | zArm | zLoArm |
        RL = S2M_rbdl('globalJCS', model ,Q0);
        zArm  = RL(1:3,3,5);
        Q0(loArm1)   = lsqnonlin(@obj3,0,[],[],options);
        
        % 4. | xLowArm2 | xArm |
        RL = S2M_rbdl('globalJCS', model ,Q0);
        xArm  = RL(1:3,1,5);
        Q0(loArm2)   = lsqnonlin(@obj4,0,[],[],options);
        
        % 5. | Wrist | LoArm2 |
        RL = S2M_rbdl('globalJCS', model ,Q0);
        RLowArm2  = RL(1:3,2:3,7); RLowArm2 = RLowArm2(:);
        Q0(Wrist)   = lsqnonlin(@obj5,[0 0],[],[],options);

        q_optim = Q0;
    end
end