function restored = custom_wiener(blurred, PSF, K)
    % Wiener filter: balances restoration and noise suppression
    [M, N] = size(blurred);
    
    % Normalize PSF
    PSF = PSF / sum(PSF(:));

    % Pad PSF to image size with proper centering
    PSF_padded = zeros(M, N);
    [pM, pN] = size(PSF);
    PSF_padded(1:pM, 1:pN) = PSF;

    % Circular shift so PSF center is at (1,1)
    PSF_padded = circshift(PSF_padded, -floor([pM pN]/2));
    
    G = fft2(blurred);
    H = fft2(PSF_padded);
    
    % Wiener filter formula
    F_hat = (conj(H) ./ (abs(H).^2 + K)) .* G;
    restored = real(ifft2(F_hat));
    
    % Simple normalization
    restored = restored - min(restored(:));
    if max(restored(:)) > 0
        restored = restored / max(restored(:));
    end
end