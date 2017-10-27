function load_lib(eDrive)
% S2M library
if ~contains(path, 'S2M_Lib')
    try
        disp('loading S2M library...')
        run(sprintf('%sLibrairies/S2M_Lib/S2MLibPicker.m', eDrive))
    catch
        warning('cannot load S2M library');
    end
end

