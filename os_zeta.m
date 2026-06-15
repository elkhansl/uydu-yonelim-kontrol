%% --- YOL A: DOĞRUDAN Z-DOMAIN KUTUP YERLEŞTİRME ---

% 1. Adım: Performans Kriterlerini Belirle (İstediğin gibi değiştirebilirsin)
Overshoot = 5;      % %5 aşım istiyoruz
SettlingTime = 0.4; % Sistemin 0.4 saniyede hedefe oturmasını istiyoruz

% S-Domain hedef kutup parametrelerinin hesabı
zeta = -log(Overshoot/100) / sqrt(pi^2 + log(Overshoot/100)^2);
wn = 4 / (zeta * SettlingTime);

% S-Domain dominant kutuplar: s^2 + 2*zeta*wn*s + wn^2 = 0
s1 = -zeta*wn + 1i*wn*sqrt(1-zeta^2);
s2 = -zeta*wn - 1i*wn*sqrt(1-zeta^2);

% 2. Adım: Kutupları Z-Domainine Eşle (z = e^(s*Ts))
z1 = exp(s1 * Ts);
z2 = exp(s2 * Ts);

% İstenen Dominant Polinom: (z - z1)*(z - z2) = z^2 + gamma1*z + gamma0
Desired_Dominant_Poly = poly([z1, z2]);
gamma1 = Desired_Dominant_Poly(2);
gamma0 = Desired_Dominant_Poly(3);

% 3. Adım: Motorun G(z) Katsayılarını Çek
% G(z) = (b1*z + b0) / (z^2 + a1*z + a0)
[num_z, den_z] = tfdata(G_z, 'v');
b1 = num_z(2);
b0 = num_z(3);
a1 = den_z(2);
a0 = den_z(3);

% 4. Adım: Diophantine (Lineer Denklem) Sistemini Kur ve Çöz
% Bilinmeyenler: X = [q1; q0; z3]  (q1=Kp+Ki, q0=-Kp, z3=3.Kutup yeri)
% Matris yapısı: M * X = Y
M = [ b1,  0,   1;
      b0, b1,  gamma1;
       0, b0,  gamma0 ];
  
Y = [ gamma1 - a1 + 1;
      gamma0 - a0 + a1;
      a0 ];

% Denklem sistemini çöz (Matrix Inversion / Backslash)
X = M \ Y;

q1 = X(1);
q0 = X(2);
z3 = X(3); % Sistemimizin kendi kendine belirlediği 3. kutup

% 5. Adım: PI Kazançlarını Ayıkla
Kp_tasarim = -q0;
Ki_tasarim = (q1 + q0) / Ts;

fprintf('\n--- MATEMATİKSEL TASARIM SONUÇLARI ---\n');
fprintf('Hesaplanan Kp: %f\n', Kp_tasarim);
fprintf('Hesaplanan Ki: %f\n', Ki_tasarim);
fprintf('Oluşan 3. Kutup Yeri (z3): %f (Kararlı mı: %d)\n', z3, abs(z3)<1);

%% 6. Adım: Doğrulamak İçin Kapalı Çevrim Simülasyonu
D_z = tfin(Kp_tasarim + Ki_tasarim*Ts*z/(z-1)); % PI Kontrolcü transfer fonksiyonu
D_z = ( (Kp_tasarim + Ki_tasarim*Ts)*s + 0 ) % Basit gösterim için el yapımı tf
D_z = tf([Kp_tasarim+Ki_tasarim*Ts, -Kp_tasarim], [1, -1], Ts);

T_z = feedback(D_z * G_z, 1); % Kapalı çevrim sistemi

figure(3);
step(3000 * T_z, 1.5); % 3000 RPM hedefi için 1.5 saniyelik yanıt
title('Matematiksel Tasarım Sonrası Motor Hızı (Z-Domain Step Response)');
grid on;