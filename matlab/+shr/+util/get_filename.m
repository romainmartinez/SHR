function output = get_filename(path2data)

mat_files = dir(sprintf('%s/*.mat', path2data));
output = {mat_files.name};

