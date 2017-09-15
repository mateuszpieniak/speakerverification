function [eer, dcf08, dcf10, auc_roc] = ...
    metrics_and_plots(scoresResultPath)
% calculates the equal error rate (EER) performance measure.
%
% Inputs:
%   - scores        : likelihood scores for target and non-target trials
%   - labels        : true labels for target and non-target trials, can be
%					  either binary (0's and 1's) or a cell array with
%					  "target" and "impostor" string labels
%   - showfig       : if true the DET curve is displayed
%
% Outputs:
%   - eer           : percent equal error rate (EER)
%   - dcf08         : minimum detection cost function (DCF) with SRE'08
%                     parameters
%   - dcf10         : minimum DCF with SRE'10 parameters
%
%
% Omid Sadjadi <s.omid.sadjadi@gmail.com>
% Microsoft Research, Conversational Systems Research Center

fid = fopen(scoresResultPath, 'rt');
C = textscan(fid, '%f %f\r\n');
fclose(fid);

scores = C{1};
labels = C{2};

% cond = ~(scores == Inf | isnan(scores));
% scores = scores(cond);
% labels = labels(cond);

[~,I] = sort(scores);
x = labels(I);

FN = cumsum( x == 1 ) / (sum( x == 1 ) + eps);
TN = cumsum( x == 0 ) / (sum( x == 0 ) + eps);
FP = 1 - TN;
TP = 1 - FN;

FNR = FN ./ ( TP + FN + eps );
FPR = FP ./ ( TN + FP + eps );
difs = FNR - FPR;
idx1 = find(difs< 0, 1, 'last');
idx2 = find(difs>= 0, 1 );
x = [FNR(idx1); FPR(idx1)];
y = [FNR(idx2); FPR(idx2)];
a = ( x(1) - x(2) ) / ( y(2) - x(2) - y(1) + x(1) );
eer = 100 * ( x(1) + a * ( y(1) - x(1) ) );

if ( nargout > 1 ),
    Cmiss = 10; Cfa = 1; P_tgt = 0.01; % SRE-2008 performance parameters
    Cdet  = Cmiss * FNR * P_tgt + Cfa * FPR * ( 1 - P_tgt);
    %     Cdefault = min(Cmiss * P_tgt, Cfa * ( 1 - P_tgt));
    dcf08 = 100 * min(Cdet); % note this is not percent
end
if ( nargout > 2 ),
    Cmiss = 1; Cfa = 1; P_tgt = 0.001; % SRE-2010 performance parameters
    Cdet  = Cmiss * FNR * P_tgt + Cfa * FPR * ( 1 - P_tgt);
    %     Cdefault = min(Cmiss * P_tgt, Cfa * ( 1 - P_tgt));
    dcf10 = 100 * min(Cdet); % note this is not percent
end

figure(1)
plot_det(FPR, FNR);
hold on;

figure(2)
[X,Y,~,auc_roc] = perfcurve(labels,scores,1);
plot(X,Y);
set (gca, 'xtick', 0:0.1:1);
set (gca, 'xticklabel', 0:0.1:1');
xlabel('Fall-out')
ylabel('Recall')
hold on;
 



function plot_det(FPR, FNR)
% plots the detection error tradeoff (DET) curve

range = icdf([0.001 0.5]);
fnr = icdf(FNR);
fpr = icdf(FPR);
plot(fpr, fnr);

xtick = [0.001, 0.002, 0.005, 0.01, 0.02, 0.05, 0.1, 0.2, 0.5];

xticklabel = num2str(xtick*100, '%g\n');
xticklabel = textscan(xticklabel, '%s'); xticklabel = xticklabel{1};
set (gca, 'xtick', icdf(xtick));
set (gca, 'xticklabel', xticklabel);
xlim(range);
xlabel ('Fall-out [%]');

ytick = xtick;
yticklabel = num2str(ytick*100, '%g\n');
yticklabel = textscan(yticklabel, '%s'); yticklabel = yticklabel{1};
set (gca, 'ytick', icdf(ytick));
set (gca, 'yticklabel', yticklabel);
ylim(range);
ylabel ('Miss rate [%]')

grid on;
box on;
axis square;
axis manual;
hold on;


function y = icdf(x)
% computes the inverse of cumulative distribution function in x
y = -sqrt(2).*erfcinv(2 * ( x + eps));

