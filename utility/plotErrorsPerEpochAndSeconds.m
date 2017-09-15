%% Reconstruction and time for experiment 1

% txt = clipboard('paste');

errors = regexp(txt,'Errors:(\d+.\d+)', 'tokens');
errors = cat(1, errors{:});
errors = cellfun(@str2num, errors);

x = 1:(1/3):41;
plot(x, errors(1:end));
set(gca, 'xtick', 1:3:41)
xlabel('Epoka')
ylabel('Średni błąd rekonstrukcji')    
xlim([1 41])

seconds = regexp(txt,'(\d+.\d+) seconds', 'tokens');
seconds = cat(1, seconds{:});
seconds = cellfun(@str2num, seconds);
sum(seconds)

%% ROC validation
% y = [0.9572, 0.8248, 0.7083, 0.6816, 0.6728, 0.6379, 0.6459, 0.6182];
y = [0.7724, 0.8404, 0.7729, 0.7291, 0.6688, 0.6609, 0.6513, 0.6289];

x = 1:8;
scatter(x, y, 'filled');
set(gca, 'xticklabel', [2, 4, 8, 16, 32, 64, 128, 256]');
box on;
xlabel('Liczba rozkładów Gaussa')
ylabel('ROC AUC')