%{
    %   Description: compute scapulo humeral rhythm
    %
    %   author:  Romain Martinez
    %   email:   martinez.staps@gmail.com
    %   website: github.com/romainmartinez
%}

clear variables; clc; close all

load('verif.mat')
load('data.mat')

idx = verif_gui(data.y');

verif_data = [verif(sort(idx), 1) verif(sort(idx), 2)];
csvwrite('verif.csv', verif_data);