function barPlots(title_details, y_km, Hv_out_fresh, Hv_out_saline,Hv_in_saline, x_size, y_size)
  % create summary plots for given profile and dispersivity that include
  % * salinity distribution* fresh SGD discharge, saline SGD 
  % discharge, and submarine grounwater discharge

  hFig = figure;
  subplot(3,1,1);
  bar(y_km,(-Hv_out_fresh(1,:).*3600.*24./x_size./y_size),'Facecolor','b','Edgecolor','b')               
  y_max=max(-Hv_out_fresh(1,:).*3600.*24./x_size./y_size);
  disp(y_max);
  hold on
  plot([150 150],[0 10], ':','Color','k')

 % axis([0 200 0 y_max*1.2])
  text(160,y_max*.75, 'Fresh SGD');

  subplot(3,1,2);
  bar(y_km,(-Hv_out_saline(1,:).*3600.*24./x_size./y_size),'Facecolor','r','Edgecolor','r')        %Creates a stacked bar plot                                            
  plot([150 150],[0 10], ':','Color','k')
 % axis([0 200 0 y_max*1.2])
  ylabel('q out [m/d]')
  text(160,y_max*.75, 'Saline SGD');
    
  y_cells = 200000/y_size;
  subplot(3,1,3);
  bar(y_km(1,1:y_cells-1),(-Hv_in_saline(1,:).*3600.*24./x_size./y_size),'Facecolor','r','Edgecolor','r')
  plot([150 150],[-10 10], ':','Color','k')
 % axis([0 200 -y_max*1.2 0])
  xlabel('Landward distance [km]')
  text(160,-y_max*.5, 'Saline SGR');

  fig_name1=sprintf('Salinity_profile_%s.tif', title_details);
  saveas(hFig,fig_name1);
  
  hold off;
end 
