classdef Class_Control
    % This class conect the app with all classes
    
    properties (SetAccess = public, GetAccess = public)
      
        tnt         Class_TNT               % TNT's properties
        plate       Class_Plate             % Plate's properties
        analysis    Class_Analysis          % Type Analysis propertie
        blast       Class_Blast
        result      Class_Result
                
        vrf          = 0;   % Verificating if total time of analysis is 
                            % bigger than the total time of the load 
                            % (for general analysis)
        
        total_time   = 0;   % Total time of blast wave behavior 
        S            = [];  % Matrix about general solution
        
    end
    
    %% Constructor method
    methods
        
        function this = Class_Control(analysis, blast, result)
            if (nargin > 0)
                this = this.TimeVerification(analysis, blast);
                this = this.callback_buttonGeneral(result);
            end
            
        end
        
        % =============================================================== %
        
        % Function to verificate the time of analysis
        function this = TimeVerification(this, analysis, blast)
                        
            % ----------------------------------------------------------- %
            
            % Verificating total time of analysis
            this.analysis   = analysis;
            this.blast      = blast;
            
            
            td              = this.blast.td;
            tm              = this.blast.tm;
            time            = this.analysis.time;
            this.total_time = td + tm;
                        
            % ----------------------------------------------------------- %
            
            % Avaliating conditions
            if this.total_time > time
                this.vrf = 0;
            elseif this.total_time <= time
                this.vrf = 1;
            end
            
        end
         
        % =============================================================== %
        
        % Function about the General Button
        function this = callback_buttonGeneral(this, result)
            
            % ----------------------------------------------------------- %
                        
            % Verificating condition
                      
            if this.vrf == 0
                
                msgbox...
                    (sprintf(['Total time of blast wave = %g s.' ...
                    'Please, insert a time of analysis bigger than total time.'], ...
                    this.total_time), 'Information', 'warn');
                
                this.S = 0;
                
            elseif this.vrf == 1
                
                % ------------------------------------------------------- %
                
                % Message Box appears with the message 'Calculating'
                % without Ok button
                if ~exist('hideOk','var')
                    hideOk = 1;
                end
                
                msg = msgbox({'Calculating....Please, wait.';...
                    'This may take a few minutes.'},...
                    'Information','help');
                child = get(msg,'Children');
                
                if hideOk
                    delete(child(1)); % Removes ok button
                    drawnow;
                end
                
                % ------------------------------------------------------- %
                
                % Calculating result
                this.result = result;
                this.S      = this.result.table;
                
                % ------------------------------------------------------- %
                
                % Close Message box
                
                close(msg);
                
            end
            
        end
        
        
    end
        
end