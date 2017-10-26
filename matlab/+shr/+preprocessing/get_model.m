function model = get_model(conf, participant)

path2model = sprintf('%s/%sd/Model_%d/Model.s2mMod',...
    conf.path2rootmodel, participant, conf.modelnumber);

model = S2M_rbdl('new', path2model);

