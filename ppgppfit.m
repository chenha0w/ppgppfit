clear;
filename{1}='ER vs gr.txt';
filename{2}='ppgpp vs gr.txt';
filename{3}='R vs gr.txt';

Ccoef=4.64;
ERmax=19.39*3600/7336;
mdl{1}=@(a,x)((-sqrt(x.^2+4*a(1)*ERmax*(x/Ccoef+a(2)*ERmax)) ...
    +x+2*ERmax*Ccoef*a(2))/2/(Ccoef*a(2)-a(1)/Ccoef));
mdl{2}=@(a,x)((-x+sqrt(x.^2+4*a(1)*ERmax* ...
    (x/Ccoef+a(2)*ERmax)))/2./(x/Ccoef+a(2)*ERmax));
mdl{3}=@(a,x)(2*a(1)*(x/Ccoef+a(2)*ERmax)./ ...
    (sqrt(x.^2+4*a(1)*ERmax*(x/Ccoef+a(2)*ERmax))-x)/a(3));

startpoint=[0.14,0.01,0.4];

[para,r,J,Sigma,mse,errorparam,robustw]=...
    globalfit(filename,mdl,startpoint);
CI=nlparci(para,r,'covar',Sigma);