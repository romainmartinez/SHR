classdef scphmr
    %SCPHMR compute scapulohumeral rhythm
    
    properties
        rhythm            % scapulohumeral rhythm
    end
    
    properties (Access = private)
        Q          % generalized coordinate
        model      % s2m model
        filter     % cut-off frequency of the low-pass filter
        bodies     % bodies ID
        q_modified
        zero
    end
    %------------------------------------%
    methods
        function self = scphmr(model, Q, bodies, varargin)
            % parse input
            p = inputParser;
            p.addRequired('model', @isinteger);
            p.addRequired('Q', @isnumeric);
            p.addRequired('bodies', @isstruct);
            p.addOptional('filter', 0, @isnumeric);
            p.addOptional('zero', 0, @isnumeric);
            p.parse(model, Q, bodies, varargin{:})
            
            self.model = p.Results.model;
            self.Q = p.Results.Q;
            self.bodies = p.Results.bodies;
            self.filter = p.Results.filter;
            self.zero = p.Results.zero;
            self.q_modified = self.Q;
        end % constructor
        %------------------------------------%
        
        function [rhythm, outTH] = compute_scphmr(self)
            % low pass filter (if filter ~= 0)
            if self.filter
                self.Q = self.lowpass(self.Q, self.filter);
            end
            
            body = {'normal','gh', 'ac', 'sc'};
            TH = zeros(length(self.Q), 4);
            for i = 1:length(body)
                [TH(:,i), self.q_modified] = self.get_ThoracoHumeralElevation(body{i},...
                    self.q_modified);
                
            end
            
            rhythm = (TH(:,1)-TH(:,2))./TH(:,2);
            % nan if < 3 degrees
            rhythm(TH(:,2)<3/180*pi) = nan;
            outTH = TH(:, 1);
        end
        
        function [TH_elevation, q_modified] = get_ThoracoHumeralElevation(self, body, q_modified)
            if ~strcmp(body, 'normal')
                % reset joint coordinates
                q_modified(self.bodies.(body),:) = repmat(self.zero(self.bodies.(body)), 1, length(q_modified));
            else
                q_modified = self.Q;
            end
            % get global JCS
            global_Q = S2M_rbdl('globalJCS', self.model, q_modified);
            % get RT body in thorax
            t_RT_body = multiprod(multitransp(squeeze(global_Q(1:3, 1:3, 2, :))),...
                squeeze(global_Q(1:3, 1:3, 5, :)));
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
    end % static methods
    
end

