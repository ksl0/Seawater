function plotSalinity(lpf_profile, disc, concentrationMat, y_km, z)
  % Creates a plot of salinity distribution and saves it within the current folder
  %     The concentrationMat should be in the 134 x 400 orientation, with
  %     the sea (higher salinity) on the lefthand side
  % Katie Li
  % July 15, 2015
  hFig = figure;
  hold on;
  % create a contour plot of the salinity distribution
  imagesc(y_km, z, concentrationMat);
  shading flat;
  h=colorbar; %add a colorbar
  ylabel(h,'Salinity, ppt')
   
  title(sprintf('Saltwater concentration in ppt in run %s %s', disc, lpf_profile))
  ylabel('Depth (m)')
  xlabel('Landward distance, km')

  % a dotted line to show the land-sea border at 150 km
  coastx=[150 150 150];
  coasty=[-402 -200 0];
  plot(coastx, coasty, '--','Color','w') 

  fig_name = sprintf('%s_%s_salinity.bmp', disc, lpf_profile);
  hold off;
  saveas(hFig, fig_name);
end
