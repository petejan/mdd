function makemovie(command)
% function to make a movie/time series of mooring component positions
global U V W z rho time uw vw
global H B Cd moorele ME 
global Hs Bs Cds mooreles MEs
global X Y Z Ti iobj jobj psi
global ZCO HCO BCO CdCO mooreleCO Iobj Pobj Jobj 
global ZCOs HCOs BCOs CdCOs mooreleCOs Iobjs Pobjs Jobjs
global Z0co Zfco Xfco Yfco psifco
global Zcots Xcots Ycots psicots Iobjts Jobjts Pobjts
global Xts Yts Zts Tits psits iobjts M figs ts
global h_edit_times h_edit_fps h_edit_angle h_edit_elevation ...
       h_edit_plttitle h_edit_time h_edit_xmax h_edit_figs
global times fps az el tmin tmax xmax nomovie tit
global its tindx
global fs

fontsz=11;
if isempty('fs'), fs=12; end
if nargin==0 , command=0, end
if isempty(tmin) & ~isempty(time), 
   tmin=min(time);
   tmax=max(time);
end
if command == 5, 
   az=340;
   el=20;
   xmax=100;
   figs=1.0;
   tit='Mooring Design and Dynamics';
end
if command == 2,
   if isempty(times), times=1; end
   if isempty(fps), fps=8; end
elseif command==10 | command==1,
   nomovie=1;
   tminmax=str2num(get(h_edit_time,'String'));
   tmin=tminmax(1);tmax=tminmax(2);
   if command==10, command=0; end
elseif command==101,
   nomovie=101;
   tminmax=minmax(time);
   tmin=tminmax(1);tmax=tminmax(2);
   command=1;
elseif command==20 | command == 9,
   az=str2num(get(h_edit_angle,'String'));
   el=str2num(get(h_edit_elevation,'String'));
   xmax=str2num(get(h_edit_xmax,'String'));
   figs=str2num(get(h_edit_figs,'String'));
   if figs > 1.6, figs=1.6; end
   tit=get(h_edit_plttitle,'String');
   tminmax=str2num(get(h_edit_time,'String'));
   tmin=tminmax(1);tmax=tminmax(2);
   if command==20, command=5; end
end
%
if command==0,
   if isempty(U) & isempty(M),
     msgbox('Re-load the time dependant velocity data.');
     return
   end
   figure(3);close(3);
   figure(4);close(4);figure(4);clf
   set(gcf,'Units', 'Normalized',...
      'Position',[.05 .02 .3 .3],...
      'Name','Generate Time Series',...
      'Color',[.8 .8 .8],...
      'tag','mdmodplt');
   tplot4=uicontrol('Style','text',...
      'String','Start:End Times','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .65 .4 .2]);
   h_edit_time=uicontrol('Style','edit',...
      'Callback','makemovie(10)',...
      'String',num2str([tmin tmax]),'FontSize',fs,...
      'Units','Normalized',...
      'Position',[.6 .65 .35 .2]);
   if isempty(Xts),
      h_push_makeit=uicontrol('Style','Pushbutton',...
        'String','Generate Time Series','FontSize',fs,...
        'Units','normalized',...
        'Position',[.2 .45 .6 .2],...
        'Callback','makemovie(1)');
   else
      h_push_makeit=uicontrol('Style','Pushbutton',...
        'String','Generate New Time Series','FontSize',fs,...
        'Units','normalized',...
        'Position',[.2 .45 .6 .15],...
        'Callback','makemovie(1)');
      h_push_makeit=uicontrol('Style','Pushbutton',...
        'String','Construct A Movie','FontSize',fs,...
        'Units','normalized',...
        'Position',[.3 .25 .4 .15],...
        'Callback','makemovie(5)');
   end
   h_push_cls=uicontrol('Style','Pushbutton',...
      'String','Close','FontSize',fs,...
      'Units','normalized',...
      'Position',[.3 .01 .4 .1],...
      'Callback','makemovie(4)');
   %
elseif command==1,
   figure(4);close(4);
   if ~isempty(H) & ~isempty(B) & ~isempty(Cd),
      Us=U;Vs=V;Ws=W;rhos=rho;zs=z;
      Hs=H;Bs=B;Cds=Cd;MEs=ME;mooreles=moorele;
      Xts=[];Yts=[];Zts=[];iobjts=[];ts=[];Tits=[];psits=[];M=[];
      if ~isempty(BCO),
      HCOs=HCO;BCOs=BCO;CdCOs=CdCO;mooreleCOs=mooreleCO;Iobjs=Iobj;Jobjs=Jobj;Pobjs=Pobj;
      Zcots=[];Xcots=[];Ycots=[];Iobjts=[];Jobjts=[];Pobjts=[];
      end
      [mu,nu]=size(U);
      [mr,nr]=size(rho);
      [mz,nz]=size(z);
      tindx=find(time >= tmin & time <= tmax);
      if length(tindx) == 0,
         dt=time-tmin;
         dt=dt(find(dt>0));
         tindx=find(time == tmin + min(dt)); 
      end
      %
      iframe=0;
      for it=tindx,
         iframe=iframe+1;
         U=Us(:,it);
         V=Vs(:,it);
         W=Ws(:,it);
         if mr==mu & nr==nu,
            rho=rhos(:,it);
         else
            rho=rhos;
         end
         if mz==mu & nz==nu,
            z=zs(:,it);
         else
            z=zs;
         end
         %
         H=Hs;B=Bs;Cd=Cds;ME=MEs;moorele=mooreles;
         if ~isempty(BCOs),
            HCO=HCOs;BCO=BCOs;CdCO=CdCOs;mooreleCO=mooreleCOs;Iobj=Iobjs;Jobj=Jobjs;Pobj=Pobjs;
         end
         disp('  ');
         if time(it)>720000, %then we're using matlab time
            disp(['Time: ',datestr(time(it),0),'   '...
                  ,num2str(100*(iframe/length(tindx)),'%5.1f'),'%']);
         else
            disp(['Time: ',num2str(time(it),'%6.2f'),'   '...
                  ,num2str(100*(iframe/length(tindx)),'%5.1f'),'%']);
         end
         [X,Y,Z,iobj]=moordyn;
         % Save these time series values
         ts(iframe)=time(it);
         Xts(1:length(X),iframe)=X';
         Yts(1:length(Y),iframe)=Y';
         Zts(1:length(Z),iframe)=Z';
         Tits(1:length(Ti),iframe)=Ti';
         psits(1:length(psi),iframe)=psi';
         iobjts(1:length(iobj),iframe)=iobj';
         if ~isempty(BCO),
            Zcots(1:length(Zfco),iframe)=Zfco';
            Xcots(1:length(Xfco),iframe)=Xfco';
            Ycots(1:length(Yfco),iframe)=Yfco';
            psicots(1:length(psifco),iframe)=psifco';
            Iobjts(1:length(Iobj),iframe)=Iobj';
            Jobjts(1:length(Jobj),iframe)=Jobj';
            Pobjts(1:length(Pobj),iframe)=Pobj';
         end
      end  % now that we've generated the time series, maybe make a movie 
      B=Bs;H=Hs;Cd=Cds;ME=MEs;moorele=mooreles;  % restore things
      if ~isempty(BCOs),
         HCO=HCOs;BCO=BCOs;CdCO=CdCOs;mooreleCO=mooreleCOs;Iobj=Iobjs;Jobj=Jobjs;Pobj=Pobjs;
      end
      U=Us;V=Vs;W=Ws;rho=rhos;z=zs;
      if nomovie ~= 101, makemovie(5); end
   end
%
elseif command==5,
   figure(3);close(3);
   figure(4);close(4);figure(4);clf
   set(gcf,'Units', 'Normalized',...
      'Position',[.05 .02 .3 .3],...
      'Name','Construct a Movie',...
      'Color',[.8 .8 .8],...
      'tag','mdmodplt');
   tplot1=uicontrol('Style','text',...
      'String','3D View Angle: AZ','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .875 .55 .12]);
   h_edit_angle=uicontrol('Style','edit',...
      'Callback','makemovie(20)',...
      'String',num2str(az),'FontSize',fs,...
      'Units','Normalized',...
      'Position',[.7 .875 .2 .12]);
   tplot2=uicontrol('Style','text',...
      'String','3D View Elevation: EL','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .75 .55 .12]);
   h_edit_elevation=uicontrol('Style','edit',...
      'Callback','makemovie(20)',...
      'String',num2str(el),'FontSize',fs,...
      'Units','Normalized',...
      'Position',[.7 .75 .2 .12]);
   tplot3=uicontrol('Style','text',...
      'String','Plot Title','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .625 .2 .12]);
   h_edit_plttitle=uicontrol('Style','edit',...
      'Callback','makemovie(20)',...
      'String',tit,'FontSize',fs,...
      'Units','Normalized',...
      'Position',[.35 .625 .6 .12]);
   tplot4=uicontrol('Style','text',...
      'String','Start:End Times','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .5 .4 .12]);
   h_edit_time=uicontrol('Style','edit',...
      'Callback','makemovie(20)',...
      'String',num2str([tmin tmax]),'FontSize',fs,...
      'Units','Normalized',...
      'Position',[.6 .5 .35 .12]);
   tplot5=uicontrol('Style','text',...
      'String','Set X-Axis Limit [m]','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .375 .45 .12]);
   h_edit_xmax=uicontrol('Style','edit',...
      'Callback','makemovie(20)','FontSize',fs,...
      'String',num2str(xmax),...
      'Units','Normalized',...
      'Position',[.65 .375 .25 .12]);
   tplot6=uicontrol('Style','text',...
      'String','Figure Scale Factor','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .25 .5 .12]);
   h_edit_figs=uicontrol('Style','edit',...
      'Callback','makemovie(20)','FontSize',fs,...
      'String',num2str(figs),...
      'Units','Normalized',...
      'Position',[.7 .25 .2 .12]);
   h_push_makeit=uicontrol('Style','Pushbutton',...
      'String','Make the Movie','FontSize',fs,...
      'Units','normalized',...
      'Position',[.3 .125 .4 .12],...
      'Callback','makemovie(9)');
   h_push_cls=uicontrol('Style','Pushbutton',...
      'String','Close','FontSize',fs,...
      'Units','normalized',...
      'Position',[.3 .01 .4 .1],...
      'Callback','makemovie(4)');
   %
elseif command==9,
    %
    tindx=find(ts >= tmin & ts <= tmax);
    iframe=0;
    for it=tindx,
       iframe=iframe+1;
       figure(3);clf;
       hold on;
       set(3,'Units', 'Normalized',...
           'Position',[0.3 0.1/figs 0.4*figs 0.6*figs],...
           'Name','The Mooring Movie',...
           'Color',[0.8 0.8 0.8]);
       X=Xts(:,it);
       Y=Yts(:,it);
       Z=Zts(:,it);
       iobj=iobjts(:,it);
       if ~isempty(BCO),
          Zfco=Zcots(:,it);
          Xfco=Xcots(:,it);
          Yfco=Ycots(:,it);
          psifco=psicots(:,it);
          Iobj=Iobjts(:,it);
          Jobj=Jobjts(:,it);
          Pobj=Pobjts(:,it);
       end
       if it==tindx(1),
          zmax=1.1*sum(H(1,:));
          sw=0;
          dx=floor(xmax/40)*10;
          ymax=xmax;
          dy=dx;
          if zmax < 100, 
             zmax=100;
          else
             zmax=ceil(zmax/20)*20;
          end
          if abs(max(Z)-max(z)) < 20, 
             zmax=max(z);
             swx=[-xmax:0.2:xmax];
             swzx=(zmax+0.75)-sqrt(1+sin(swx));
             swy=[-ymax:0.2:ymax];
             swzy=(zmax+0.75)-sqrt(1+sin(swy));
             sw=1; 
          end
             xt=[-xmax:dx:0 dx:dx:xmax];
       end      
       % project onto sides
       hxp=plot3(X,ymax*ones(size(Y)),Z,'g');
       plot3(X(iobj(1)),ymax,Z(iobj(1)),'or',...
            'Markersize',9,'MarkerFaceColor',[1 .7 .7],'Clipping','off');
       hyp=plot3(ymax*ones(size(X)),Y,Z,'g');
       plot3(xmax,Y(iobj(1)),Z(iobj(1)),'or',...
            'Markersize',9,'MarkerFaceColor',[1 .7 .7],'Clipping','off');
       hzp=plot3(X,Y,zeros(size(Z)),'g');
       plot3(X(iobj(1)),Y(iobj(1)),0,'or',...
            'Markersize',9,'MarkerFaceColor',[1 .7 .7],'Clipping','off');
       % 
       plot3(X,Y,Z,'b');
       li=length(iobj);
       plot3(X(iobj(2:li-1)),Y(iobj(2:li-1)),Z(iobj(2:li-1)),'or',...
            'Markersize',8,'Clipping','off');
       plot3(X(iobj(1)),Y(iobj(1)),Z(iobj(1)),'or',...
            'Markersize',10,'MarkerFaceColor',[0.9 0 0],'Clipping','off');
       plot3(X(iobj(li)),Y(iobj(li)),Z(iobj(li)),'^b',...
          'Markersize',8,'MarkerFaceColor','b','Clipping','off');
       if ~isempty(BCO), % then there are clamp-on devices
      	plot3(Xfco,Yfco,Zfco,'om','Markersize',6,'Clipping','off');
   	 end

       %
       axis([-xmax xmax -ymax ymax 0 zmax]);
       box on;
       if sw==1, % plot surfaceof ocean
          box off;
          plot3(xmax*ones(size(swy)),swy,swzy,'b','Clipping','off');
          plot3(-xmax*ones(size(swy)),swy,swzy,'b','Clipping','off');
          plot3(swx,ymax*ones(size(swx)),swzx,'b','Clipping','off');
          plot3(swx,-ymax*ones(size(swx)),swzx,'b','Clipping','off');
       end
       set(gca,'XTick',xt,'XTickLabel',xt,'Fontsize',fontsz*figs);
       set(gca,'YTick',xt,'YTickLabel',xt);
       grid;
       view(az,el);
       xlabel('X [m]','Fontsize',fontsz*figs);
       ylabel('Y [m]','Fontsize',fontsz*figs);
       zlabel('Z [m]','Fontsize',fontsz*figs);
       title([tit,':  Time ',num2str(ts(it))],...
             'Fontsize',fontsz*figs);
       drawnow;
       if iframe==1,
          cfh=figure(3);
          M=moviein(length(tindx),cfh); 
       end
       M(:,iframe)=getframe(cfh);
    end % movie time loop
    if length(tindx)>1,
       figure(3);clf;
       set(3,'Units', 'Normalized',...
            'Position',[0.3 0.1/figs 0.4*figs 0.6*figs],...
            'Name','The Mooring Movie');
       movie(3,M,0);
    end
    figure(4);close(4);
    figure(3);close(3);
    moordesign(0);
elseif command==2,
   hf4=figure(4);clf
   set(gcf,'Units', 'Normalized',...
      'Position',[.05 .02 .25 .275],...
      'Name','Play Movie',...
      'Color',[.8 .8 .8]);
   tplot1=uicontrol('Style','text',...
      'String','Number of times:','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .8 .55 .125]);
   h_edit_times=uicontrol('Style','edit',...
      'Callback','makemovie(11)',...
      'String',num2str(times),'FontSize',fs,...
      'Units','Normalized',...      
      'Position',[.7 .8 .2 .125]);
   tplot2=uicontrol('Style','text',...
      'String','Speed (fps):','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .6 .55 .125]);
   h_edit_fps=uicontrol('Style','edit',...
      'Callback','makemovie(11)',...
      'String',num2str(fps),'FontSize',fs,...
      'Units','Normalized',...
      'Position',[.7 .6 .2 .125]);
   tplot5=uicontrol('Style','text',...
      'String','Figure Scale Factor','FontSize',fs,...
      'Units','normalized',...
      'Position',[.1 .4 .5 .125]);
   h_edit_figs=uicontrol('Style','edit',...
      'Callback','makemovie(11)',...
      'String',num2str(figs),'FontSize',fs,...
      'Units','Normalized',...
      'Position',[.7 .4 .2 .125]);
   h_push_play=uicontrol('Style','Pushbutton',...
      'String','Play Movie','FontSize',fs,...
      'Units','normalized',...
      'Position',[.3 .2 .4 .125],...
      'Callback','makemovie(3)');
   h_push_cls=uicontrol('Style','Pushbutton',...
      'String','Close','FontSize',fs,...
      'Units','normalized',...
      'Position',[.35 .01 .3 .125],...
      'Callback','makemovie(4)');
elseif command==11,
   times=str2num(get(h_edit_times,'String'));
   fps=str2num(get(h_edit_fps,'String'));
   figs=str2num(get(h_edit_figs,'String'));
   makemovie(2);
elseif command==3,
      hf3=figure(3);clf;axes('Visible','off');
      set(hf3,'Units', 'Normalized',...
         'Position',[0.3 0.1/figs 0.4*figs 0.6*figs],...
         'Name','The Mooring Movie');
      movie(hf3,M,times,fps);
elseif command==4,
   figure(3);close(3);
   figure(4);close(4);
   moordesign(0);
end

% fini