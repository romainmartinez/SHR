function conf = get_conf
if isunix
    conf.eDrive = '/media/romain/E/';
    conf.fDrive = '/media/romain/F/';
else
    conf.eDrive = '//10.89.24.15/e/';
    conf.fDrive = '//10.89.24.15/f/';
end

conf.path2data = sprintf('%sProjet_IRSST_LeverCaisse/ElaboratedData/matrices/cinematique/', conf.eDrive);
conf.path2rootmodel = sprintf('%sData/Shoulder/Lib/', conf.fDrive);

conf.modelnumber = 2;
conf.interpolateover = 100;
conf.height = 2;
conf.anatomical_correction = false;
conf.filter = 10;
conf.iteration = true;

conf.bodies = shr.util.get_body_markers(conf.modelnumber);