    
classdef controller_core < handle
    
    properties (Access = public)
        E1
        E2
    end
    
    methods
        
        function setE1(cc,e1)
            cc.E1=e1;
        end
        
        function setE2(cc,e2)
            cc.E2=e2;
        end
        
        function goto(cc,id,floor)
            if id == 1
                disp('id == 1');
                if floor>=cc.E1.floor
                    disp('add to up q, the Elevator is at');
                    disp(cc.E1.floor)
                    cc.E1.addtoq(floor,1)
                else
                    cc.E1.addtoq(floor,-1)
                end
                if cc.E1.status == 0
                    WAKE(cc.E1.sf);
                end
            else
                if floor>=cc.E2.floor
                    cc.E2.addtoq(floor,1)
                else
                    cc.E2.addtoq(floor,-1)
                end
                if cc.E2.status == 0
                    WAKE(cc.E2.sf);
                end
            end
            
        end
        
        function callelevator(cc,floor,dir)
            % compare with e1, 
                %if dir the same
                disp("a call at floor"); disp(floor)
                disp("the direction is");disp(dir);
                
                if cc.E1.emer == 1
                    if cc.E2.emer == 1
                        return
                    else
                        cc.E2.addtoq(floor,dir);
                        disp('add to E2'); 
                        return
                    end
                end
               if cc.E2.emer == 1
                    if cc.E1.emer == 1
                        return
                    else
                        cc.E1.addtoq(floor,dir);
                        disp('add to E2');
                        return
                    end
               end 
                
                if dir == cc.E1.status
                    disp("same dir with E1");
                    delta = floor-cc.E1.floor;
                    % and is ahead
                    if (delta/dir)>=0
                        
                        % add to q, return
                        cc.E1.addtoq(floor,dir);
                        disp('add to E1');
                        return
                     
                    end
                    disp("not ahead of E1");
                end
                if dir == cc.E2.status
                    disp("same dir with E2");
                    delta = floor-cc.E2.floor;
                    if (delta/dir)>=0
                        cc.E2.addtoq(floor,dir);
                        disp('add to 2');
                        return
                    end
                    disp("not ahead of E2");
                % not same for both
                % if e1 stop, add to e1 q and wake
                end

                if cc.E1.status == 0
                    disp("E1 is stop");
                    cc.E1.addtoq(floor,dir);
                    disp('add to E1');
                    WAKE(cc.E1.sf);
                    return
                end
                % else if e2 stop, add to e2 q and wake
                if cc.E2.status == 0
                    disp("E2 is stop");
                    cc.E2.addtoq(floor,dir);
                    disp('add to E2');
                    
                    WAKE(cc.E2.sf);
                    
                    return
                end
                % add to e1 q.
                
                % Here I found out that when I only put all the unfit floor
                % into E1's q, it's too harsh for E1, thus I decide to take
                % a random algorithm to distribute the trickiest request.
                
                r=rand;
                if r>=0.5
                    cc.E1.addtoq(floor,dir);
                    disp('add to E1');
                else
                    cc.E2.addtoq(floor,dir);
                    disp('add to E2');  
                end
         
        end
        
        function open(cc,id)
            if id == 1
                OPEN(cc.E1.sf);
            else
                OPEN(cc.E2.sf);
            end   
        end
        
        function close(cc,id)
            if id == 1
                CLOSE(cc.E1.sf);
            else
                CLOSE(cc.E2.sf);
            end 
        end
        
        function emergency(cc,id)
            if id == 1
                %EMER(cc.E1.sf);
                cc.E1.emergencyPannel();
                cc.E1.emer = 1;
            else
                %EMER(cc.E2.sf);
                cc.E2.emergencyPannel();
                cc.E2.emer = 1;
            end 
            
            if cc.E1.emer == 1 && cc.E2.emer == 1
                cc.E1.disableall();
                
            end
        end    
        
        function restart(cc,id)
            if id == 1
                %RESTART(cc.E1.sf);
                cc.E1.emergencyRecovery();
                cc.E1.emer = 0;
            else
                %RESTART(cc.E2.sf);
                cc.E2.emergencyRecovery();
                cc.E2.emer = 0;
            end 
        end
        
        function debug(cc)
            disp('*********************');
            fprintf('elevator %d \n',cc.E1.id);
            fprintf('at floor %d \n',cc.E1.floor);
            fprintf('status %d \n',cc.E1.status);
            disp('upq');
            disp(cc.E1.upq);
            disp('downq');
            disp(cc.E1.downq);
            disp('----------------');
            fprintf('elevator %d \n',cc.E2.id);
            fprintf('at floor %d \n',cc.E2.floor);
            fprintf('status %d \n',cc.E2.status);
            disp('upq');
            disp(cc.E2.upq);
            disp('downq');
            disp(cc.E2.downq);
            disp('*********************');
        end
    end
end
 