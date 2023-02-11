classdef unitTestElevatorCore < matlab.unittest.TestCase
    properties
        F1
        F2
        F3
        E1UI
        E2UI
        E1
        E2
    end
    methods (TestMethodSetup)
        function setup(testCase)
            addpath('image');
            testCase.F1=control_pannel;
            testCase.F2=control_pannel;
            testCase.F3=control_pannel;
            testCase.F1.setid(1);
            testCase.F2.setid(2);
            testCase.F3.setid(3);
            
            ctl_core = controller_core;
            testCase.E1UI=elevatorUI;
            testCase.E2UI=elevatorUI;
            
            testCase.E1=elevator(1,ctl_core,testCase.E1UI,testCase.F1,testCase.F2,testCase.F3);
            testCase.E2=elevator(2,ctl_core,testCase.E2UI,testCase.F1,testCase.F2,testCase.F3);
            
            testCase.F1.cc=ctl_core;
            testCase.F2.cc=ctl_core;
            testCase.F3.cc=ctl_core;
            
            testCase.E1UI.id=1;
            testCase.E1UI.cc=ctl_core;
            testCase.E1UI.resize();
            testCase.E2UI.id=2;
            testCase.E2UI.cc=ctl_core;
            testCase.E2UI.resize();
            
            ctl_core.setE1(testCase.E1);
            ctl_core.setE2(testCase.E2);
            testCase.addTeardown(@delete,testCase.F1);
            testCase.addTeardown(@delete,testCase.F2);
            testCase.addTeardown(@delete,testCase.F3);
            testCase.addTeardown(@delete,testCase.E1UI);
            testCase.addTeardown(@delete,testCase.E2UI);
            testCase.addTeardown(@delete,testCase.E1);
            testCase.addTeardown(@delete,testCase.E2);
        end
    end
    methods(Test)
        function testMoveUp(testCase) %T1.1
            testCase.E1.up();
            testCase.verifyEqual(testCase.E1.floor,2);
        end
        
        function testMoveDown(testCase)
            %State:elevator at floor two
            %Input:nothing
            %Expected Output:elevator at floor one
            testCase.E1.floor = 2;
            testCase.E1.down();
            testCase.verifyEqual(testCase.E1.floor,1);
        end
        
        function testOpen_E(testCase)
            %State:elevator at floor two
            %Input:nothing
            %Expected Output:elevator at floor one
            testCase.E1.floor = 1;
            testCase.E1.F1UI.E1.ImageSource = 'close.png';
            testCase.E1.status = 1;
            testCase.E1.F1UI.up.ImageSource='up_on.png';
            testCase.E1.open();
            testCase.verifyEqual(testCase.E1.F1UI.E1.ImageSource,'open.png');
            testCase.verifyEqual(testCase.E1.F1UI.up.ImageSource,'up_off.png');
            
            testCase.E1.floor = 2;
            testCase.E1.F2UI.E1.ImageSource = 'close.png';
            testCase.E1.status = 1;
            testCase.E1.F2UI.up.ImageSource='up_on.png';
            testCase.E1.open();
            testCase.verifyEqual(testCase.E1.F2UI.E1.ImageSource,'open.png');
            testCase.verifyEqual(testCase.E1.F2UI.up.ImageSource,'up_off.png');
            
            testCase.E1.floor = 3;
            testCase.E1.F3UI.E1.ImageSource = 'close.png';
            testCase.E1.status = 0;
            testCase.E1.F3UI.down.ImageSource='down_on.png';
            testCase.E1.open();
            testCase.verifyEqual(testCase.E1.F3UI.E1.ImageSource,'open.png');
            testCase.verifyEqual(testCase.E1.F3UI.down.ImageSource,'down_off.png');
            
            testCase.E2.floor = 1;
            testCase.E2.F1UI.E2.ImageSource = 'close.png';
            testCase.E2.status = 0;
            testCase.E2.F1UI.up.ImageSource='up_on.png';
            testCase.E2.open();
            testCase.verifyEqual(testCase.E2.F1UI.E2.ImageSource,'open.png');
            testCase.verifyEqual(testCase.E2.F1UI.up.ImageSource,'up_off.png');
            
            testCase.E2.floor = 2;
            testCase.E2.F2UI.E2.ImageSource = 'close.png';
            testCase.E1.status = 0;
            testCase.E2.F2UI.up.ImageSource='up_on.png';
            testCase.E2.F2UI.down.ImageSource='down_on.png';
            testCase.E2.open();
            testCase.verifyEqual(testCase.E2.F2UI.E2.ImageSource,'open.png');
            testCase.verifyEqual(testCase.E2.F2UI.up.ImageSource,'up_off.png');
            testCase.verifyEqual(testCase.E2.F2UI.down.ImageSource,'down_off.png');
            
            testCase.E2.floor = 3;
            testCase.E2.F3UI.E2.ImageSource = 'close.png';
            testCase.E2.status = 0;
            testCase.E2.F3UI.down.ImageSource='down_on.png';
            testCase.E2.open();
            testCase.verifyEqual(testCase.E2.F3UI.E2.ImageSource,'open.png');
            testCase.verifyEqual(testCase.E2.F3UI.down.ImageSource,'down_off.png');
            
            testCase.E2.floor = 2;
            testCase.E2.F2UI.E2.ImageSource = 'close.png';
            testCase.E2.status = -1;
            testCase.E2.F2UI.down.ImageSource='down_on.png';
            testCase.E2.open();
            testCase.verifyEqual(testCase.E2.F2UI.E2.ImageSource,'open.png');
            testCase.verifyEqual(testCase.E2.F2UI.down.ImageSource,'down_off.png');
            
        end
        
        function testClose(testCase)
            %State:elevator at floor two
            %Input:nothing
            %Expected Output:elevator one's inage source should be
            %close.png
            
            testCase.E1.floor = 1;
            testCase.E1.F1UI.E1.ImageSource = 'open.png';
            testCase.E1.close();
            testCase.verifyEqual(testCase.E1.F1UI.E1.ImageSource,'close.png');
            
            testCase.E1.floor = 2;
            testCase.E1.F2UI.E1.ImageSource = 'open.png';
            testCase.E1.close();
            testCase.verifyEqual(testCase.E1.F2UI.E1.ImageSource,'close.png');
            
            testCase.E1.floor = 3;
            testCase.E1.F3UI.E1.ImageSource = 'open.png';
            testCase.E1.close();
            testCase.verifyEqual(testCase.E1.F3UI.E1.ImageSource,'close.png');
            
            testCase.E2.floor = 1;
            testCase.E2.F1UI.E2.ImageSource = 'open.png';
            testCase.E2.close();
            testCase.verifyEqual(testCase.E2.F1UI.E2.ImageSource,'close.png');
            
            testCase.E2.floor = 2;
            testCase.E2.F2UI.E2.ImageSource = 'open.png';
            testCase.E2.close();
            testCase.verifyEqual(testCase.E2.F2UI.E2.ImageSource,'close.png');
            
            testCase.E2.floor = 3;
            testCase.E2.F3UI.E2.ImageSource = 'open.png';
            testCase.E2.close();
            testCase.verifyEqual(testCase.E2.F3UI.E2.ImageSource,'close.png');
        end
        
        function testStop(testCase)
            %State:elevator whose q is not empty and status
            %Input:nothing
            %Expected Output:elevator one's inage source should be
            %close.png
            for i = 0:1
                testCase.E1.upq = [1,2,3];
                testCase.E1.floor = 1;
                testCase.E1.status = i;
                testCase.E1.F1UI.up.ImageSource = 'up_on.png';
                testCase.E1.stop();
                testCase.verifyEqual(testCase.E1.F1UI.up.ImageSource,'up_off.png');
                testCase.verifyEqual(testCase.E1.inUI.F1.BackgroundColor,[1,1,1]);
                
                testCase.E1.upq = [1,2,3];
                testCase.E1.floor = 2;
                testCase.E1.status = i;
                testCase.E1.F2UI.up.ImageSource = 'up_on.png';
                testCase.E1.stop();
                testCase.verifyEqual(testCase.E1.F2UI.up.ImageSource,'up_off.png');
                testCase.verifyEqual(testCase.E1.inUI.F2.BackgroundColor,[1,1,1]);
                
                testCase.E1.upq = [1,2,3];
                testCase.E1.floor = 3;
                testCase.E1.status = i;
                testCase.E1.stop();
                testCase.verifyEqual(testCase.E1.inUI.F3.BackgroundColor,[1,1,1]);
            end
            i = -1;
            testCase.E1.upq = [1,2,3];
            testCase.E1.floor = 1;
            testCase.E1.status = i;
            testCase.E1.stop();
            testCase.verifyEqual(testCase.E1.inUI.F1.BackgroundColor,[1,1,1]);
            
            testCase.E1.upq = [1,2,3];
            testCase.E1.floor = 2;
            testCase.E1.status = i;
            testCase.E1.F2UI.down.ImageSource = 'down_on.png';
            testCase.E1.stop();
            testCase.verifyEqual(testCase.E1.F2UI.down.ImageSource,'down_off.png');
            testCase.verifyEqual(testCase.E1.inUI.F2.BackgroundColor,[1,1,1]);
            
            testCase.E1.upq = [1,2,3];
            testCase.E1.floor = 3;
            testCase.E1.status = i;
            testCase.E1.F3UI.down.ImageSource = 'down_on.png';
            testCase.E1.stop();
            testCase.verifyEqual(testCase.E1.F3UI.down.ImageSource,'down_off.png');
            testCase.verifyEqual(testCase.E1.inUI.F3.BackgroundColor,[1,1,1]);
        end
        
        function testTravelling0(testCase)
            testCase.E1.upq = [];
            testCase.E1.downq = [];
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.inUI.status.Text,char("stop"));
        end
        
        function testTravelling1(testCase)
            testCase.E1.status = 1;
            UP(testCase.E1.sf);
            testCase.E1.upq = [2];
            testCase.E1.downq = [];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling2(testCase)
            testCase.E1.status = 1;
            testCase.E1.floor = 1;
            testCase.E1.upq = [2];
            testCase.E1.downq = [];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end

        function testTravelling3(testCase)
            testCase.E1.status = 1;
            UP(testCase.E1.sf);
            testCase.E1.upq = [];
            testCase.E1.downq = [3];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 3);
        end
        function testTravelling4(testCase)
            testCase.E1.status = 1;
            UP(testCase.E1.sf);
            testCase.E1.upq = [];
            testCase.E1.downq = [2];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling5(testCase)
            testCase.E1.status = 1;
            UP(testCase.E1.sf);
            UP(testCase.E1.sf);
            testCase.E1.downq = [2];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling6(testCase)%???
            testCase.E1.upq = [];
            testCase.E1.status = 1;
            UP(testCase.E1.sf);
            UP(testCase.E1.sf);
            testCase.E1.upq = [2];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
           
        function testTravelling7(testCase)
            testCase.E1.status = -1;
            UP(testCase.E1.sf);
            testCase.E1.downq = [2];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling8(testCase)%Error
            testCase.E1.upq = [];
            testCase.E1.status = -1;
            UP(testCase.E1.sf);
            UP(testCase.E1.sf);
            testCase.E1.downq = [2];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling9(testCase)% Error
            testCase.E1.upq = [1];
            testCase.E1.status = -1;
            UP(testCase.E1.sf);
            testCase.E1.downq = [3];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 1);
        end
        
        function testTravelling10(testCase)
            testCase.E1.status = -1;
            UP(testCase.E1.sf);
            testCase.E1.upq = [2];
            testCase.E1.downq = [3];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        function testTravelling11(testCase)
            testCase.E1.status = -1;
            testCase.E1.floor = 1;
            testCase.E1.upq = [2];
            testCase.E1.downq = [3];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        function testTravelling12(testCase)
            testCase.E1.status = -1;
            UP(testCase.E1.sf);
            testCase.E1.upq = [];
            testCase.E1.downq = [3];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 3);
        end
        function testTravelling13(testCase)
            testCase.E1.status = 0;
            UP(testCase.E1.sf);
            testCase.E1.upq = [2];
            testCase.E1.downq = [];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling14(testCase)
            testCase.E1.status = 0;
            UP(testCase.E1.sf);
            testCase.E1.upq = [];
            testCase.E1.downq = [2];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling15(testCase)
            testCase.E1.status = 0;
            testCase.E1.floor = 1;
            testCase.E1.upq = [2];
            testCase.E1.downq = [];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling16(testCase)
            testCase.E1.status = 0;
            UP(testCase.E1.sf);
            UP(testCase.E1.sf);
            testCase.E1.upq = [];
            testCase.E1.downq = [2];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 2);
        end
        
        function testTravelling17(testCase)
            testCase.E1.status = 0;
            UP(testCase.E1.sf);
            testCase.E1.upq = [];
            testCase.E1.downq = [3];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 3);
        end
        
        function testTravelling18(testCase)
            testCase.E1.status = 0;
            UP(testCase.E1.sf);
            testCase.E1.upq = [1];
            testCase.E1.downq = [];
            WAKE(testCase.E1.sf);
            testCase.E1.inposition();
            testCase.verifyEqual(testCase.E1.floor, 1);
        end
    end
end