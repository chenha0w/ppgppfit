function [para,r,J,Sigma,mse,errorparam,robustw]=globalfit(filename,mdl,startpoint)
%each file include 3 column: x, y, uncertainty of y
%mdl is a cell containing functions for each x and y

delimiterIn='\t';
ncurve=length(filename);
for n=1:ncurve
    dataset{n}=importdata(filename{n},delimiterIn); 
    x{n}=dataset{n}(:,1);
    y{n}=dataset{n}(:,2);
    weight{n}=1./(dataset{n}(:,3).^2);
end

x_input=[];
y_input=[];
w_input=[];
mdl_input='@(beta,x) [';
for n=1:ncurve
    index_start=length(x_input)+1;
    x_input=[x_input;x{n}];
    y_input=[y_input;y{n}];
    w_input=[w_input;weight{n}];
    index_end=length(x_input);
    mdl_input=[mdl_input,sprintf('mdl{%d}(beta,x(%d:%d));',n,index_start,index_end)];
end
mdl_input=[mdl_input(1:end-1),'];'];
mdl_input=eval(mdl_input);
[para,r,J,Sigma,mse,errorparam,robustw]=nlinfit(x_input,y_input,mdl_input,startpoint,'Weights',w_input);

xx=linspace(0,2);
figure;
for n=1:ncurve
    subplot(1,ncurve,n);
    [yy{n},delta{n}]=nlpredci(mdl{n},xx,para,r,'covar',Sigma);
    fill([xx,fliplr(xx)],[yy{n}-delta{n},fliplr(yy{n}+delta{n})],'c');
    hold on;
    plot(xx,yy{n},'Linewidth',2,'Color','m');
    errorbar(x{n},y{n},dataset{n}(:,3),'ko');
    hold off;
    xlim([0,1.2]);
    title(filename{n}(1:end-4),'FontSize',20);
end