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
    
    %_____________________
    
%     result = arrayfun(@(x) shr.processing.scphmr(x.Qdata.Q2),...
%         temp, 'uniformoutput', false);
    obj = shr.processing.scphmr(model, temp(1).Qdata.Q2, 'filter', 15);
        
    % low-pass filter
    
    % get tags
    
    % set Q to zero
    
    % get new tags
    
    S2M_rbdl('delete', model)
    %_____________________
    
    % cut trial
    
end