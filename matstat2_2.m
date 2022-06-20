% Доп параметры - Критерий Колмогорова
% α = 0.01
% H0: X ∼ N(µ = 0; σ^2 = 1)
clc;
clear;
data = readtable("D:\\тервер\\1\\033\\19\\r2z2.csv");
x = (data.Variables)';
sz = size(x);
n = sz(2); % обьем выборки

% ЭФР
% алгоритм сортировки пузырька (пжст исправь этот позор)
vals = x;
for i = 1:n
    for j = 1:n - i
        if vals(j) > vals(j + 1)
            t = vals(j);
            vals(j) = vals(j + 1);
            vals(j + 1) = t;
        end
    end
end

vartivs = 0; % вариаты
i = 1;
for c = vals
   if vartivs(i) ~= c
       if vartivs == 0
           vartivs = c;
       else
           vartivs = [vartivs c]; % тоже поменять
           i = i + 1;
       end
   end
end

m = size(vartivs);
k = zeros(1, m(2)); % количество встреченных в вариационном ряду одинаковых элементов

j = 1;
s = 1;
for i = 2:n
    if vals(i - 1) == vals(i)
        s = s + 1;
    else
        k(j) = s;
        s = 1;
        j = j + 1;
    end
end
k(j) = s;

efr = ones(1, m(2)) / n; % сложение в отдельном векторе
sum = k(1);
for i = 1:m(2)
    efr(i) = efr(i) * sum;
    sum = sum + k(i);
end

% нормальное распределение
stdnorm = (1/2)*(1+erf(vartivs/sqrt(2)));

plot(vartivs,stdnorm, Color='g')
hold on
stairs(vartivs,efr, Color='b'); % построение графика????
hold off

%тестовая статистика
d = max(abs(efr - stdnorm)) * sqrt(n);
fprintf('Тестовая статистика = %f\n', d);

% квантиль распределения Колмогорова
% критическая область
C_krit = sqrt(-log(0.01 / 2) / 2);
fprintf('Критическое значение = %f\n', C_krit);
fprintf('Критическая область = (%f; +infty)\n', C_krit);

% принимаем или опровергаем гипотезу?
if d > C_krit
    fprintf('H0: X ∼ N(µ = 0; σ^2 = 1) - отклоняется\n');
else
    fprintf('H0: X ∼ N(µ = 0; σ^2 = 1) - принимается\n');
end

%р-значение,,,
p = 2 * exp(-2 * (d / sqrt(n))^2);
fprintf('p-значение = %f\n', p);