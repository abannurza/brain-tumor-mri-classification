clc;
clear;
close all;

%% ===== Path Coding & Dataset =====
basePath   = 'D:\Skripsi\Coding_Matlab';
datasetDir = fullfile(basePath, 'dataset_raw_selected');

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

%% ===== Gabor Filter Bank =====
gaborArray = gaborFilterBank(2, 4, 15, 15);

%% ===== Inisialisasi =====
Fitur = [];
imagenames = cell(nimages,1);

%% ===== Loop Processing =====
for i = 1:nimages
    disp(['Ekstraksi citra ', num2str(i), '/', num2str(nimages), ...
          ' | Subkelas: ', labels{i}])

    A = imread(fullfile(imagePaths{i}, images(i).name));
    B = imresize(A, [256 256]);

    if size(B,3) == 3
        gray = rgb2gray(B);
    else
        gray = B;
    end

    C = adapthisteq(gray);

    featureVector = gaborFeatures(C, gaborArray, 32, 32);

    if i == 1
        Fitur = zeros(nimages, length(featureVector));
    end

    Fitur(i,:) = featureVector;
    imagenames{i,1} = images(i).name;
end

%% ===== Display Selesai =====
disp('====================================')
disp('✅ EKSTRAKSI FITUR GABOR SELESAI')
disp(['Total citra diproses: ', num2str(nimages)])
disp('====================================')

%% ===== Save to Excel (Label + Fitur) =====
T = array2table(Fitur);
T = addvars(T, labels, imagenames, ...
            'Before', 1, ...
            'NewVariableNames', {'Subkelas','NamaFile'});

filename = fullfile(basePath, 'feature_gabor_3.xlsx');
writetable(T, filename);

disp(['📁 File disimpan di: ', filename])
