%% INITIALIZE

%import changeSign.

% helpful variables
numOfBasisFuncs = 3;
wavelengths = linspace(400,700,31); % 31 wavelengths: 400, 410, ..., 700

% Hypothetical Camera spectral response
M = readtable("spectra.xls", "Sheet", "Sheet1");    % using M to match book notation: r=MBa
M = M{:,:};
M = M(5:65, 2:4);
M(2:2:end,:) = [];
M = M';



%% Create variable light distribution

maxGradient = 0.1;

lightDistribution = 1:31;
lightDistribution(1) = rand(1);
sign = 1;

changeSignThreshold = 0.9; % resistant to sign change

for i = 1:30

    % changeSignOrNot(sign, change)
    if (changeSign(sign, changeSignThreshold) == 1)
        changeSignThreshold = 0.9;
        if (sign == 1)
            sign = -1;
        else
            sign = 1;
        end
    else
        changeSignThreshold = changeSignThreshold - (changeSignThreshold/3);
    end
    
    upperBound = lightDistribution(i) + maxGradient;
    lowerBound = lightDistribution(i) - maxGradient;

    if lowerBound < 0 || 1 < upperBound
        changeSignThreshold = 0.9;
        if (sign == 1)
            sign = -1;
        else
            sign = 1;
        end
    end

    lightDistribution(i+1) = lightDistribution(i) + sign*rand(1)*(maxGradient);
end

% lightDistribution Plot
plot(wavelengths, lightDistribution, '.');
ylim([0,1])

%% Special Product of M and artificial light distribution

MVariableLight = zeros(3,31); % initialize

for i = 1:3
    for j = 1:31
        % R_i(λ_j)L(λ_j)
        MVariableLight(i, j) = M(i, j)*lightDistribution(j);
    end
end

%% KEELE Import
spectra = readtable("spectra.xls", "Sheet", "Keele Spectra");
spectra = spectra(:, 2:32);
spectra = spectra{:,:}; % table to matrix so I can perform matrix operations
spectra=spectra/100;

spectraToBeTested = spectra(1,:);
spectraToBeTested = spectraToBeTested';

DatawithoutTestSpectra = spectra(2:end,:);

%% Constant light model
% actual camera response for first material r=M*spectraFrmDataSet
r = M*spectraToBeTested;

% getting 31x3 basis functions
[U1, S1, V1] = svd(spectra, 'econ');
V1 = V1(:,1:numOfBasisFuncs);
B = V1; % Match book notation: r=MBa

% Best possible approximation
X1 = V1' * spectra'; % 3*31 x 404x31
recon = X1' * V1';
bestPossibleApproximation = recon(1,:);
bestPossibleApproximation = bestPossibleApproximation';

MB = M*B;

weights = pinv(MB) * r;

spectralApproximation = B*weights;

RMSE = sqrt(mean((spectraToBeTested - spectralApproximation).^2));
RMSEOfBestPossible = sqrt(mean((spectraToBeTested - bestPossibleApproximation).^2));

%% Constant Light PLOT

plot(wavelengths, spectraToBeTested);
hold on;
plot(wavelengths, bestPossibleApproximation);
plot(wavelengths, spectralApproximation);

legend('Actual spectral reflectance', 'Best possible approximation using 3 basis functions', 'Approximation using keele data basis functions');
title('Approximation of spectral reflectance using Keele basis functions');
xlabel('Wavelengths — λ');
ylabel('Reflectance factor');
hold off;

%title(['1st ' num2str(numOfBasisFuncs) ' basis functions without centering']);
%xlabel("Wavelengths — λ");

%% Variable light model

% actual camera response for first material r=M*spectraFrmDataSet
rLight = MVariableLight*spectraToBeTested;

% getting 31x3 basis functions
%[U1L, S1L, V1L] = svd(spectra, 'econ');
%V1L = V1L(:,1:numOfBasisFuncs);
%B = V1L; % Match book notation: r=MBa

% Best possible approximation
X1Light = V1' * spectra'; % 3*31 x 404x31
reconLight = X1Light' * V1';
bestPossibleApproximationLight = reconLight(1,:);
bestPossibleApproximationLight = bestPossibleApproximationLight';

MBLight = MVariableLight*B;

weightsLight = pinv(MBLight) * rLight;

spectralApproximationLight = B*weightsLight;

RMSE = sqrt(mean((spectraToBeTested - spectralApproximationLight).^2));
RMSEOfBestPossible = sqrt(mean((spectraToBeTested - bestPossibleApproximationLight).^2));

%% Variable Light PLOT

plot(wavelengths, spectraToBeTested);
hold on;
plot(wavelengths, bestPossibleApproximationLight);
plot(wavelengths, spectralApproximationLight);
plot(wavelengths, spectralApproximation);

legend('Actual spectral reflectance', 'Best possible approximation using 3 basis functions', 'Approximation using keele data basis functions (with light)', 'Approximation using keele data basis functions (no light)');
title('Approximation of spectral reflectance using Keele basis functions');
xlabel('Wavelengths — λ');
ylabel('Reflectance factor');
hold off;

%title(['1st ' num2str(numOfBasisFuncs) ' basis functions without centering']);
%xlabel("Wavelengths — λ");






