function plotDx(command, pos)

if nargin==0,
   command=0;
   pos=1;
end

global Z z Qx X B jobj iobj H moorele Ti ttl

v = X;
mxV = max(v);
offV = mxV*0.1;

c=get (gca,'colororder');

figure(1)

% plot the mooring as a line, floating components as blue dots, sinking in red
if (command == 0),
  % plot(v,Z-max(z),v(iobj),Z(iobj)-max(z),'.')
  hold on
  plot(X,Z-max(z),'color',c(pos,:))
  plot(X(iobj(B(H(4,:)==0)<0)),Z(iobj(B(H(4,:)==0)<0))-max(z),'.r',X(iobj(B(H(4,:)==0)>=0)),Z(iobj(B(H(4,:)==0)>=0))-max(z),'.b')
end

Xobj = X(iobj);
Zobj = Z(iobj);

% plot the items next to mooring

if (command == 1),
  k=1;
  for i=1:length(H(4,:))
    if (H(4,i)~=1)
      % tmp=num2str(Ti(iobj(k))/9.81,'%6.1f');
      % text(v(iobj(k))-offV, Z(iobj(k))-max(z), tmp)
      text(v(iobj(k))+mxV*0.04, Z(iobj(k))-max(z), moorele(i,:),'fontsize', 6)
      k=k+1;
    end
  end
end

% plot the element labels, with lines to components

if (command == 2)
  hold on
  Zn=cumsum(1+round(H(1,:)/100))'-1;
  Zs=Z(end)-max(z);
  k=1;
  for i=1:length(H(4,:))
    if (H(4,i)~=1)
      tmp=moorele(i,:);
      text(pos, Zs/Zn(length(Zn))*Zn(i), tmp, 'fontsize', 6, 'color', 'blue')
      plot([Xobj(k)+10 pos],[Zobj(k)-max(z) Zs/Zn(length(Zn))*Zn(i)],':')
      k=k+1;
    end
  end
end

% plot the load

if (command == 3)
  Zn=cumsum(1+round(H(1,:)/100))'-1;
  Zs=Z(end)-max(z);
  k=1;
  for i=1:length(H(4,:))
    if (H(4,i)~=1)
      if (iobj(k)+1 < length(Ti)),
        tmp=num2str(Ti(iobj(k)+1)/9.81,'%6.1f');
        text(pos, Zs/Zn(length(Zn))*Zn(i), tmp, 'fontsize', 6, 'color', 'blue')
      end
      k=k+1;
    end
  end
  tmp=num2str(Ti(end)/9.81,'%6.1f');
  text(pos, Zs, tmp, 'fontsize', 6, 'color', 'blue')
  text(pos, 50, 'load (kg)', 'fontsize', 8, 'color', 'blue')
end


grid on
title (ttl)
xlabel('dX (m)')
ylabel('depth (m)')

zm = round(max(z)/100+1)*100;

ylim([-zm 100])
xlim([-100 zm])

end
