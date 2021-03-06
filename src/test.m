%% Include class definitions.
addpath('classes/');

%% QSM definition.


CylData = [
% Rad   Len                  Sta                  Axe CPar CExt BI BO IIB Add
0.300 1.000  0.000  0.000  0.000  0.000  0.000  1.000    0    1  1  0   1   0;
0.200 1.414  0.000  0.000  1.000  0.707  0.000  0.707    1    2  1  0   2   0;
0.100 1.000  1.000  0.000  2.000  1.000  0.000  0.000    2    0  1  1   3   0;
0.200 1.414  0.000  0.000  1.000  0.000  0.707  0.707    1    4  2  1   1   0;
0.100 1.000  0.000  1.000  2.000  0.000  1.000  0.000    4    0  2  1   2   0;
0.200 1.414  0.000  0.000  1.000  0.000 -0.707  0.707    1    6  3  1   1   0;
0.100 1.000  0.000 -1.000  2.000  0.000 -1.000  0.000    6    0  3  1   2   0;
0.200 1.414  0.000  0.000  1.000 -0.707  0.000  0.707    1    8  4  1   1   0;
0.100 1.000 -1.000  0.000  2.000 -1.000  0.000  0.000    8    0  4  1   2   0;
];

%CylData(:,3:5) = bsxfun(@plus,CylData(:,3:5),[5 4 -10]);

BranchData = [
% BOrd   BPar   BVol   BLen   BAng   BHei
     0      0 0.4918 3.4140 0.0000 1.3333;
     1      1 0.2091 2.4140 0.7854 1.7499;
     1      1 0.2091 2.4140 0.7854 1.7499;
     1      1 0.2091 2.4140 0.7854 1.7499;
];

TreeData = [
 1.1192; % Total volume of the tree
 0.4918; % Volume of the trunk
 0.6273; % Total volume of all the branches
 2.0000; % Total height of the tree
 3.4140; % Length of the trunk
10.6560; % Total length of all the branches
 4.0000; % Total number of branches
 1.0000; % Maximum branch order
11.5058; % Total area of cylinders
 0.0000; % DBH = Diameter at breast height, from the QSM
 0.0000; % DBH from cylinder fitted to right place
 0.0000; % DBH from triangulation
];

ModelData = {CylData, BranchData, TreeData};

QSMsimple = QSMBCylindrical(ModelData);

%% Define leaf shape.

vertices = [
    -0.3  0.0  0.0;
    -0.3  1.0  0.0;
     0.3  1.0  0.0;
     0.3  0.0  0.0
];

tris = [
     1,  2,  3;...
     1,  3,  4
];

%% Leaf insertion.

% Insert 1 m2 of leaf area. 
LeafArea = [10,20];

Leaves = LeafModelTriangle(vertices, tris, {[1 2 3 4]});

[Leaves, NAccepted] = qsm_fanni(QSMsimple,...
                                Leaves,...
                                LeafArea,...
                                'Seed',1,...
                                'SizeFunctionParameters', {[0.25 0.30]},...
                                'Verbose',true);
%-

%% Export result.

Leaves.export_geometry('OBJ',true,'test_leaves_export.obj',4);    
QSMsimple.export_blender('test_qsm_export.txt',4);

%% Plot results.
QSMsimple.plot_cylinders();
hold on;
Leaves.plot_leaves();
hold off;
axis equal;
