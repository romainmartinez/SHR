classdef scphmr
    %SCPHMR compute scapulohumeral rhythm
    
    properties
        rhythm            % scapulohumeral rhythm
        associated_bodies % bodies associated with the sh rhythm
    end
    
    properties (Access = private)
        Q          % generalized coordinate
        model      % s2m model
        filter     % cut-off frequency of the low-pass filter
        bodies     % bodies ID
    end
    %------------------------------------%
    methods
        function self = scphmr(model, Q, varargin)
            % parse input
            p = inputParser;
            p.addRequired('model', @isinteger);
            p.addRequired('Q', @isnumeric);
            p.addRequired('bodies', @isstruct);
            p.addOptional('filter', 0, @isnumeric);
            p.parse(model, Q, varargin{:})
            
            self.model = p.Results.model;
            self.Q = p.Results.Q;
            self.bodies = p.Results.bodies;
            self.filter = p.Results.filter;
            
            self.compute_scphmr();
        end % constructor
        %------------------------------------%
        
        function compute_scphmr(self)
            % low pass filter (if filter ~= 0)
            if self.filter
                self.Q = self.lowpass(self.Q, self.filter);
            end
            
            body = {'normal','gh', 'sc', 'ac'};
            TH = cellfun(@(x) self.get_ThoracoHumeralElevation(x), body,...
                'UniformOutput', false);
            TH = [TH{:}];
            
            rhythm = cellfun(@(x) self.get_ScapuloHumeralRhythm(TH, body, x), body,...
                'UniformOutput', false);
            self.rhythm = [rhythm{:}];
        end
        
        function TH_elevation = get_ThoracoHumeralElevation(self, body)
            if ~strcmp(body, 'normal')
                % reset joint coordinates
                self.Q(self.bodies.(body),:) = 0;
            end
            % get global JCS
            global_Q = S2M_rbdl('globalJCS', self.model, self.Q);
            % get RT body in thorax
            t_RT_body = multiprod(multitransp(squeeze(global_Q(:, :, 2, :))),...
                squeeze(global_Q(:, :, 5, :)));
            % get thoraco humeral angle
            TH_angle = angleRotation(t_RT_body, 'zyz');
            % get thoraco humeral elevation
            TH_elevation = squeeze(TH_angle(2, :, :));
        end
        
    end % methods
    
    %------------------------------------%
    
    methods(Static)
        function out = lowpass(d, fcut)
            Q_filtered = shr.processing.lpfilter(d', fcut, 100);
            out = Q_filtered';
        end
        
        function rhythm = get_ScapuloHumeralRhythm(TH, body_list, body)
            if ~strcmp(body, 'normal')
                a = TH(:, contains(body_list, 'normal'));
                b = TH(:, contains(body_list, body));
                rhythm = (a - b)./a*100;
            else
                rhythm = [];
            end
        end
    end % static methods
    
end

