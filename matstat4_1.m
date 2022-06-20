clc;
clear;
data = readtable("D:\\тервер\\1\\033\\19\\r4z1.csv");
all = (data.Variables)';
% T > C_krit

x = all(1, :);
y = all(2, :);
sz = size(x);
n = sz(2);

r = 6;
s = 4;
X1 = 115.05;
Xr = 123.05;
Y1 = 80.05;
Ys = 86.05;
alpha = 0.1;

% create intervals (по среднему арифметическому???)
x_r = zeros(r + 1, 1);
y_s = zeros(s + 1, 1);

tx = (Xr - X1) / (r - 1);
ty = (Ys - Y1) / (s - 1);

for i = 1:r
    x_r(i) = X1 + tx * (i - 1);
end
for i = 1 : s
    y_s(i) = Y1 + ty * (i - 1);
end

% create table
tab_sp = zeros(r + 2, s + 2);
i_ = 1;
j_ = 1;
for k = 1:n
    for i_ = 1:r + 1
        if(x_r(i_) > x(k))
            break;
        end
    end
    for j_ = 1:s + 1
        if(y_s(j_) > y(k))
            break;
        end
    end
    tab_sp(i_, j_) = tab_sp(i_, j_) + 1;
end

for i = 1:r + 1
    for j = 1:s + 1
        tab_sp(i, s + 2) = tab_sp(i, s + 2) + tab_sp(i, j);
        tab_sp(r + 2, j) = tab_sp(r + 2, j) + tab_sp(i, j);
        tab_sp(r + 2, s + 2) = tab_sp(r + 2, s + 2) + tab_sp(i, j);
    end
end

%statistic
T = 0;
for i = 1:r + 1
    for m = 1:s + 1
        T = T + (n * tab_sp(i, m) - tab_sp(i, s + 2) * tab_sp(r + 2, m))^2 / (n * tab_sp(i, s + 2) * tab_sp(r + 2, m));
    end
end

v = (r) * (s);
p = 0.535074105; % Excel
C_krit = 33.19624429; % Excel

fprintf("Уровень значимости: %f.\n", alpha);
fprintf("Статистика: %f.\n", T);
fprintf("Критическая константа: %f.\n", C_krit);
fprintf("Так как распределение хи-квадрат имеет \nправостороннюю критическую область,\nследовательно критическая область \nбудет иметь вид: (%f; +infty).\n", C_krit);
if T > C_krit
    fprintf("Отклоняем гипотезу.\n");
else
    fprintf("Принимаем гипотезу.\n");
end
fprintf("Критический уровень значимости: %f.\n", p);
