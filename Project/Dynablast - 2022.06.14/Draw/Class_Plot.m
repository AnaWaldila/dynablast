classdef Class_Plot < handle
    
    % This class draw all the graphics and figures in App_Blast
    
    % Variables
    % type: type of explosion (1 for Hemispherical and 2 for Spherical)
    % sup: type of support (0 for simple support and 1 for campled)
    % type_sup: type of support of membrane (1 for immovable,
    % 2 for movable and 3 for stress free)
    % phase: phase for analisys (1 for positive phase,
    % 2 for negative phase, 3 for free vibration)
    % a: length for x direction (m)
    % beta: ratio a / b
    % E: Young's Modulus (N/m²)
    % h: tickness (m)
    % nu: Poisson's coeficient
    % rho: material's density (kg/m³)
    % Z: Scale distance (kg/m^1/3)
    % W: TNT's mass (kg)
    % time: time of analisys (s)
    % nonlinear: nonlinear effect (0 for not and 1 for yes)
    % negative: negative phase (0 for not and 1 for yes)
       
    properties (Constant)
        
        RED       = [1 0 0];
        GREEN     = [0 1 0];
        BLUE      = [0 0 1];
        BLACK     = [0 0 0];
        scale     = 10;
        ang_front = pi / 10;
        ang_back  = pi / 6;
        
    end
    
    %% Static Methods
    
    methods (Static)
        
        % =============================================================== %
        
        % Function to verificate the legend of the graphic
        function [legend_sup, color_sup] = GraphicMembers(nonlinear, type_sup)
            
            draw = Class_Plot;
            
            switch nonlinear
                case 0
                    legend_sup = 'Linear case';
                    color_sup = draw.BLACK;
                case 1
                    switch type_sup
                        case 1
                            legend_sup = 'Immovable Case';
                            color_sup = draw.RED;
                        case 2
                            legend_sup = 'Movable Case';
                            color_sup = draw.GREEN;
                        case 3
                            legend_sup = 'Stress Free Case';
                            color_sup = draw.BLUE;
                    end
            end
            
        end
        
        % =============================================================== %
        
        % Function to draw the graphic
        function drawPlate(graphic_local, a, beta, h, nonlinear, type_sup)
            
            draw = Class_Plot;
            b = a / beta;
            thick     = h * draw.scale;
            [~, color_sup] = draw.GraphicMembers(nonlinear, type_sup);
            
            % ----------------------------------------------------------- %
            
            % Frontal Plate
            
            XF = [- a/2 * cos(draw.ang_front), ... 
                    a/2 * cos(draw.ang_front), ...
                    a/2 * cos(draw.ang_front), ...
                  - a/2 * cos(draw.ang_front), ...
                  - a/2 * cos(draw.ang_front)];
            
            YF = [  b/2     + (a/2)     * sin(draw.ang_front), ...
                    b/2     - (a/2)     * sin(draw.ang_front), ...
                    -b/2    - (a/2)     * sin(draw.ang_front), ...
                    -b/2    + (a/2)     * sin(draw.ang_front), ...
                    b/2     + (a/2)     * tan(draw.ang_front)];
            
            % ----------------------------------------------------------- %
            
            % Back Plate
            
            XB = [- a/2 * cos(draw.ang_front) + thick * cos(draw.ang_back), ...
                    a/2 * cos(draw.ang_front) + thick * cos(draw.ang_back),...
                    a/2 * cos(draw.ang_front) + thick * cos(draw.ang_back)];
            
            YB = [b/2 + (a/2) * sin(draw.ang_front) + ...
                thick * sin(draw.ang_back), ...
                  b/2 - (a/2) * sin(draw.ang_front) + ...
                thick * sin(draw.ang_back),...
                  -b/2 - (a/2) * sin(draw.ang_front) + ...
                thick * sin(draw.ang_back)];
            
            % ----------------------------------------------------------- %
            
            % Thickness
            
            XT1 = [- a/2 * cos(draw.ang_front), ...
                   - a/2 * cos(draw.ang_front) + thick * cos(draw.ang_back)];
            
            YT1 = [ b/2     + (a/2)     * sin(draw.ang_front),...
                    b/2 + (a/2) * sin(draw.ang_front) + ...
                    thick * sin(draw.ang_back)];
            
            
            XT2 = [a/2 * cos(draw.ang_front), ...
                   a/2 * cos(draw.ang_front) + thick * cos(draw.ang_back)];
            
            YT2 = [ b/2     - (a/2)     * sin(draw.ang_front), ...
                    b/2 - (a/2) * sin(draw.ang_front) + ...
                    thick * sin(draw.ang_back)];
            
            XT3 = [a/2 * cos(draw.ang_front), ...
                   a/2 * cos(draw.ang_front) + thick * cos(draw.ang_back)];
            
            YT3 = [ -b/2    - (a/2)     * sin(draw.ang_front), ...
                    -b/2 - (a/2) * sin(draw.ang_front) + ...
                    thick * sin(draw.ang_back)];
            
            % ----------------------------------------------------------- %
            
            % Ploting plate
            
            line(graphic_local, XF, YF, 'color', color_sup);
            line(graphic_local, XB, YB, 'color', color_sup);
            line(graphic_local, XT1, YT1, 'color', color_sup);
            line(graphic_local, XT2, YT2, 'color', color_sup);
            line(graphic_local, XT3, YT3, 'color', color_sup);
            
            % ----------------------------------------------------------- %
            
            % Text
            
            text(graphic_local, 0, b/2 + (a/2) * tan(draw.ang_front) + ...
                thick * sin(draw.ang_back),...
                [' a = ' num2str(a) ' m'],...
                'Color', color_sup,'HorizontalAlignment',...
                'center','VerticalAlignment','bottom');
            
            text(graphic_local, 1.5 * ...
                (a/2 + thick * cos(draw.ang_back)),...
                0.5 * ((b/2 - (a/2) * tan(draw.ang_front) + ...
                thick * sin(draw.ang_back))...
                + (-b/2 - (a/2) * tan(draw.ang_front) + ...
                thick * sin(draw.ang_back))),...
                [' b = ' num2str(b) ' m'],...
                'Color', color_sup,'HorizontalAlignment',...
                'center','VerticalAlignment','bottom');
            
            text(graphic_local, 1.5 * ...
                (a/2 + thick * cos(draw.ang_back)),...
                b/2 - (a/2) * tan(draw.ang_front) + ...
                thick * sin(draw.ang_back),...
                [' h = ' num2str(h) ' m'],...
                'Color', color_sup,'HorizontalAlignment',...
                'center','VerticalAlignment','bottom');
            
        end
        
        % =============================================================== %
        
        % Function to draw the graphic
        function drawTNT(graphic_local, Z, W)
            
            draw     = Class_Plot;
            R        = double(Z * (W^(1/3)));
            
            % ----------------------------------------------------------- %
            
            % Center coordinates
            x = - R * cos(draw.ang_back) / 5;
            y = - R * sin(draw.ang_back) / 5;
            
            % ----------------------------------------------------------- %
            
            % Circle radius
            r = W / 50;
            
            % ----------------------------------------------------------- %
            
            % Draw circle
            circ = 0 : pi/50 : 2*pi;
            xcirc = x + r * cos(circ);
            ycirc = y + r * sin(circ);
            
            % ----------------------------------------------------------- %
            
            % Line
            X = [0, x];
            Y = [0, y];
            
            % ----------------------------------------------------------- %
            
            % Plot
            
            plot(graphic_local, xcirc, ycirc, 'color', draw.BLACK);
            line(graphic_local, X, Y,'LineStyle','--', 'color', draw.BLACK);
            
            % ----------------------------------------------------------- %
            
            % Text
            
            text(graphic_local, 1.5 * x / 2, y / 2,...
                [' R = ' num2str(R) ' m'],...
                'Color', draw.BLACK,'HorizontalAlignment','center',...
                'VerticalAlignment','bottom');
            
            text(graphic_local, x, y * 1.3,...
                [' W = ' num2str(W) ' kg'],...
                'Color', draw.BLACK,'HorizontalAlignment','center',...
                'VerticalAlignment','bottom');
            
        end
        
        % =============================================================== %
        
        % Function to draw 
        function plotDraw...
                (graphic_local, a, beta, h, nonlinear, type_sup, Z, W)
            
            draw = Class_Plot;
            
            % ----------------------------------------------------------- %
            
            % Clear graphic
            cla(graphic_local,'reset');
%             clf reset
                        
            % ----------------------------------------------------------- %
            
            % Draw Plate
            hold(graphic_local,'on')
            draw.drawPlate(graphic_local, a, beta, h, nonlinear, type_sup);
            
            % ----------------------------------------------------------- %
            
            % Draw TNT
            draw.drawTNT(graphic_local, Z, W);
            hold(graphic_local, 'off')
            
        end
        
        % =============================================================== %
        
        % Function to draw the graphic
        function plotGraphic(graphic_local, nonlinear, type_sup, ...
                x_axes, y_axes, x_label, y_label)
            
            [leg, cc] = Class_Plot.GraphicMembers(nonlinear, type_sup);
            
            % Plot Graphic
            
            hold(graphic_local,'on');
            plot(graphic_local, x_axes, y_axes, 'color', cc);
            legend(graphic_local, leg);
            xlabel(graphic_local, x_label);
            ylabel(graphic_local, y_label);
            hold(graphic_local,'off');
            
        end
        
        % =============================================================== %
        
        % Function to draw the graphic with 2 graphics
        function plotGraphic2(graphic_local, nonlinear, type_sup, ...
                x_axes, y_axes1, y_axes2, x_label, y_label, ...
                legend1, legend2)
            
            draw = Class_Plot();
            [leg, cc] = draw.GraphicMembers(nonlinear, type_sup);
            
            % Plot Graphic
            
            hold(graphic_local,'on')
            plot(graphic_local, x_axes, y_axes1, 'color', cc);
            plot(graphic_local, x_axes, y_axes2, ':', 'color', cc);
            legend(graphic_local, strcat(leg, legend1), ...
                strcat(leg, legend2));
            xlabel(graphic_local, x_label);
            ylabel(graphic_local, y_label);
            hold(graphic_local,'off')
            
        end
        
        % =============================================================== %
        
        % Function to draw the graphic with 4 graphics
        function plotGraphic4(graphic_local, nonlinear, type_sup, ...
                x_axes, y_axes1, y_axes2, y_axes3, y_axes4, ...
                x_label, y_label, legend1, legend2, legend3, legend4)
            
            draw = Class_Plot();
            [leg, cc] = draw.GraphicMembers(nonlinear, type_sup);
            
            % Plot Graphic
            
            hold(graphic_local,'on')
            
            plot(graphic_local, x_axes, y_axes1, 'color', cc);
            plot(graphic_local, x_axes, y_axes2, '--', 'color', cc);
            plot(graphic_local, x_axes, y_axes3, '-.', 'color', cc);
            plot(graphic_local, x_axes, y_axes4, ':', 'color', cc);
            legend(graphic_local, strcat(leg, legend1), ...
                strcat(leg, legend2), strcat(leg, legend3),...
                strcat(leg, legend4));
            xlabel(graphic_local, x_label);
            ylabel(graphic_local, y_label);
            
            hold(graphic_local,'off')
            
        end
        
        % =============================================================== %
        
        % Function to draw nonlinear period in FFT graphic
        function plotFFT(graphic_local, nonlinear, type_sup, ...
                x_axes, y_axes, x_TNL, y_TNL, x_label, y_label)
        
            draw = Class_Plot();
            [leg, cc] = draw.GraphicMembers(nonlinear, type_sup);
            
            % ----------------------------------------------------------- %
            
            % Plot Graphic
            
            hold(graphic_local,'on')
            
            % Plot FFT
            plot(graphic_local, x_axes, y_axes, 'color', cc);
            
            % Plot plate's nonlinear period
            plot(graphic_local, [x_TNL, x_TNL],       [0, max(y_TNL)], ...
                '--', 'color', draw.BLACK);
            plot(graphic_local, [2*x_TNL, 2*x_TNL],   [0, max(y_TNL)], ...
                '--', 'color', draw.BLACK);
            plot(graphic_local, [3*x_TNL, 3*x_TNL],   [0, max(y_TNL)], ...
                '--', 'color', draw.BLACK);
            
            legend(graphic_local, leg, 'Plate T_N_L');
            xlabel(graphic_local, x_label);
            ylabel(graphic_local, y_label);
            hold(graphic_local,'off')
            
        end
        
    end
    
end