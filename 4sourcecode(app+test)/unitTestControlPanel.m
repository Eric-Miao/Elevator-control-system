classdef unitTestControlPanel < matlab.uitest.TestCase
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
    methods (Test)%When testing this funciton, stateflow is still need to be disabled.
        function testUpOrder(testCase)
            testCase.press(testCase.F2.up);
            testCase.verifyEqual(testCase.F2.up.ImageSource,'up_on.png');
        end
        function testDownOrder(testCase)
            testCase.press(testCase.F2.down);
            testCase.verifyEqual(testCase.F2.down.ImageSource,'down_on.png');
        end
        function testFloorOrder(testCase)
            testCase.press(testCase.E1UI.F3);
            testCase.verifyEqual(testCase.E1UI.F3.BackgroundColor,[1,0,0]);
            testCase.press(testCase.E1UI.F2);
            testCase.verifyEqual(testCase.E1UI.F2.BackgroundColor,[1,0,0]);
            testCase.press(testCase.E1UI.F1);
            testCase.verifyEqual(testCase.E1UI.F1.BackgroundColor,[1,0,0]);
        end
        function testOpenDoorOrder(testCase)
            testCase.press(testCase.E1UI.open);
            testCase.verifyEqual(testCase.E1UI.open.BackgroundColor,[1,0,0]);
        end
        function testCloseDoorOrder(testCase)
            testCase.press(testCase.E1UI.close);
            testCase.verifyEqual(testCase.E1UI.close.BackgroundColor,[1,0,0]);
        end
        function testStopOrder(testCase)%
            testCase.press(testCase.E1UI.stop);
            testCase.verifyEqual(testCase.E1UI.stop.BackgroundColor,[1,0,0]);
        end
    end
end