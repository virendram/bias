function ws = SingleVisu2(wc,type,L)
%
% This file is part of the software described in
%
% Alle Meije Wink and Jos B. T. M. Roerdink (2004)
% ``Denoising functional MR images:
%   a comparison of wavelet denoising and Gaussian smoothing''
% IEEE Trans. Med. Im. 23 (3), pp. 374-387
%
% please refer to that paper if you use this software
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% VisuThresh -- Visually calibrated Adaptive Smoothing
%  Usage
%    x = VisuThresh2(y,type,L)
%  Inputs
%    y      Signal upon which to perform visually calibrated Adaptive Smoothing
%    type   Type of thresholding, either 'Soft' (default) or 'Hard'
%    L      low-frequency cutoff for Wavelet Transform
%  Outputs
%    x      Result
%
% References
%    ``Ideal Spatial Adaptation via Wavelet Shrinkage''
%    by D.L. Donoho and I.M. Johnstone.
%
ws=wc;
[n,J] = dyadlength(ws(1,:));

ws1=[];
ws2=[];
ws3=[];

% collect the channels' coefficients
for j=J-1:-1:L 
    tl=length(dyad(j));

    ws1=[ws1 reshape(ws(dyad(j),dyad(j)),1,tl^2)];
    ws2=[ws2 reshape(ws(bdyad(j),dyad(j)),1,tl^2)];
    ws3=[ws3 reshape(ws(dyad(j),bdyad(j)),1,tl^2)];
end;
    
% compute the channels' thresholds
tl=length(ws1);
thr=sqrt(2*log(tl));  

% apply the threshold
switch(upper(type));
 case 'HARD'
  ws1 = HardThreshAbs(ws1,thr) ;
  ws2 = HardThreshAbs(ws2,thr) ;
  ws3 = HardThreshAbs(ws3,thr) ;
 case 'SOFT'
  ws1 = SoftThreshAbs(ws1,thr) ;
  ws2 = SoftThreshAbs(ws2,thr) ;
  ws3 = SoftThreshAbs(ws3,thr) ;
end;

%restore the 2DFWT layout
for j=J-1:-1:L 
    tl=length(dyad(j));

    ws(dyad(j),dyad(j))=reshape(ws1(1:tl^2),tl,tl);
    ws1(1:tl^2)=[];
    ws(bdyad(j),dyad(j))=reshape(ws2(1:tl^2),tl,tl);
    ws2(1:tl^2)=[];
    ws(dyad(j),bdyad(j))=reshape(ws3(1:tl^2),tl,tl);
    ws3(1:tl^2)=[];
end;

return

%
% Copyright (c) 1993-5.  Jonathan Buckheit, David Donoho and Iain Johnstone
%
    
%   
% Part of WaveLab Version 802
% Built Sunday, October 3, 1999 8:52:27 AM
% This is Copyrighted Material
% For Copying permissions see COPYING.m
% Comments? e-mail wavelab@stat.stanford.edu
%   
    






