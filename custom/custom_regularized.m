function restored = custom_regularized(blurred, PSF, lambda)
    % Regularized filter with Laplacian operator
    [M, N] = size(blurred);
    
    % Normalize PSF
    PSF = PSF / sum(PSF(:));

    % *** Center the PSF ***
    PSF_padded = zeros(M, N);
    [pM, pN] = size(PSF);
    PSF_padded(1:pM, 1:pN) = PSF;
    PSF_padded = circshift(PSF_padded, -floor([pM pN]/2));
    
    G = fft2(blurred);
    H = fft2(PSF_padded);
    
    % Laplacian kernel
    laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
    P = fft2(laplacian, M, N);
    
    F_hat = (conj(H) ./ (abs(H).^2 + lambda * abs(P).^2)) .* G;
    restored = real(ifft2(F_hat));
    
    % Simple normalization
    restored = restored - min(restored(:));
    if max(restored(:)) > 0
        restored = restored / max(restored(:));
    end
end