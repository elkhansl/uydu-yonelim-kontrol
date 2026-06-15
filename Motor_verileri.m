% T-Motor U15 II KV80 Parametreleri
R = 0.017;          % Faz-Faz Direnci [Ohm]
L = 0.00005;        % Tahmini Endüktans [Henry]
Kt = 0.12;          % Tork Sabiti [Nm/A]
Ke = 0.12;          % Zıt-EMK Sabiti [V/(rad/s)]
J = 0.004;          % Atalet Momenti [kg.m^2] (CATIA'dan gelen veri)
B = 0.0001;         % Sürtünme Katsayısı (Tahmini)
K_prop = 0.000125;  % Pervane yük katsayısı
Kp = 0.0114;
% Kp = 5;
Ki = 2.43;
% Ki = 15;
Kd = 0.000033;

% % --- 2. Çalışma Noktasında Lineerleştirme ---
% omega_0 = 50; % Hedef RPM
% % Karesel yükün türevi alınarak eşdeğer sürtünme (Beq) bulunur:
% B_eq = B + (2 * K_prop * omega_0); 
% 
% % --- 3. Motorun Transfer Fonksiyonu G(s) ---
% s = tf('s');
% % Elektriksel ve Mekanik denklemlerin birleşimi:
% G = Kt / ( (L*s + R)*(J*s + B_eq) + Kt*Ke );
% 
% % G(s)'i ekrana yazdır:
% disp('Motor Transfer Fonksiyonu G(s):');
% G
% 
% % --- 4. Root Locus Çizimi ---
% figure;
% rlocus(G);
% title('Motorun Açık Çevrim Kök Yer Eğrisi (Root Locus)');
% grid on;