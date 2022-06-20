clc;
clear;
data = readtable("D:\\тервер\\1\\033\\19\\r1z1.csv");
vals = (data.Variables)';

sz = size(vals);
n = sz(2); % объем выборки
min = vals(1); % минимум
max = 0; % максимум
for i = 1:n
    if min > vals(i)
        min = vals(i);
    end
    if max < vals(i)
        max = vals(i);
    end
end
ran = max - min; % размах

E = 0;
for c = vals
    E = E + c;
end
E = E / n; % мат ожидание
D_0 = 0;
for c = vals
    D_0 = D_0 + (c - E)^2;
end
D_0 = D_0 / n; % выборочная несмещенная дисперсия
D_1 = n / (n - 1) * D_0; % смещенная дисперсия

sigm = sqrt(D_0); % среднестат отклонение

gam = 0;
for c = vals
    gam = gam + (c - E)^3;
end
gam = gam / (n * sigm^3); % коэффициент ассиметрии

% сортировка пузырьком
vars = vals;
for i = 1:n
    for j = 1:n-i
        if vars(j) > vars(j+1)
            x = vars(j); 
            vars(j) = vars(j+1); 
            vars(j+1) = x;
        end
    end
end
if mod(n, 2) == 1 % определяем медиану
    med = vars((1 + n) / 2); 
else
    med = (vars(n / 2) + vars((n / 2) + 1)) / 2;
end

if mod((n - 1), 4) == 0 % первая квартиль
    q1 = vars((n - 1) / 4 + 1);
else
    q1 = (vars(int32((n - 1) / 4) + 1) + vars(int32((n - 1) / 4) + 2)) / 2;
end

if mod(3 * (n - 1), 4) == 0 % третья квартиль
    q3 = vars(3 * (n - 1) / 4 + 1);
else
    q3 = (vars(int32(3 * (n - 1) / 4) + 1) + vars(int32(3 * (n - 1) / 4) + 2)) / 2;
end
intq = q3 - q1; %интерквартильная широта

% эмпирическая функция распределения
vartivs = 0; % вариаты
i = 1;
for c = vars
   if vartivs(i) ~= c
       if vartivs == 0
           vartivs = c;
       else
           vartivs = [vartivs c];
           i = i + 1;
       end
   end
end

m = size(vartivs);
k = zeros(1, m(2)); % количество встреченных в вариационном ряду одинаковых элементов
j = 1;
s = 1;
for i = 2:n
    if vars(i - 1) == vars(i)
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
subplot(1, 2, 1);
EFR = stairs(vartivs,efr); % построение графика????
%???

% график гистограммы выборки
h = 10; % шаг, по умолчанию
p = int32(n / h); % количество границ интервалов
marg = zeros(p,1); % границы интервалов
marg(1) = vars(1);
marg(end) = vars(end);
for i = 2:p - 1
    marg(i) = vars(1) + (i - 1) * (vars(end) - vars(1)) / (p - 1);
end

n_marg = zeros(p, 1);

i = 1;
for c = vars
    if c >= marg(i + 1)
        i = i + 1;
    else
        n_marg(i) = n_marg(i) + 1;
    end
end

subplot(1, 2, 2);
bar(marg, n_marg);

fprintf('Обьем выборки:'); disp(n);
fprintf('Минимум:'); disp(min);
fprintf('Максимум:'); disp(max);
fprintf('Размах:'); disp(ran);
fprintf('Математическое ожиидание:'); disp(E);
fprintf('Выборочная несмещенная дисперсия:'); disp(D_0);
fprintf('Смещенная дисперсия:'); disp(D_1);
fprintf('Выборочное среднестатистическое отклонение:'); disp(sigm);
fprintf('Коэффициент асимметрии:'); disp(gam);
fprintf('Медиана:'); disp(med);
fprintf('Интерквартильная широта:'); disp(intq);