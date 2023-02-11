classdef unitTestControlcore < matlab.unittest.TestCase
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
        function testGoTo(testCase)% £¡£¡when running this, stateflow of elevator should be commited.£¡£¡
            %State:elevator at floor one
            %Input:go to floor one, two, three
            %Expected Output:
            testCase.E1.floor = 1;
            testCase.ctl_core.goto(1,3);
            testCase.verifyEqual(testCase.E1.upq,[3]);
            
            testCase.E1.upq = [];
            
            testCase.E1.floor = 2;
            testCase.ctl_core.goto(1,1);
            testCase.verifyEqual(testCase.E1.downq,[1]);
            
            
            testCase.E2.floor = 1;
            testCase.ctl_core.goto(2,3);
            testCase.verifyEqual(testCase.E2.upq,[3]);
            
            testCase.E2.upq = [];
            
            testCase.E2.floor = 2;
            testCase.ctl_core.goto(2,1);
            testCase.verifyEqual(testCase.E2.downq,[1]);
            
        end
        function testCallElevator(testCase)
            %State:elevator at floor one
            %Input:go to floor one, two, three
            %Expected Output:There are six condition in total
            
            %Condition one
            %State:elevator one and called dirction are the same, and floor
            %is ahead of the elevator one
            %Input:
            %Expected Output:Floor info will be added to Elevator one's
            %upq.
            testCase.ctl_core.E1.status = 1;
            testCase.ctl_core.E1.floor = 1;
            testCase.ctl_core.callelevator(2,1);
            testCase.verifyEqual(testCase.E1.upq,[2]);
            
            testCase.E1.upq = [];
            
            %Condition two
            %State:elevator one and called dirction are not the same, 
            %or they are at the same dirction but floor
            %isn't ahead of the elevator one.elevator two and called
            %dirction are the same, and floor 
            %is ahead of the elevator two
            %Input:
            %Expected Output:Floor info will be added to Elevator two's
            %upq.
            testCase.ctl_core.E1.status = 1;
            testCase.ctl_core.E1.floor = 3;
            testCase.ctl_core.E2.status = 1;
            testCase.ctl_core.E2.floor = 1;
            testCase.ctl_core.callelevator(2,1);
            testCase.verifyEqual(testCase.E2.upq,[2]);
            
            testCase.E2.upq = [];

            
            %Condition three
            %State:both elevators and called dirction are not the same, 
            %or they are at the same dirction but floor
            %isn't ahead of elevators.elevator one is stop.
            %Input:
            %Expected Output:Floor info will be added to Elevator one's
            %q according to the dirction.
            testCase.ctl_core.E2.status = 1;
            testCase.ctl_core.E2.floor = 3;
            testCase.ctl_core.E1.status = 0;
            testCase.ctl_core.E1.floor = 3;
            testCase.ctl_core.callelevator(2,1);
            testCase.verifyEqual(testCase.E1.upq,[2]);
            
            testCase.E1.upq = [];

            %Condition four
            %State:both elevators and called dirction are not the same, 
            %or they are at the same dirction but floor
            %isn't ahead of elevators.elevator one is not stop.Elevator two
            %
            %Input:
            %Expected Output:Floor info will be added to Elevator one's
            %q according to the dirction.
            
            testCase.ctl_core.E1.status = 1;
            testCase.ctl_core.E1.floor = 3;
            testCase.ctl_core.E2.status = 0;
            testCase.ctl_core.E2.floor = 3;
            testCase.ctl_core.callelevator(2,1);
            testCase.verifyEqual(testCase.E2.upq,[2]);
            
            testCase.E2.upq = [];

            %Condition five
            %State:both elevators and called dirction are not the same, 
            %or they are at the same dirction but floor
            %isn't ahead of elevators.elevator one is stop.
            %Input:
            %Expected Output:Floor info will be added to Elevator one's
            %q according to the dirction.
            
            testCase.ctl_core.E1.status = 1;
            testCase.ctl_core.E1.floor = 3;
            testCase.ctl_core.E2.status = 1;
            testCase.ctl_core.E2.floor = 3;
            testCase.ctl_core.callelevator(2,1);
            Upq = [testCase.E2.upq,testCase.E1.upq]
            testCase.verifyEqual(Upq,[2]);
            
        end
    end
end