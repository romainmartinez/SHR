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

for iparticipant = filenames
    fprintf('\t%s\n', iparticipant{:})
    
    % get data
    load(sprintf('%s/%s.mat', conf.path2data, iparticipant{:}));
    
    % open model
    model = shr.util.get_model(conf, iparticipant{:});
    
    % compute scapulohumeral rhythm
    result = arrayfun(@(x) shr.processing.scphmr(model, x.Qdata.Q2, conf.bodies),...
        temp, 'uniformoutput', false);
    
    S2M_rbdl('delete', model)

    % cut trial
    % interpolate
    % export matrix
end