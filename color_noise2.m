% This function simulates the phase error of a mirror as 1/f^(alpha) noise
% N is the number of samples in each dimension
% alpha is the 1/f noise power
% mirror_figure is the peak-to-valley noise variation, in arbitrary units
% out is the mirror phase noise in same units as mirror_figure

function out = color_noise2(noise, alpha)

N = size(noise);
N = N(1);

FT = fft2(noise);

x = ((0:1:N-1)-N/2)'*ones(1,N);
y = ones(N, 1)*((0:1:N-1)-N/2);

envelope = fftshift(1./(x.^2+y.^2).^(alpha/4));
envelope(1,1) = 0; % DC component undefined, set to 0

FT = FT.*envelope;
out = real(fftshift(ifft2(FT)));
%out = out/(max(max(out)) - min(min(out)))*mirror_figure;
out = out/sqrt(sum(sum(out.^2)))*N;

end