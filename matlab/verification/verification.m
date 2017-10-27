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
data.TH = data.TH*180/pi;

subplot(211)
plot_rhythm(data, 'y')
subplot(212)
plot_rhythm(data, 'TH')
tightfig;

%_____
figure
time = 1:100;
g = gramm('x',time,'y',data.y,'color',data.sex);
g.facet_grid(data.weight, [],'scale','fixed','space','free');
g.stat_summary('type','std','setylim', true);
g.axe_property('TickDir','out');
g.draw();

%______
verif_data = [verif(sort(idx), 1) verif(sort(idx), 2)];
csvwrite('verif.csv', verif_data);

function plot_rhythm(data, kind)
d = data.(kind);
men6 = d(data.sex == 1 & data.weight == 6,:);
men12 = d(data.sex == 1 & data.weight == 12,:);
women6 = d(data.sex == 2 & data.weight == 6,:);
women12 = d(data.sex == 2 & data.weight == 12,:);
plot(mean(men6, 'omitnan')); hold on
plot(mean(men12, 'omitnan'));
plot(mean(women6, 'omitnan'));
plot(mean(women12, 'omitnan'));
legend({'men6', 'men12', 'women6', 'women12'})
end