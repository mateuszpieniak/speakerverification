%
%% Clear workspace
close all;
clear all;

%% Parameters
data = [-1 -1; 1 -1; -1 1; 1 1];
dataNormalized = zscore(data);
mode = 'LinearBinary';
nHidden = 100;
miniBatchSize = 4;
learningRate = 0.001;
learningRateFactor = 0;
cdSteps = 1000;
cdStepsIncremental = 0;
epochs = 500;
epochsFactorUpdate = 0; 
momentum = 0.0;
momentumFactor = 0;
lambda = 0.0;
lambdaFactor = 0;


nVisible = size(data,2);
a = -1;
b = 1;
weights = (b-a).*rand(nHidden, nVisible) + a;
biasesVisible = (b-a).*rand(nVisible, 1) + a;
biasesHidden = (b-a).*rand(nHidden, 1) + a;

%% Visualization
figure(1)
x = -2:0.1:2;
y = -2:0.1:2;
[X,Y] = meshgrid(x,y);

for i=1:length(x)
    for j=1:length(y)
        F(i,j) = freeEnergyBB([x(i) x(j)]', weights, biasesVisible, biasesHidden);
    end
end
surf(X,Y,F)
xlabel('$X_1$', 'Interpreter','latex')
ylabel('$X_2$', 'Interpreter','latex')
zlabel('Wolna energia', 'Interpreter','latex')

%% Learn
tic
[weightsNew, biasesVisibleNew, biasesHiddenNew] = mexTrainRBM(dataNormalized, ...
    weights, biasesVisible, biasesHidden, mode, nHidden, miniBatchSize, ...
    learningRate, learningRateFactor, cdSteps, cdStepsIncremental, epochs, ... 
    epochsFactorUpdate, momentum, momentumFactor, lambda, lambdaFactor);
toc

%% Visualization
figure(2)
for i=1:length(x)
    for j=1:length(y)
        F(i,j) = freeEnergyBB([x(i) x(j)]', weightsNew, biasesVisibleNew, biasesHiddenNew);
    end
end
surf(X,Y,F)
xlabel('$X_1$', 'Interpreter','latex')
ylabel('$X_2$', 'Interpreter','latex')
zlabel('Wolna energia', 'Interpreter','latex')

