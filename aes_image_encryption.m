% AES-like Image Encryption using Ring (GF(2^8)) concept
clc; clear; close all;

% --- Step 1: Read a grayscale image ---
img = imread('cameraman.tif');  % built-in MATLAB image
imshow(img); title('Original Image');

% Convert image to uint8 matrix (0–255)
img = uint8(img);

% --- Step 2: Define AES polynomial and create Galois Field (Ring) ---
% AES uses x^8 + x^4 + x^3 + x + 1 as the irreducible polynomial
AES_poly = 'x^8 + x^4 + x^3 + x + 1';
GF_ring = gf(double(img), 8, hex2dec('11B'));  % 0x11B = AES polynomial

% --- Step 3: Define a simple key matrix (for demonstration) ---
key = gf([2 3 1 1; 1 2 3 1; 1 1 2 3; 3 1 1 2], 8, hex2dec('11B'));

% Pad image to make size multiple of 4
[m, n] = size(GF_ring);
if mod(m,4)~=0, GF_ring=[GF_ring; gf(zeros(4-mod(m,4),n),8,hex2dec('11B'))]; end
if mod(n,4)~=0, GF_ring=[GF_ring gf(zeros(m,4-mod(n,4)),8,hex2dec('11B'))]; end

% --- Step 4: AES-like MixColumns operation using ring arithmetic ---
enc_img = GF_ring;
for i = 1:4:size(enc_img,1)
    for j = 1:4:size(enc_img,2)
        block = enc_img(i:i+3, j:j+3);
        % Multiply key matrix (MixColumns-like)
        enc_block = key * block;
        enc_img(i:i+3, j:j+3) = enc_block;
    end
end

% Convert back to uint8 for display
enc_uint8 = uint8(enc_img.x);
figure, imshow(enc_uint8); title('Encrypted Image (Ring-based AES)');

% --- Step 5: Decryption using Inverse of key matrix ---
inv_key = inv(key); % inverse in GF(2^8)
dec_img = enc_img;
for i = 1:4:size(dec_img,1)
    for j = 1:4:size(dec_img,2)
        block = dec_img(i:i+3, j:j+3);
        dec_block = inv_key * block;
        dec_img(i:i+3, j:j+3) = dec_block;
    end
end

% Display decrypted image
dec_uint8 = uint8(dec_img.x);
figure, imshow(dec_uint8); title('Decrypted Image');
