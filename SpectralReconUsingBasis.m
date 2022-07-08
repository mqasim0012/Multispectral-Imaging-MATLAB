%% INITIALIZE

% helpful variables
numOfBasisFuncs = 3;
wavelengths = linspace(400,700,31); % 31 wavelengths: 400, 410, ..., 700

% Hypothetical Camera spectral response
M = readtable("spectra.xls", "Sheet", "Sheet1");    % using M to match book notation: r=MBa
M = M{:,:};
M = M(5:65, 2:4);
M(2:2:end,:) = [];
M = M';


%% KEELE SECTION
spectra = readtable("spectra.xls", "Sheet", "Keele Spectra");
spectra = spectra(:, 2:32);
spectra = spectra{:,:}; % table to matrix so I can perform matrix operations
spectra=spectra/100;

spectraToBeTested = spectra(1,:);
spectraToBeTested = spectraToBeTested';

DatawithoutTestSpectra = spectra(2:end,:);

% actual camera response for first material r=M*spectraFrmDataSet
r = M*spectraToBeTested;

% getting 31x3 basis functions
[U1, S1, V1] = svd(spectra, 'econ');
V1 = V1(:,1:numOfBasisFuncs);
B = V1; % Match book notation: r=MBa

% Best possible approximation
X1 = V1' * spectra'; % 3*31 x 404x31
recon = X1' * V1';
firstMaterialBestPossibleApproximation = recon(1,:);

MB = M*B;

weights = MB \ r;

spectralApproximation = B*weights;

RMSE = sqrt(mean((spectraToBeTested - spectralApproximation).^2));

plot(wavelengths, spectraToBeTested);
hold on;
plot(wavelengths, firstMaterialBestPossibleApproximation);
plot(wavelengths, spectralApproximation);

legend('Actual spectral reflectance', 'Best possible approximation using 3 basis functions', 'Approximation using keele data basis functions');
title('Approximation of spectral reflectance using Keele basis functions');
xlabel('Wavelengths — λ');
ylabel('Reflectance factor');
hold off;

%title(['1st ' num2str(numOfBasisFuncs) ' basis functions without centering']);
%xlabel("Wavelengths — λ");

