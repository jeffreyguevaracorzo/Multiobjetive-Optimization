
% K. Deb and H. Jain, "An Evolutionary Many-Objective Optimization Algorithm 
% Using Reference-Point-Based Nondominated Sorting Approach, Part I: Solving
% Problems With Box Constraints,"
% IEEE Transactions on Evolutionary Computation,
% vol. 18, no. 4, pp. 577-601, Aug. 2014.

clc;
clear;
close all;

%% Problem Definition

CostFunction = @(x) MOP2(x);  % Cost Function

nVar = 5;    % Number of Decision Variables

VarSize = [1 nVar]; % Size of Decision Variables Matrix

VarMin = -1;   % Lower Bound of Variables
VarMax = 1;   % Upper Bound of Variables

% Number of Objective Functions
nObj = numel(CostFunction(unifrnd(VarMin, VarMax, VarSize)));


%% NSGA-II Parameters

% Generating Reference Points
nDivision = 10;
Zr = GenerateReferencePoints(nObj, nDivision);

MaxIt = 50;  % Maximum Number of Iterations

nPop = 80;  % Population Size

pCrossover = 0.5;       % Crossover Percentage
nCrossover = 2*round(pCrossover*nPop/2); % Number of Parnets (Offsprings)

pMutation = 0.5;       % Mutation Percentage
nMutation = round(pMutation*nPop);  % Number of Mutants

mu = 0.02;     % Mutation Rate

sigma = 0.1*(VarMax-VarMin); % Mutation Step Size


%% Colect Parameters

params.nPop = nPop;
params.Zr = Zr;
params.nZr = size(Zr,2);
params.zmin = [];
params.zmax = [];
params.smin = [];

%% Initialization

disp('Staring NSGA-III ...');

empty_individual.Position = [];
empty_individual.Cost = [];
empty_individual.Rank = [];
empty_individual.DominationSet = [];
empty_individual.DominatedCount = [];
empty_individual.NormalizedCost = [];
empty_individual.AssociatedRef = [];
empty_individual.DistanceToAssociatedRef = [];

pop = repmat(empty_individual, nPop, 1);
for i = 1:nPop
    pop(i).Position = unifrnd(VarMin, VarMax, VarSize);
    pop(i).Cost = CostFunction(pop(i).Position);
end

% Sort Population and Perform Selection
[pop, F, params] = SortAndSelectPopulation(pop, params);


%% NSGA-II Main Loop

for it = 1:MaxIt
 
    % Crossover
    popc = repmat(empty_individual, nCrossover/2, 2);
    for k = 1:nCrossover/2

        i1 = randi([1 nPop]);
        p1 = pop(i1);

        i2 = randi([1 nPop]);
        p2 = pop(i2);

        [popc(k, 1).Position, popc(k, 2).Position] = Crossover(p1.Position, p2.Position);

        popc(k, 1).Cost = CostFunction(popc(k, 1).Position);
        popc(k, 2).Cost = CostFunction(popc(k, 2).Position);

    end
    popc = popc(:);

    % Mutation
    popm = repmat(empty_individual, nMutation, 1);
    for k = 1:nMutation

        i = randi([1 nPop]);
        p = pop(i);

        popm(k).Position = Mutate(p.Position, mu, sigma);

        popm(k).Cost = CostFunction(popm(k).Position);

    end

    % Merge
    pop = [pop
           popc
           popm]; %#ok
    
    % Sort Population and Perform Selection
    [pop, F, params] = SortAndSelectPopulation(pop, params);
    
    % Store F1
    F1 = pop(F{1});

    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of F1 Members = ' num2str(numel(F1))]);

    % Plot F1 Costs
    figure(1);
    PlotCosts(F1);
    pause(0.01);
 
end

%% Results

disp(['Final Iteration: Number of F1 Members = ' num2str(numel(F1))]);
disp('Optimization Terminated.');


