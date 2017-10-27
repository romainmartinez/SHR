%{
    %   Description: compute scapulo humeral rhythm
    %
    %   author:  Romain Martinez
    %   email:   martinez.staps@gmail.com
    %   website: github.com/romainmartinez
%}

clear variables; clc; close all

% get configuration data
conf = shr.util.get_conf;

% load S2M library
shr.util.load_lib(conf.eDrive)

% get data filenames
filenames = shr.util.get_filename(conf.path2data);

i = 0; p = 0;
for iparticipant = filenames
    p = p + 1;
    fprintf('\t%s\n', iparticipant{:})
    
    % get data
    load(sprintf('%s/%s.mat', conf.path2data, iparticipant{:}));
    
    % open model
    model = shr.util.get_model(conf, iparticipant{:});

    for itrial = 1 : length(temp)
        if temp(itrial).hauteur == conf.height && temp(itrial).poids ~= 18
            i = i + 1;
            fprintf('\t\t%s\n', temp(itrial).trialname)
            
            % create scphmr object
            obj = shr.processing.scphmr(model, temp(itrial).Qdata.Q2, conf.bodies);
            % get scapulohumeral rhythm
            rhythm = obj.compute_scphmr();
            % cut trial
            cutted_rhythm = rhythm(uint16(temp(itrial).start):uint16(temp(itrial).end));
            
            % interpolate
            data.y(i, :) = shr.util.ScaleTime(cutted_rhythm, 1, length(cutted_rhythm), conf.interpolateover);
            data.weight(i) = temp(itrial).poids;
            data.participants(i) = p;
            switch temp(itrial).sexe
                case 'H'
                    sex = 1;
                case 'F'
                    sex = 2;
            end
            data.sex(i) = sex;
            verif{i,1} = iparticipant;
            verif{i,2} = temp(itrial).trialname;
        end
    end
    S2M_rbdl('delete', model)
end