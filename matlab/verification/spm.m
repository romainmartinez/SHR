%{
    %   Description: compute scapulo humeral rhythm
    %
    %   author:  Romain Martinez
    %   email:   martinez.staps@gmail.com
    %   website: github.com/romainmartinez
%}

clear variables; clc; close all

load('./data/verif.mat')
load('./data/data.mat')

if ~contains(path, 'spm')
    addpath(genpath('D:/Download/spm1dmatlab-master'));
end

p.anova = 0.05;

replaceNaNbyMean(data)

% Two-way ANOVA with repeated-measures on one factor
anova2.spmlist  = spm1d.stats.anova2onerm(data.y, data.sex, data.weight, data.participants);
anova2.spmilist = anova2.spmlist.inference(p.anova);

function replaceNaNbyMean(data)
idx = 0;
for isex = 1:2
    for iweight = [6 12]
        idx = idx + 1;
        id(idx, :) = data.sex == isex & data.weight == iweight;
    end
end

for group = 1:4
    y = data.y(id(group, :), :);
    nan_idx = isnan(y);
    mean_group = mean(y, 'omitnan');
    
    mean
    
    
end
end