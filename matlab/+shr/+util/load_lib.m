function load_lib
% S2M library
if ~contains(path, 'S2M_Lib')
    try
        run('/media/romain/E/Librairies/S2M_Lib/S2MLibPicker.m')
    catch
        warning('cannot load S2M library');
    end
end

