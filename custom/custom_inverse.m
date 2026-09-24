function restored = custom_inverse(blurred, PSF)
    % Inverse filter: divide by PSF in frequency domain
    [M, N] = size(blurred);
    
    % Normalize PSF
    PSF = PSF / sum(PSF(:));
    
    % *** FIX: shift PSF origin to (1,1) to match FFT convention ***
    PSF_shifted = ifftshift(PSF);
    
    % Pad PSF to image size
    PSF_padded = zeros(M, N);
    [pM, pN] = size(PSF_shifted);
    PSF_padded(1:pM, 1:pN) = PSF_shifted;
    
    G = fft2(blurred);
    H = fft2(PSF_padded);
    
    % Avoid division by zero
    H(abs(H) < 1e-6) = 1e-6;
    
    F_hat = G ./ H;
    restored = real(ifft2(F_hat));
    
    % Normalize
    restored = restored - min(restored(:));
    if max(restored(:)) > 0
        restored = restored / max(restored(:));
    end
end