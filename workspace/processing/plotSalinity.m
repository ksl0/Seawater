function plotSalinity(profile_num, disc, concentrationMat, y_km, z)
  % Creates a plot of salinity distribution and saves it within the current folder
  %     The concentrationMat should be in the 134 x 400 orientation, with
  %     the sea (higher salinity) on the lefthand side
  % Katie Li
  % July 15, 2015
  
  %% defaults; 
  set(0,'defaultFigurePosition',[1353 661 560 420])
  % set the default figure color to be white
  set(0,'defaultFigureColor',[1 1 1])
  % set the default font size to be 14
  set(0,'defaultaxesfontsize',14);
  set(0,'defaulttextfontsize',14);

  
  
  
  
  hFig = figure;
  hold on;
  % create a contour plot of the salinity distribution
  imagesc(y_km, z, concentrationMat);
  shading flat;
  h=colorbar('location', 'eastoutside'); %add a colorbar
  ylabel(h,'Salinity, ppt')
   
  title(sprintf('Saltwater concentration ppt, cells %s, Profile %s', ...
      disc, profile_num))
  ylabel('Depth (m)')
  xlabel('Landward distance, km')

  % a dotted line to show the land-sea border at 150 km
  coastx=[150 150 150];
  coasty=[-402 -200 0];
  plot(coastx, coasty, '--','Color','w') 
  axis tight;
  axis([0 200000 -402 0])
  
  hold off;
  % write figure to disk in the figures folder of current folder
  fig_name = sprintf('%s/figures/%s_%s_salinity.png', pwd, disc, profile_num);
  saveas(hFig, fig_name, 'png');
end
