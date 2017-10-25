%{
    %   Description: compute scapulo humeral rhythm
    %
    %   author:  Romain Martinez
    %   email:   martinez.staps@gmail.com
    %   website: github.com/romainmartinez
%}

clear variables; clc; close all
% load S2M library
shr.util.load_lib

% get configuration data
conf = shr.util.get_conf;

% get data filenames
filenames = shr.util.get_filename(conf.path2data);

for iparticipant = filenames
    fprintf('\t%s\n', iparticipant{:})
    % get data
    load(sprintf('%s/%s', conf.path2data, iparticipant{:}));
    
    % open model
    model = shr.preprocessing.get_model(conf.path2model, iparticipant{:})
    
end

