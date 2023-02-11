classdef elevator < handle
    
    properties
        inUI
        F1UI
        F2UI
        F3UI
        id
        floor
        status
        upq
        downq
        core
        sf
        emer
    end
    
    methods
        
        function obj=elevator(ID,cc,uiin,f1,f2,f3)
            obj.core = cc;
            obj.sf=elevator_core('ec',obj);
            obj.id = ID;
            obj.floor = 1;
            obj.status = 0;
            obj.upq=[];
            obj.downq=[];
            
            obj.inUI=uiin;
            obj.F1UI=f1;
            obj.F2UI=f2;
            obj.F3UI=f3;
            
            obj.inUI.floor.Value=1;
            obj.inUI.status.Text="stop";
            obj.inUI.lamp.Color=[0.00,1.00,0.00];
            obj.inUI.Label.Text=int2str(obj.id);
            obj.emer=0;
            
        end

        
        function up(e)
            %disp('move up to');
            e.status=1;
            e.inUI.status.Text="up";
            prev = e.floor;
            e.floor = e.floor+1;
            for v = 0:0.2:1
                temp=prev+v;
                e.inUI.floor.Value=temp;
                pause(0.05);
            end
            %disp(e.floor);
            e.updatepannel();
        end
        
        function down(e)
            %disp('move down to');
            e.status=-1;
            e.inUI.status.Text="down";
            prev = e.floor;
            e.floor = e.floor-1;
            for v = 0:0.2:1
                temp=prev-v;
                e.inUI.floor.Value=temp;
                pause(0.05);
            end
            
            %disp(e.floor);
            e.updatepannel();
        end

        function inposition(e)
          
            if isempty(e.upq) && isempty(e.downq)
                %disp("statue 0");
                e.status=0;
                e.inUI.status.Text="stop";
                e.updatepannel();
                %disp('put back to sleep')
                SLEEP(e.sf);
                return;
            end
            
            if e.status == 1
                %fprintf('status %d \n',e.status);
                if ismember(e.floor,e.upq)
                    %disp("condition 1");
                    e.status=1;
                    e.updatepannel();
                    %disp("need to stop at");
                    %disp(e.floor);
                    STOP(e.sf);
                    return
                end
                
                if ~isempty(e.upq(e.upq>e.floor))
                    %disp("condition 2");
                    e.status=1;
                    e.updatepannel();
                    UP(e.sf);
                    return    
                end
                
                if ~isempty(e.downq(e.downq>e.floor))
                    %disp("condition 3");
                    e.status=1;
                    e.updatepannel();
                    UP(e.sf);
                    return    
                end
                
                if ismember(e.floor,e.downq)
                    %disp("condition 4");
                    e.status=-1;
                    e.updatepannel();
                    %disp("need to stop at");
                    %disp(e.floor);
                    STOP(e.sf);
                    return
                end            
                
                if ~isempty(e.downq(e.downq<e.floor))
                    %disp("condition 5");
                    e.status=-1;
                    e.updatepannel();
                    DOWN(e.sf);
                    return    
                end
                
                if ~isempty(e.upq(e.upq<e.floor))
                    %disp("condition 6");
                    e.status=-1;
                    e.updatepannel();
                    DOWN(e.sf);
                    return     
                end                
                
            elseif e.status == -1
                %%fprintf('status %d \n',e.status);
                
                if ismember(e.floor,e.downq)
                    %disp("condition 4");
                    e.status=-1;
                    e.updatepannel();
                    %disp("need to stop at");
                    %disp(e.floor);
                    STOP(e.sf);
                    return
                end
                
                if ~isempty(e.downq(e.downq<e.floor))
                    %disp("condition 5");
                    e.status=-1;
                    e.updatepannel();
                    DOWN(e.sf);
                    return    
                end
                
                if ~isempty(e.upq(e.upq<e.floor))
                    %disp("condition 6");
                    e.status=-1;
                    e.updatepannel();
                    DOWN(e.sf);
                    return     
                end
                
                if ismember(e.floor,e.upq)
                    %disp("condition 1");
                    e.status=1;
                    e.updatepannel();
                    %disp("need to stop at");
                    %disp(e.floor);
                    STOP(e.sf);
                    return
                end
                
                if ~isempty(e.upq(e.upq>e.floor))
                    %disp("condition 2");
                    e.status=1;
                    e.updatepannel();
                    UP(e.sf);
                    return    
                end
                
                if ~isempty(e.downq(e.downq>e.floor))
                    %disp("condition 3");
                    e.status=1;
                    e.updatepannel();
                    UP(e.sf);
                    return    
                end 
                 
            else
                %%fprintf('status %d \n',e.status);
                if ismember(e.floor,e.upq)
                    %disp("condition 1");
                    e.status=1;
                    e.updatepannel();
                    %disp("need to stop at");
                    %disp(e.floor);
                    STOP(e.sf);
                    return
                end  
                
                if ismember(e.floor,e.downq)
                    %disp("condition 4");
                    e.status=-1;
                    e.updatepannel();
                    %disp("need to stop at");
                    %disp(e.floor);
                    STOP(e.sf);
                    return
                end
                if ~isempty(e.upq(e.upq>e.floor))
                    %disp("condition 2");
                    e.status=1;
                    e.updatepannel();
                    UP(e.sf);
                    return    
                end                
                if ~isempty(e.downq(e.downq<e.floor))
                    %disp("condition 5");
                    e.status=-1;
                    e.updatepannel();
                    DOWN(e.sf);
                    return    
                end
                if ~isempty(e.downq(e.downq>e.floor))
                    %disp("condition 3");
                    e.status=1;
                    e.updatepannel();
                    UP(e.sf);
                    return    
                end
                if ~isempty(e.upq(e.upq<e.floor))
                    %disp("condition 6");
                    e.status=-1;
                    e.updatepannel();
                    DOWN(e.sf);
                    return     
                end                
            end
        end
                         
                
        function updatepannel(e)
            if e.status == 1
                status="up.png"; %#ok<PROP>
            elseif e.status == -1
                status="down.png";%#ok<PROP>
            else
                status="stop.png";%#ok<PROP>
            end
            e.inUI.floor.Value=e.floor;
            
            if e.id==1        
                e.F1UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F1UI.E1floor.Text=int2str(e.floor);
                e.F2UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F2UI.E1floor.Text=int2str(e.floor);
                e.F3UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F3UI.E1floor.Text=int2str(e.floor);
            elseif e.id==2
                e.F1UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F1UI.E2floor.Text=int2str(e.floor);
                e.F2UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F2UI.E2floor.Text=int2str(e.floor);
                e.F3UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F3UI.E2floor.Text=int2str(e.floor);
            end
        end
        
        function disableall(e)
            e.F3UI.down.Enable = 'off';
            e.F2UI.down.Enable = 'off';
            e.F1UI.up.Enable = 'off';
            e.F2UI.up.Enable = 'off';
            
        end
        function emergencyPannel(e)
            e.upq=[];
            e.downq=[];
            e.inUI.lamp.Color=[1,0,0];
            e.inUI.open.BackgroundColor=[1,0,0];
            e.inUI.close.BackgroundColor=[1,0,0];
            e.inUI.Image.ImageSource='open.png';
            status="stop.png";
            e.inUI.floor.Value=e.floor;
            e.inUI.F1.BackgroundColor=[1,0,0];
            e.inUI.F2.BackgroundColor=[1,0,0];
            e.inUI.F3.BackgroundColor=[1,0,0];
            e.inUI.stop.BackgroundColor=[1,0,0];
            if e.id==1        
                e.F1UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F1UI.E1floor.Text=int2str(e.floor);
                e.F2UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F2UI.E1floor.Text=int2str(e.floor);
                e.F3UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F3UI.E1floor.Text=int2str(e.floor);
            elseif e.id==2
                e.F1UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F1UI.E2floor.Text=int2str(e.floor);
                e.F2UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F2UI.E2floor.Text=int2str(e.floor);
                e.F3UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F3UI.E2floor.Text=int2str(e.floor);
            end
        end
        
        function emergencyRecovery(e)
            e.F3UI.down.Enable = 'on';
            e.F2UI.down.Enable = 'on';
            e.F1UI.up.Enable = 'on';
            e.F2UI.up.Enable = 'on';
            e.inUI.lamp.Color=[0,1,0];
            e.inUI.open.BackgroundColor=[1,1,1];
            e.inUI.close.BackgroundColor=[1,1,1];
            e.inUI.Image.ImageSource='close.png';
            status="stop.png";
            e.inUI.floor.Value=e.floor;
            e.inUI.F1.BackgroundColor=[1,1,1];
            e.inUI.F2.BackgroundColor=[1,1,1];
            e.inUI.F3.BackgroundColor=[1,1,1];
            e.inUI.stop.BackgroundColor=[1,1,1];
            if e.id==1        
                e.F1UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F1UI.E1floor.Text=int2str(e.floor);
                e.F2UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F2UI.E1floor.Text=int2str(e.floor);
                e.F3UI.E1direction.ImageSource=status;%#ok<PROP>
                e.F3UI.E1floor.Text=int2str(e.floor);
            elseif e.id==2
                e.F1UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F1UI.E2floor.Text=int2str(e.floor);
                e.F2UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F2UI.E2floor.Text=int2str(e.floor);
                e.F3UI.E2direction.ImageSource=status;%#ok<PROP>
                e.F3UI.E2floor.Text=int2str(e.floor);
            end
        
        
        end
        function stop(e)
            if e.status>=0
                e.removefromq(e.floor,1);
                if e.floor==1
                    e.F1UI.up.ImageSource='up_off.png';
                    %disp("reset F1 button")
                    e.inUI.F1.BackgroundColor=[1,1,1];
                elseif e.floor==2
                    e.F2UI.up.ImageSource='up_off.png';
                    %disp("reset F2 button")
                    e.inUI.F2.BackgroundColor=[1,1,1];
                else
                    %disp("reset F3 button")
                    e.inUI.F3.BackgroundColor=[1,1,1];
                end
                
            elseif e.status==-1
                e.removefromq(e.floor,-1);
                if e.floor==3
                    e.F3UI.down.ImageSource='down_off.png';
                    %disp("reset F3 button")
                    e.inUI.F3.BackgroundColor=[1,1,1];
                elseif e.floor==2
                    e.F2UI.down.ImageSource='down_off.png';
                    %disp("reset F2 button")
                    e.inUI.F2.BackgroundColor=[1,1,1];
                else
                    e.inUI.F1.BackgroundColor=[1,1,1];
                    %disp("reset F1 button")
                end
            end

            
        end
                
        function open(e)
            pause(0.5);
            e.inUI.lamp.Color=[1,0,0];
            e.inUI.open.BackgroundColor=[1,1,1];
            e.inUI.Image.ImageSource='open.png';
            if e.floor == 1
                if e.id == 1
                    e.F1UI.E1.ImageSource='open.png';
                else 
                    e.F1UI.E2.ImageSource='open.png';
                end
            elseif e.floor == 2
                if e.id == 1
                    e.F2UI.E1.ImageSource='open.png';
                else 
                    e.F2UI.E2.ImageSource='open.png';
                end
            else
               if e.id == 1
                    e.F3UI.E1.ImageSource='open.png';
                else 
                    e.F3UI.E2.ImageSource='open.png';
                end
            end
            
            %e.inUI.status.Text="open";
            if e.status == 1
                if e.floor == 1
                    e.F1UI.up.ImageSource='up_off.png';
                elseif e.floor == 2
                    e.F2UI.up.ImageSource='up_off.png';
                end
            elseif e.status == -1
                if e.floor == 2
                    e.F2UI.down.ImageSource='down_off.png';
                elseif e.floor == 3
                    e.F3UI.down.ImageSource='down_off.png';
                end
            else
                if e.floor == 1
                    e.F1UI.up.ImageSource='up_off.png';
                elseif e.floor == 2
                    e.F2UI.up.ImageSource='up_off.png';
                    e.F2UI.down.ImageSource='down_off.png';
                else
                    e.F3UI.down.ImageSource='down_off.png';
                end
            end
        end
        
        function close(e)
            e.inUI.lamp.Color=[0,1,0];
            e.inUI.close.BackgroundColor=[1,1,1];
            e.inUI.Image.ImageSource='close.png';
            if e.floor == 1
                if e.id == 1
                    e.F1UI.E1.ImageSource='close.png';
                else 
                    e.F1UI.E2.ImageSource='close.png';
                end
            elseif e.floor == 2
                if e.id == 1
                    e.F2UI.E1.ImageSource='close.png';
                else 
                    e.F2UI.E2.ImageSource='close.png';
                end
            else
               if e.id == 1
                    e.F3UI.E1.ImageSource='close.png';
                else 
                    e.F3UI.E2.ImageSource='close.png';
                end
            end
            
            CONT(e.sf);
        end
        
        function addtoq(e,floor,dir)
            if dir == 1
                e.upq(end+1)=floor;
            else
                e.downq(end+1)=floor;
            end
                
        end
        
        function removefromq(e,floor,dir)
            if dir == 1
                e.upq(e.upq==floor)=[];
            else
                e.downq(e.downq==floor)=[];
            end               
        end
        


        
    end
    
end