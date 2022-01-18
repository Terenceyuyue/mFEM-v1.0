clc;clear;close all

Domain = @Rectangle_Domain;
h0 = 0.2;
[fd,fh,BdBox,pfix] = feval(Domain);
[node,elem] = distmesh2d(fd,fh,h0,BdBox,pfix);

figure;
showmesh(node,elem);
plotcircle(0,0,1)

phi = @(p) dcircle(p,0,0,1);

deps = 1e-8;



%% 1. ȥ�����ж��������ĵ�Ԫ

d = phi(node);
ip = (abs(d)<0.1*h0);
node = back2boundary(node,ip,phi);

d = phi(node);  Ix = (d>=0);
elemIf = Ix(elem);
idOut = (sum(elemIf,2)==3);
elem = elem(~idOut,:);

figure;
showmesh(node,elem);
plotcircle(0,0,1)

%% 2. ���ܽ��ͽ���һ�����������������εĸö������ص��߽�
ip1 = 1;
while ~isempty(ip1)
    
    d = phi(node);
    ip = (abs(d)<0.1*h0);
    node = back2boundary(node,ip,phi);
    
    d = phi(node);  Ix = (d>=0);  % ȥ��ǡ��һ�����ڱ߽��ϵ��ⲿ
    elemIf = Ix(elem);
    ix2 = (sum(elemIf,2)==3);
    elem = elem(~ix2,:); elemIf2 = elemIf(ix2,:);
    
    d = phi(node);  Ix = (d>0); % ������һ���ⲿ���������ͶӰ�ر߽�
    elemIf = Ix(elem);
    ix1 = (sum(elemIf,2)==1);
    Elem1 = elem(ix1,:); elemIf1 = elemIf(ix1,:);
    ip1 = Elem1(elemIf1);
    node = back2boundary(node,ip1,phi);    
end

%% 2. Reorder the vertices
node = node(unique(elem(:)),:);
NT = size(elem,1);
if ~iscell(elem), elem = mat2cell(elem,ones(NT,1),length(elem(1,:))); end
[~,~,totalid] = unique(horzcat(elem{:})');
elemLen = cellfun('length',elem);
elem = mat2cell(totalid', 1, elemLen)';
elem = cell2mat(elem);

figure;
showmesh(node,elem);

[node,elem] = distmesh2dTemp(node,phi,fh,h0,BdBox,pfix);

figure;
showmesh(node,elem);
% findnode(node);
% findelem(node,elem);
% plotcircle(0,0,1)











