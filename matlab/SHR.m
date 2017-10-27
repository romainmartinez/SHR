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

idx = 0;
for iparticipant = filenames
    fprintf('\t%s\n', iparticipant{:})
    
    % get data
    load(sprintf('%s/%s.mat', conf.path2data, iparticipant{:}));
    
    % open model
    model = shr.util.get_model(conf, iparticipant{:});
    
    for i = 1 : length(temp)
        if temp(i).hauteur == 2
            idx = idx + 1;
            fprintf('\t\t%s\n', temp(i).trialname)
            
            % create scphmr object
            obj = shr.processing.scphmr(model, temp(i).Qdata.Q2, conf.bodies);
            % get scapulohumeral rhythm
            rhythm = obj.compute_scphmr();
            
            % interpolate
            y(idx, :) = shr.util.ScaleTime(rhythm, 1, length(rhythm), conf.interpolateover);
        end
    end
    
    S2M_rbdl('delete', model)
    
    % cut trial
    % interpolate
    % export matrix
end