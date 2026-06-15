clear; clc; close all;

%% 1. Fiziksel Parametreler ve Sürekli Zaman Modeli G(s)
R = 0.017; L = 0.00005; Kt = 0.05; Ke = 0.05; J = 0.0001; B = 0.0001;
s = tf('s');
G_omega = Kt / ((L*s + R)*(J*s + B) + Kt*Ke);
G_s = G_omega * (60 / (2*pi)); % RPM'e dönüşüm

%% 2. TEMİZ Z-Domain Modeli G(z) (Gecikme YOK)
Ts = 0.005; % 5 ms örnekleme zamanı
G_z = c2d(G_s, Ts, 'zoh');

fprintf('--- TEMİZ SİSTEM (Gecikmesiz) ---\n');
display(G_z);

%% 3. Performans Hedefleri
OS = 5;          % Maksimum %5 Aşım
ts_hedef = 0.4;  % 0.4 saniye oturma zamanı 

% Z-Domain hedef noktası hesabı (z_hedef)
zeta = -log(OS/100) / sqrt(pi^2 + log(OS/100)^2);
wn = 4 / (zeta * ts_hedef);

s_hedef = -zeta*wn + 1i*wn*sqrt(1-zeta^2);
z_hedef = exp(s_hedef * Ts); % Hedefi Z'ye haritalama

%% 4. Root Locus ve Hedefin Çizimi
figure(1);
rlocus(G_z); % Tertemiz sistemin kök eğrileri
hold on;

% Hedef noktamız (Kırmızı Yıldız)
plot(real(z_hedef), imag(z_hedef), 'p', 'MarkerSize', 12, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');
plot(real(z_hedef), -imag(z_hedef), 'p', 'MarkerSize', 12, 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k');

title('Gecikmesiz Temiz Sistem: Z-Domain Root Locus ve Hedef Noktamız');
axis([-1.5 1.5 -1.5 1.5]);
zgrid(zeta, 0);