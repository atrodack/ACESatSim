function cnoise = oneoverf_noise(nsamps, oversamp, alpha, arg4, arg5)
% ONEOVERF_NOISE - generate 1/f^alpha noise time-series
%  
% Description: Uses fourier-space convolution to filter a noise time-series
%              with a 1/f^alpha power spectrum.  The oversampling factor
%              is used to add low-spatial frequency information to the
%              noise, and helps avoid edge effects.  A time-series of 
%              length nsamps*oversamp is generated and filtered, and the 
%              central nsamps is extracted and returned.  The output is 
%              normalized by setting the variance of the nsamps*oversamp
%              length vector to 1.
%
%              A pre-generated noise vector can be passed in.  If the noise
%              is generated by this function, then it can be from the
%              normal (default) or uniform distribution.
%
% References: See "Generalized Noll Analysis..." by Jared Males
%
% Syntax:  cnoise = oneoverf_noise(nsamps, oversamp, alpha)
%          cnoise = oneoverf_noise(nsamps, oversamp, alpha, 'dist', 'uniform')
%          cnoise = oneoverf_noise(nsamps, oversamp, alpha, noise)
%
% Inputs:
%    nsamps   - the number of samples desired in the output
%    oversamp - the multiplicative oversampling factor, >= 1
%    alpha    - the PSD exponent
%
% Optional Inputs:
%    distribution - the last two arguments can be 'dist', 'uniform' or
%                   'dist', 'normal' to specify the input distribution. 
%                   The default is normal 
%    noise        - use a pre-made noise vector instead of generating one
%
% Outputs:
%    cnoise   - the correlated noise time-series of length nsamp
%
% Other m-files required: none
%
% Subfunctions: none
%
% MAT-files required: none
%
% See also: char_oneoverf.m
%
% Author: Jared R. Males
% email: jaredmales@gmail.com
% 
% History:
%  - written by JRM on 2015.05.29
%

%------------- BEGIN CODE --------------

if(oversamp < 1) 
   oversamp = 1;
end


%Parse arguments
if(nargin == 4 && ~isempty(arg4))
   %if noise vector is supplied as arg4, then we just use it
   noise = arg4;
   nsamps = length(noise)/oversamp;
else
   %otherwise, figure out which distribution to use
   dist = 0;
   
   if nargin == 5
      if strcmp(arg4,'dist') && strcmp(arg5,'normal')
         dist = 0;
      end
      if strcmp(arg4,'dist') && strcmp(arg5,'uniform')
         dist = 1;
      end
   end
      
   if dist == 1
      noise = rand(1, nsamps*oversamp);
   else
      noise = randn(1, nsamps*oversamp);
   end
end


N = length(noise);

% Calculate the PSD
f = fftshift((0:1:N-1)-N/2)/N;

envelope = 1./(abs(f).^(alpha/2.0));
envelope(1) = 0;

% Now conolve with the PSD
FT = fft(noise).*envelope;
out = real((ifft(FT)));

%Normalize to have variance = 1
out = out/std(out);

%Finally, cut out the middle segment
cnoise = out( floor(0.5*N)-floor(0.5*nsamps)+1: floor(0.5*N)-floor(0.5*nsamps)+nsamps);

end











