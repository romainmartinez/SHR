function output = get_filename(path2data)

mat_files = dir(sprintf('%s/*.mat', path2data));

output = cellfun(@(x) delete_extension(x, '.mat', ''), {mat_files.name}, 'UniformOutput', false);

    function out = delete_extension(filename, pattern, replacement)
        out = regexprep(filename,pattern,replacement);
    end
end

