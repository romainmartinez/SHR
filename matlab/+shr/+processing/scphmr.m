classdef scphmr
    %SCPHMR compute scapulohumeral rhythm
    
    properties
        Q          % generalized coordinate
    end
    
    properties (Access = private)
        model      % s2m model
        filter     % cut-off frequency of the low-pass filter
    end
    
    %------------------------------------%
    methods
        
        function self = scphmr(model, Q, varargin)
            % parse input
            p = inputParser;
            p.addRequired('model', @isinteger);
            p.addRequired('Q', @isnumeric);
            p.addOptional('filter', 0, @isnumeric);
            p.parse(model, Q, varargin{:})
            
            self.model = p.Results.model;
            self.Q = p.Results.Q;
            self.filter = p.Results.filter;
            
            % low pass filter (if filter ~= 0)
            if self.filter
                self.Q = self.lowpass(self.filter);
            end
            
            T = self.get_markers();
            
        end % constructor
        
        %------------------------------------%
        function out = lowpass(self, fcut)
             Q_filtered = shr.processing.lpfilter(self.Q', fcut, 100);
             out = Q_filtered';
        end
        
        function out = get_markers(self)
            out = S2M_rbdl('Tags', self.model, self.Q);
        end
    end
    
end

