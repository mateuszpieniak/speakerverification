function [ score ] = testEnergy(fea, weights, biasesVisible, biasesHidden)


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
