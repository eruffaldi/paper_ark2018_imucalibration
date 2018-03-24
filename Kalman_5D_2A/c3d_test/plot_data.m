function [ ] = plot_data( mark )
h1=figure;   
    set(h1,'Renderer','OpenGL')
    hold on
    grid
    n_ind = 1;
    Cl = mark.Cl;
    Sh = mark.Sh;
    El_ex = mark.El_ex;
    El_in = mark.El_in;
    Wr_ex = mark.Wr_ex;
    Wr_in = mark.Wr_in;
    
    Elmp = (El_ex + El_in)/2;
    Wrmp = (Wr_ex + Wr_in)/2;
    
for i=1:size(Cl,1)
        clf
        grid
        hold on
        line([Cl(i,1) Sh(i,1)],[Cl(i,2) Sh(i,2)],[Cl(i,3) Sh(i,3)],'Color',[1 0 0],'Marker','*')
        line([Sh(i,1) Elmp(i,1)],[Sh(i,2) Elmp(i,2)],[Sh(i,3) Elmp(i,3)],'Color',[0 1 0],'Marker','*')
        line([Elmp(i,1) Wrmp(i,1)],[Elmp(i,2) Wrmp(i,2)],[Elmp(i,3) Wrmp(i,3)],'Color',[0 0 1],'Marker','*')
        plot3(El_ex(i,1),El_ex(i,2),El_ex(i,3),'b*');
        plot3(El_in(i,1),El_in(i,2),El_in(i,3),'b*');
        plot3(Wr_ex(i,1),Wr_ex(i,2),Wr_ex(i,3),'g*');
        plot3(Wr_in(i,1),Wr_in(i,2),Wr_in(i,3),'g*');
        plot3(Sh(i,1),Sh(i,2),Sh(i,3),'r*');
        plot3(Cl(i,1),Cl(i,2),Cl(i,3),'r*');
        hold off
        xlabel('x'), ylabel('y'), zlabel('z')
        xlim([-500 1000]), ylim([-500 1000]), zlim([-500 1000])
        set(gca,'CameraPosition',[-300 300 300],'CameraTarget',[0 0 0])
%         pause(0.001)
%     axis equal
    drawnow
    
    end
end