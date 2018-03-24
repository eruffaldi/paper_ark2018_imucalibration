function p2armAN( q, PPL, PPR )
%PLOT2ARM Summary of this function goes here
%   Detailed explanation goes here
  h1 = figure;
  set(h1,'Renderer','OpenGL')
  hold on
  grid
  ClR = 0.18;
  ClL = 0.18;
  el = 0;
  refse = 0.08;

  e0 = ellipsoidplot(10);

  Tall = modDHL(q(1:5));
  
  T0 = [1 0 0 0;0 0 -1 0;0 1 0 0; 0 0 0 1]*[[eye(3) [ClL 0 0]'];[0 0 0 1]];
     
  line([0 T0(1,4)],[0 T0(2,4)], [0 T0(3,4)],'Color',[1 0 0],'Marker','*');
  plotrefsys(eye(4),[],refse);
   
  Ti = T0*Tall(1:4,1:4); 
  
  line([T0(1,4) Ti(1,4)],[T0(2,4) Ti(2,4)], [T0(2,4) Ti(3,4)],'Color',[1 0 0],'Marker','*');
 

  for j=2:5
      Tim1 = Ti;
      Ti = Tim1*Tall(1:4,4*(j-1)+1:4*(j-1)+4);
      ee=ellipsoidplot(Tim1(1:3,4),Ti(1:3,4),0.15,0.15,e0);
      h1 = surfl(ee.x,ee.y,ee.z);
      hold on
      set(h1,'FaceColor','blue','EdgeColor','none');
      alpha(.4)
      
      si = abs(PPL(j-1))*1e3;
      ee = circle3dplot(Ti(1:3,4),Tim1(1:3,4),si,si,0.02);
      hold on
      surf(ee.x,ee.y,ee.z);
    end
%     
%     line([Ti{end}(1,4) Tn(1,4)],[Ti{end}(2,4) Tn(2,4)], [Ti{end}(3,4) Tn(3,4)], 'Color',[1 0 0],'Marker','*');
       
    t3 = q(3)-0.1436;
    y1 =  0.3120;
    x1 = -0.0573;
    S11 = [cos(t3) -sin(t3) 0 0;sin(t3) cos(t3) 0 0;0 0 1 0;0 0 0 1];
    S12 = [cos(y1) 0 sin(y1) 0; 0 1 0 0;-sin(y1) 0 cos(y1) 0; 0 0 0 1];
    S13 = [1 0 0 0;0 cos(x1) -sin(x1) 0;0 sin(x1) cos(x1) 0; 0 0 0 1];
    S14 = [[eye(3); 0 0 0] [-0.0237    0.2131   -0.0755 1]'];
    S1 = S11*S12*S13*S14;

    t5 = q(5)+3.0761;
    y2 =  0.3682;
    x2 =  -1.5961;
    S21 = [cos(t5) -sin(t5) 0 0;sin(t5) cos(t5) 0 0;0 0 1 0;0 0 0 1];
    S22 = [cos(y2) 0 sin(y2) 0; 0 1 0 0;-sin(y2) 0 cos(y2) 0; 0 0 0 1];
    S23 = [1 0 0 0;0 cos(x2) -sin(x2) 0;0 sin(x2) cos(x2) 0; 0 0 0 1];
    S24 = [[eye(3); 0 0 0] [0.0293   -0.1493   -0.0509 1]'];
    S2 = S21*S22*S23*S24;
    
    Sg1 = T0*Tall(1:4,1:4)*Tall(1:4,5:8)*S1;
    Sg2 = T0*Tall(1:4,1:4)*Tall(1:4,5:8)*Tall(1:4,9:12)*Tall(1:4,13:16)*S2;

    hold on

    plotrefsys(Sg1,[],refse,[],el);
    plotrefsys(Sg2,[],refse,[],el);
    
    %%Right Arm
    
    Tall = modDHR(q(6:10));

    T0 = [-1 0 0 0;0 0 1 0;0 1 0 0;0 0 0 1]*[[eye(3) [ClR 0 0]']; [0 0 0 1]];
    
    hold on

    line([0 T0(1,4)],[0 T0(2,4)], [0 T0(3,4)],'Color',[1 0 0],'Marker','*');    
    
    Ti = T0*Tall(1:4,1:4);

    line([T0(1,4) Ti(1,4)],[T0(2,4) Ti(2,4)], [T0(2,4) Ti(3,4)],'Color',[1 0 0],'Marker','*');

  for j=2:5
      Tim1 = Ti;
      Ti = Tim1*Tall(1:4,4*(j-1)+1:4*(j-1)+4);
      ee=ellipsoidplot(Tim1(1:3,4),Ti(1:3,4),0.15,0.15,e0);
      h1 = surfl(ee.x,ee.y,ee.z);
      hold on
      set(h1,'FaceColor','blue','EdgeColor','none');
      alpha(.4)


      si = abs(PPR(j-1))*1e3;
      ee = circle3dplot(Ti(1:3,4),Tim1(1:3,4),si,si,0.02);
      hold on
      surf(ee.x,ee.y,ee.z);
  end
      
%     line([Ti{end}(1,4) Tn(1,4)],[Ti{end}(2,4) Tn(2,4)], [Ti{end}(3,4) Tn(3,4)], 'Color',[1 0 0],'Marker','*');    

    t3 = q(3)+3.2359;
    y1 =  0.2130;
    x1 = 3.1184;
    S11 = [cos(t3) -sin(t3) 0 0;sin(t3) cos(t3) 0 0;0 0 1 0;0 0 0 1];
    S12 = [cos(y1) 0 sin(y1) 0; 0 1 0 0;-sin(y1) 0 cos(y1) 0; 0 0 0 1];
    S13 = [1 0 0 0;0 cos(x1) -sin(x1) 0;0 sin(x1) cos(x1) 0; 0 0 0 1];
    S14 = [[eye(3); 0 0 0] [0.0277    0.1952   -0.0679 1]'];
    S1 = S11*S12*S13*S14;

    t5 = q(5)+0.1697;
    y2 =  0.2723;
    x2 =  1.7433;
    S21 = [cos(t5) -sin(t5) 0 0;sin(t5) cos(t5) 0 0;0 0 1 0;0 0 0 1];
    S22 = [cos(y2) 0 sin(y2) 0; 0 1 0 0;-sin(y2) 0 cos(y2) 0; 0 0 0 1];
    S23 = [1 0 0 0;0 cos(x2) -sin(x2) 0;0 sin(x2) cos(x2) 0; 0 0 0 1];
    S24 = [[eye(3); 0 0 0] [-0.0591   -0.1926   -0.0130 1]'];
    S2 = S21*S22*S23*S24;

    Sg1 = T0*Tall(1:4,1:4)*Tall(1:4,5:8)*S1;
    Sg2 = T0*Tall(1:4,1:4)*Tall(1:4,5:8)*Tall(1:4,9:12)*Tall(1:4,13:16)*S2;

    hold on

    plotrefsys(Sg1,[],refse,[],el);
    plotrefsys(Sg2,[],refse,[],el);
    
    
    set(gca,'CameraPosition',[-1 1 1],'CameraTarget',[0 0 0])
    set(gcf,'DoubleBuffer', 'on')
    view([-20.2906,22.5725]);
    axis equal
    xlim([-0.5 0.5]), ylim([-0.6 0.2]), zlim([-0.8 0.2])
%     drawnow

end

