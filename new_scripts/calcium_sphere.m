close all;
[x,y,z] = sphere();
xmin = min(BLC_raw_delta_F);
xmax = max(BLC_raw_delta_F);
ymin = min(BLC_raw_delta_F);
ymax = max(BLC_raw_delta_F);
zmin = min(BLC_raw_delta_F);
zmax = max(BLC_raw_delta_F);

%axis([xmin xmax ymin ymax zmin zmax]);
figure()
for i = 1:length(BLC_raw_delta_F)
    subplot(2,1,1)
    AX = surf(x*BLC_raw_delta_F(i),y*BLC_raw_delta_F(i),z*BLC_raw_delta_F(i));
    shading interp
    colormap(autumn)
    axis([-xmax xmax -ymax ymax -zmax zmax]);
    subplot(2,1,2)
    plot(Image_Time(i), temp(i), 'o', 'MarkerFaceColor', 'g', 'MarkerEdgeColor', 'g', 'MarkerSize', 8)
%     AX = surf(x*temp(i),y*temp(i),z*temp(i));
    hold on
    axis([min(Image_Time) max(Image_Time) min(temp) max(temp)]);
    pause(0.01)
end


