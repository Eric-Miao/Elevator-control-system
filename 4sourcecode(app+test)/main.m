close all;
clear all;
addpath('image');
F1=control_pannel;
F2=control_pannel;
F3=control_pannel;
F1.setid(1);
F2.setid(2);
F3.setid(3);

ctl_core = controller_core;
E1UI=elevatorUI;
E2UI=elevatorUI;



E1=elevator(1,ctl_core,E1UI,F1,F2,F3);
E2=elevator(2,ctl_core,E2UI,F1,F2,F3);

F1.cc=ctl_core;
F2.cc=ctl_core;
F3.cc=ctl_core;




E1UI.id=1;
E1UI.cc=ctl_core;
E1UI.resize();
E2UI.id=2;
E2UI.cc=ctl_core;
E2UI.resize();

ctl_core.setE1(E1);
ctl_core.setE2(E2);

%edit elevator_core.sfx;
