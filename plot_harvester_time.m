function plot_harvester_time(time,x1,x2,line,text,type,param,parName)

if contains(type,'Volt')==1
    figure()
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    plot(time,x1,'m','LineWidth',line);
    set(gca,'fontsize',text,'XColor','k','YColor','k','ZColor','k','GridColor','k');
    grid on
    grid minor
    title([strcat(parName(1:end-1),' = '), num2str(param),' $'],'FontWeight','normal');
    xlabel('Time','fontsize',text);
    ylabel('Voltage','fontsize',text);
    
elseif contains(type,'Mass')==1
    figure()
    set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
    plot(time,x1,'r',time,x2,'k','LineWidth',line);
    set(gca,'fontsize',text,'XColor','k','YColor','k','ZColor','k','GridColor','k');
    grid on, grid minor, hold on
    title([strcat(parName(1:end-1),' = '), num2str(param),' $'],'FontWeight','normal');
    legend('Mass 1','Mass 2')
    xlabel('Time','fontsize',text);
    ylabel('Displacement','fontsize',text);
    
%     figure()
%     set(gcf,'Units','Normalized','OuterPosition',[0 0 1 1])
%     subplot(2,2,1)
%     plot(time,x,'r','LineWidth',line);
%     set(gca,'fontsize',text,'XColor','k','YColor','k','ZColor','k','GridColor','k');
%     grid on
%     grid minor
%     title([strcat(parName(1:end-1),' = '), num2str(param),' $'],'FontWeight','normal');
%     xlabel('Time','fontsize',text);
%     ylabel('Displacement','fontsize',text);
%     
%     subplot(2,2,2)
%     plot(time,dx,'r','LineWidth',line);
%     set(gca,'fontsize',text,'XColor','k','YColor','k','ZColor','k','GridColor','k');
%     grid on
%     grid minor
%     title([strcat(parName(1:end-1),' = '), num2str(param),' $'],'FontWeight','normal');
%     xlabel('Time','fontsize',text);
%     ylabel('Velocity','fontsize',text);
%     
%     subplot(2,2,3)
%     plot(x((ti/tinc):end),dx((ti/tinc):end),'r','LineWidth',line);
%     set(gca,'fontsize',text,'XColor','k','YColor','k','ZColor','k','GridColor','k');
%     grid on
%     grid minor
%     title([strcat(parName(1:end-1),' = '), num2str(param),' $'],'FontWeight','normal');
%     xlabel('Displacement','fontsize',text);
%     ylabel('Velocity','fontsize',text);
%     
%     subplot(2,2,4)
%     plot3(time,x,dx,'r','LineWidth',line);
%     grid on
%     grid minor
%     title([strcat(parName(1:end-1),' = '), num2str(param),' $'],'FontWeight','normal');
%     set(gca,'fontsize',text,'YDir','reverse','XColor','k','YColor','k','ZColor','k','GridColor','k');
%     xlabel('Time','fontsize',text);
%     ylabel('Displacement','fontsize',text);
%     zlabel('Velocity','fontsize',text);
end
end