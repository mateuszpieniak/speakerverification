% Binary-Binary free energy
% function score = freeEnergy(fea, rbm)
% weights = rbm{1};
% visibleBiases = rbm{2};
% hiddenBiases = rbm{3};
% 
% firstterm = visibleBiases' * fea;
% % 
% xj = bsxfun(@plus, weights*fea, hiddenBiases);
% xjprim = arrayfun(@(x) log(1+exp(x)), xj);
% 
% secondterm = sum(xjprim,1);
% score = firstterm+secondterm;
% 
% end

% Gaussian modification
function score = freeEnergy(fea, rbm)
weights = rbm{1};
biasesVisible = rbm{2};
biasesHidden = rbm{3};

firstterm = biasesVisible' * fea;
secondterm = zeros(1, size(fea, 2));
for i = 1:size(fea, 2)
    secondterm(i) = fea(:,i)' * fea(:,i);
end
secondterm = bsxfun(@plus, secondterm, biasesVisible'*biasesVisible);
secondterm = 0.5 .* secondterm;

thirdterm = bsxfun(@plus, weights*fea, biasesHidden);
thirdterm = log(1 + exp(thirdterm));
thirdterm = sum(thirdterm, 1);

score = firstterm - secondterm + thirdterm;

end