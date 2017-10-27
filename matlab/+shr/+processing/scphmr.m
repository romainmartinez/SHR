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
        q_modified
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
            self.q_modified = self.Q;
            
            self.compute_scphmr();
        end % constructor
        %------------------------------------%
        
        function compute_scphmr(self)
            % low pass filter (if filter ~= 0)
            if self.filter
                self.Q = self.lowpass(self.Q, self.filter);
            end
            
            body = {'normal','gh', 'ac', 'sc'};            
            for i = 1:length(body)
                [TH(:,i), self.q_modified] = self.get_ThoracoHumeralElevation(body{i},...
                    self.q_modified);
            end
           
            rhythm = (TH(:,1)-TH(:,2))./TH(:,2);
            
            rhythm = cellfun(@(x) self.get_ScapuloHumeralRhythm(TH, body, x), body,...
                'UniformOutput', false);
            self.rhythm = [rhythm{:}];
        end
        
        function [TH_elevation, q_modified] = get_ThoracoHumeralElevation(self, body, q_modified)
            if ~strcmp(body, 'normal')
                % reset joint coordinates
                q_modified(self.bodies.(body),:) = 0;
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
        
        function rhythm = get_ScapuloHumeralRhythm(TH, body_list, body)
            if ~strcmp(body, 'normal')
                a = TH(:, contains(body_list, 'normal'));
                b = TH(:, contains(body_list, body));
                rhythm = (a - b)./b*100;
            else
                rhythm = [];
            end
        end
    end % static methods
    
end

