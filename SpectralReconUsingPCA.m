%%
numOfBasisFuncs = 3;

% load keele data
spectra = readtable("spectra.xls", "Sheet", "Keele Spectra");
spectra = spectra(:, 2:32);
spectra = spectra{:,:}; % table to matrix so I can perform matrix operations
spectra=spectra/100;

wavelengths = linspace(400,700,31); % 31 wavelengths: 400, 410, ..., 700

% svd and keep first 3 PCA
[U1, S1, V1] = svd(spectra, 'econ');
V1 = V1(:,1:numOfBasisFuncs);
plot(wavelengths, V1);
title(['1st ' num2str(numOfBasisFuncs) ' basis functions without centering']);
xlabel("Wavelengths — λ");
%%

% svd on mean-centered data
m = mean(spectra);
meanCentered = spectra - ones(size(spectra, 1), 1)*m;
[U2, S2, V2] = svd(meanCentered, 'econ');
V2 = V2(:,1:numOfBasisFuncs);
figure;
plot(wavelengths, V2);
title(['1st ' num2str(numOfBasisFuncs) ' basis functions with centering']);
xlabel('wavelengths — λ');

% weighted basis
X1 = V1' * spectra'; % 3*31 x 404x31
X2 = V2' * meanCentered';

%%

% reconstruction
recon = X1' * V1';
recon1 = X2' * V2' + ones(size(spectra, 1), 1)*m;



%%

spectraFirstMaterial = spectra(1,:);
spectraFirstMaterialReproduced = recon(1,:);

plot(wavelengths, spectraFirstMaterial);
hold on;
plot(wavelengths, spectraFirstMaterialReproduced);

legend('Spectral Reflectance (Material 1)', ['Reconstruction using ' num2str(numOfBasisFuncs) ' basis functions']);
title([ 'Reconstruction (without mean-centering) using ' num2str(numOfBasisFuncs) ' basis functions' ]);
xlabel('Wavelengths — λ');
ylabel('Reflectance factor');
hold off;

