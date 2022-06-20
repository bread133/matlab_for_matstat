clc;
clear;
data = readtable("D:\\тервер\\1\\033\\19\\r2z1.csv");
x = (data.Variables)';
y = x(2, :);
x(2, :) = [];
% K: Уменьшится (eto alternativnaya gipoteza)
% α = 0,01 (trebuemiy uroven' znachimosty)
% Гипотеза однородности: генеральные совокупности, из которых извлечены
% выборки, одинаковы и, значит, им соответствуютодинаковые фр, т.е.
% H0: P(A) = p = p0, p > p0
% H1: p < p0 (!)

sz = size(x);
n = sz(2); % обьем выборки
u = zeros(1, n);
for i = 1:n
    if x(i) - y(i) < 0 % вроде уменьшается, но eto ishodya iz H0, перепроверить!
        u(i) = 1;
    end
end
p0 = 0.5; % вероятность успеха (page 71, default value)
alpha = 0.01; % требуемый уровень значимости
% вид критической области, значение критической константы
C_krit = 0;
for i = 0:n
    t = C(n, i) / 2^n;
    if (t <= alpha) && (t > C_krit)
        C_krit = t;
    end
end
fprintf("Критическая константа - %f\n", C_krit)
fprintf("Вид критической области - M =(-infty; %f).\n", C_krit);

% статистика и вывод
M = M(u); % тестовая статистикa
fprintf("Тестовая статистика - %f\n", M);

if M < C_krit
    fprintf('Гипотеза H0 отклоняется\n');
else
    fprintf('Гипотеза H0 принимается\n');
end

% р-значение
p = 0;
for i = M:n
    p = p + C(n, i);
end
p = p / 2^n;

p = C(n, M + 1) / 2^n;
fprintf("p-значение - %e.\n", p);