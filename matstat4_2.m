 clc;
clear;
data = readtable("D:\\тервер\\1\\033\\19\\r4z2.csv");
all = (data.Variables)';
x = all(1, :);
y=all(2, :);
X = 116;

n = length(x);
X_ = sum(x) / n;
Y_ = sum(y) / n;
S_x = sqrt(sum(x .^ 2) / n - X_ ^ 2);
S_y = sqrt(sum(y .^ 2) / n - Y_ ^ 2);

%Коэффициент корреляции:
r = 0;
for i = 1 : n
r = r + (x(i) - X_) * (y(i) - Y_);
end
r = r / (n * S_y * S_x);

%Уравнение регрессии
b_xy = r * S_y / S_x;
b = Y_ - b_xy * X_;
y_r = b_xy * x + b;

fprintf('Уравнение регрессии: y = %f * x + %f.\n', b_xy, b);
Y = b_xy * X + b;
fprintf('Прогноз признака Y по значению признака X = %f: Y = %f. \n', X, Y);
plot(x,y,'.', x, y_r, 'r')