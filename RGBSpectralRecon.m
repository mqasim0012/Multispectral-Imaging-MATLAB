%% 
wavelengths = linspace(400, 700, 31); % 31 wavelengths: 400, 410, ..., 700

% Excel equivalent of load keele.mat
spectra = readtable("spectra.xls", "Sheet", "Keele Spectra");
spectra = spectra(:, 2:32);
spectra = spectra{:,:}; % table to matrix so I can perform matrix operations

spectra=spectra/100;

% Equivalent to load camera.mat (extracts and preps 3x31 r matrix)
r = readtable("spectra.xls", "Sheet", "Sheet1");
r = r{:,:};
r = r(5:65, 2:4);
r(2:2:end,:) = [];
r = r';

rgb = r * spectra'; % (AB)^t = B^t A^t

metamers = (r\rgb)';
metamers2 = (r\rgb)';
metamers3 = (r\rgb)';

metamersWithPsuedoInverse = (pinv(r)*rgb)';

% plotting first spectral reflectance against its reproduction in terms of
% rgb

spectraFirstMaterial = spectra(35,:);
spectraFirstMaterialReproduced = metamers(35,:);
spectraFirstMaterialReproduced2 = metamers2(35,:);
spectraFirstMaterialReproduced3 = metamers3(35,:);
spectraFirstMaterialReproducedWithPinverse = metamersWithPsuedoInverse(29,:);

plot(wavelengths, spectraFirstMaterial);
hold on;
plot(wavelengths, spectraFirstMaterialReproduced);
plot(wavelengths, spectraFirstMaterialReproduced2);
plot(wavelengths, spectraFirstMaterialReproduced3);
plot(wavelengths, spectraFirstMaterialReproducedWithPinverse);

legend('Spectral Reflectance (Material 29)', 'Spectral Reconstruction using RGB division', 'Spectral Reconstruction with PseudoInverse');
title('Comparison of spectral reflectance of Material 29 to obtained rgb signal through 3-channel camera');
xlabel('Wavelengths — λ');
ylabel('Reflectance factor');
hold off;
%%

%plot(wavelengths, metamers(1:1,:));
%hold on;

%for i = 2:404
%    plot(wavelengths, metamers(i,:));
%end

