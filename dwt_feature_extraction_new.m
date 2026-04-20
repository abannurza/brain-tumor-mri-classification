clc;
clear;
close all;

%% ===== Path Coding & Dataset =====
basePath   = 'D:\Skripsi\Coding_Matlab';
datasetDir = fullfile(basePath, 'dataset_raw_selected');

outputExcel = fullfile(basePath,'feature_dwt_new.xlsx');

%% ===== Parameter DWT =====
waveletName = 'db4';
level = 2;

%% ===== Ambil file dari SUBFOLDER (kelas) =====
kelas = dir(datasetDir);
kelas = kelas([kelas.isdir]);
kelas = kelas(~ismember({kelas.name},{'.','..'}));

images = [];
imagePaths = {};
labels = {};

for k = 1:length(kelas)

    kelasPath = fullfile(datasetDir, kelas(k).name);

    disp(['>> Membaca subkelas: ', kelas(k).name])

    imgJPG = dir(fullfile(kelasPath, '*.jpg'));
    imgPNG = dir(fullfile(kelasPath, '*.png'));

    for i = 1:length(imgJPG)
        images = [images; imgJPG(i)];
        imagePaths{end+1,1} = kelasPath;
        labels{end+1,1} = kelas(k).name;
    end

    for i = 1:length(imgPNG)
        images = [images; imgPNG(i)];
        imagePaths{end+1,1} = kelasPath;
        labels{end+1,1} = kelas(k).name;
    end

end

nimages = length(images);

if nimages == 0
    error('Dataset kosong atau path salah');
end

disp(['Total citra ditemukan: ', num2str(nimages)])
disp('====================================')

%% ===== Inisialisasi =====
featureMatrix = [];
imageNames = cell(nimages,1);

%% ===== Loop Processing =====
for i = 1:nimages

    disp(['Ekstraksi citra ', num2str(i), '/', num2str(nimages), ...
          ' | Subkelas: ', labels{i}])

    %% ===== Baca Citra =====
    A = imread(fullfile(imagePaths{i}, images(i).name));

    %% ===== Resize =====
    B = imresize(A, [256 256]);

    %% ===== RGB ke Grayscale =====
    if size(B,3) == 3
        gray = rgb2gray(B);
    else
        gray = B;
    end

    %% ===== CLAHE Enhancement =====
    C = adapthisteq(gray);

    %% ===== Convert ke double =====
    C = im2double(C);

    %% ===== DWT Level 1 =====
    [cA1,cH1,cV1,cD1] = dwt2(C, waveletName);

    %% ===== DWT Level 2 =====
    [cA2,cH2,cV2,cD2] = dwt2(cA1, waveletName);

    %% ===== Feature Extraction =====
    subbands = {cA2, cH2, cV2, cD2, cH1, cV1, cD1};
    featureVector = [];

    for s = 1:length(subbands)

        sb = subbands{s};

        featureVector = [featureVector ...
            mean(sb(:)) ...
            std(sb(:)) ...
            sum(sb(:).^2)];

    end

    if i == 1
        featureMatrix = zeros(nimages,length(featureVector));
    end

    featureMatrix(i,:) = featureVector;
    imageNames{i,1} = images(i).name;

end

disp('====================================')
disp('✅ EKSTRAKSI FITUR DWT SELESAI')
disp(['Total citra diproses: ', num2str(nimages)])
disp('====================================')

%% ===== Nama Fitur =====
featureNames = {
    'A2_Mean','A2_STD','A2_Energy', ...
    'H2_Mean','H2_STD','H2_Energy', ...
    'V2_Mean','V2_STD','V2_Energy', ...
    'D2_Mean','D2_STD','D2_Energy', ...
    'H1_Mean','H1_STD','H1_Energy', ...
    'V1_Mean','V1_STD','V1_Energy', ...
    'D1_Mean','D1_STD','D1_Energy'
};

%% ===== Save ke Excel =====
T = array2table(featureMatrix,'VariableNames',featureNames);

T = addvars(T, labels, imageNames, ...
            'Before',1, ...
            'NewVariableNames',{'Class','ImageName'});

writetable(T, outputExcel);

disp(['📁 File Excel tersimpan di: ', outputExcel])