classdef testElevatorApp < matlab.uitest.TestCase
    properties
        F1
        F2
        F3
        E1UI
        E2UI
        E1
        E2
        ctl_core
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
            
            testCase.ctl_core = controller_core;
            testCase.E1UI=elevatorUI;
            testCase.E2UI=elevatorUI;
            
            testCase.E1=elevator(1,testCase.ctl_core,testCase.E1UI,testCase.F1,testCase.F2,testCase.F3);
            testCase.E2=elevator(2,testCase.ctl_core,testCase.E2UI,testCase.F1,testCase.F2,testCase.F3);
            
            testCase.F1.cc=testCase.ctl_core;
            testCase.F2.cc=testCase.ctl_core;
            testCase.F3.cc=testCase.ctl_core;
            
            testCase.E1UI.id=1;
            testCase.E1UI.cc=testCase.ctl_core;
            testCase.E1UI.resize();
            testCase.E2UI.id=2;
            testCase.E2UI.cc=testCase.ctl_core;
            testCase.E2UI.resize();
            
            testCase.ctl_core.setE1(testCase.E1);
            testCase.ctl_core.setE2(testCase.E2);
            testCase.addTeardown(@delete,testCase.F1);
            testCase.addTeardown(@delete,testCase.F2);
            testCase.addTeardown(@delete,testCase.F3);
            testCase.addTeardown(@delete,testCase.E1UI);
            testCase.addTeardown(@delete,testCase.E2UI);
            testCase.addTeardown(@delete,testCase.E1);
            testCase.addTeardown(@delete,testCase.E2);
        end
    end
    methods (Test)
        function testMoveup(testCase)
            testCase.press(testCase.E1UI.F2);
            pause(5);
            pause(5);
            testCase.press(testCase.E1UI.F3);
            pause(5);
            testCase.press(testCase.E1UI.F1);
            pause(5);
            testCase.press(testCase.E1UI.F3);
            pause(5);
            testCase.press(testCase.E1UI.F1);
            pause(5);
            testCase.press(testCase.F2.up);pause(5);
            testCase.press(testCase.F3.down);pause(5);
            
            testCase.press(testCase.F2.down);pause(5);
            
        end
        function testMovedown(testCase)
            testCase.press(testCase.E2UI.stop);
            testCase.press(testCase.E1UI.F3);pause(5);
            testCase.press(testCase.E1UI.F2);pause(5);
            testCase.press(testCase.E1UI.F1);pause(5);
            
            testCase.press(testCase.E1UI.F3);pause(5);
            testCase.press(testCase.E1UI.F1);pause(5);
            
            testCase.press(testCase.E1UI.F3);pause(5);
            
            testCase.press(testCase.F2.up);pause(5);
            testCase.press(testCase.F1.up);pause(5);
            testCase.press(testCase.E1UI.F3);pause(5);
            
            testCase.press(testCase.F2.down);pause(5);
            
            
        end
    end
end