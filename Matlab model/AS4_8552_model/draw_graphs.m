
figure 
hold all
timestep = 1:1:nt;
timestep1 = timestep/60*dt;
temp_bc = T(1,:)-273.15;
temp_centre = T(round(nz/2),:)-273.15;
plot(timestep1,temp_bc)
plot(timestep1,temp_centre)
% xlim([0 300]);
% ylim([0 200]);
xlabel('Time [mins]');
ylabel('Temperature [\circC]');
legend('T_{surface}','T_{centre}');
box on


figure
hold all
alpha_bc = alpha(1,:);
alpha_centre = alpha(int8(nz/2),:);
plot(timestep1,alpha_bc)
plot(timestep1,alpha_centre)
xlabel('Time [mins]');
ylabel('Degree of cure');
legend('\alpha_{surface}','\alpha_{centre}');
% xlim([0 400]);
ylim([0 1]);
box on


figure
hold all
layers=-0.5:(1/(InputData.nz-1)):0.5; %dimensionless thickness
plot(Stress(2,:)/1e3,layers);
xlabel('Residual Stress [kPa]');
ylabel('Dimensionless Thickness');
% xlim([-12,15]);
ylim([-0.5 0.5]);
box on



% figure
% time1 = [1:1:nt];
% T1 = Output.T-273.15;
% plot(time1,T1(1,:),'-')
% hold all
% plot(time1,T1(2,:),'-.')
% T2=Output.T(InputData.nz/2,:)-273.15;
% plot(time1,T2(:),'--')
% xlim([0 400]);
% ylim([0 140]);
% xlabel('Time [mins]');
% ylabel('Temperature [\circC]');
% legend('T_{oven}','T_{surface}','T_{centre}');
% 
% figure
% time1=InputData.timestep/InputData.nt*400;
% hold all
% plot(time1,Temp{1}(1,:),'-')
% plot(time1,Temp{2}(1,:),'--')
% plot(time1,Temp{3}(1,:),'-.')
% xlim([0 400]);
% ylim([0 140]);
% xlabel('Time [mins]');
% ylabel('Temperature [\circC]');
% legend('1.0','0.5','0.25');
% box on
% 
% figure
% time1 = InputData.timestep/InputData.nt*400;
% plot(time1,Alpha{3}(1,:),'-')
% hold all
% plot(time1,Alpha{3}(InputData.nz/2,:),'--')
% xlim([0 400]);
% ylim([0 1]);
% xlabel('Time [mins]');
% ylabel('Degree of cure');
% legend('\alpha_{surface}','\alpha_{centre}');
% 
% figure
% aline=linspace(-0.5,0.5,10);
% bline=linspace(-200,200,10);
% cline=zeros(10);
% hold all
% layers=-0.5:(1/(InputData.nz-1)):0.5; %dimensionless thickness
% plot(Sigma{1},layers,'-');
% plot(Sigma{2},layers,'--');
% plot(Sigma{3},layers,'-.');
% plot(Sigma{4},layers,'-.');
% plot(cline,aline,'-k');
% plot(bline,cline,'-k');
% % plot(Sigma{4},layers,'-.');
% xlabel('Residual Stress [MPa]');
% ylabel('Dimensionless Thickness');
% % legend('6.0%','3.0%','1.0%','0.0%');
% legend('13.8mm','18.5mm','25.4mm','50.8mm');
% % legend('1.0','0.5','0.25');
% xlim([-12,15]);
% ylim([-0.5 0.5]);
% box on
% 
% figure
% dline=linspace(-100,200,10);
% cline=zeros(10);
% hold all
% target_time = 164*60;
% layers=-0.5:(1/(InputData.nz-1)):0.5; %dimensionless thickness
% T1 = Output.T-273.15;
% plot(Temp{1}(:,target_time),layers,'-')
% plot(Temp{2}(:,target_time),layers,'-.')
% plot(Temp{3}(:,target_time),layers,'--')
% plot(Temp{4}(:,target_time),layers,'-.')
% plot(dline,cline,'-k');
% xlim([80 130]);
% ylim([-0.5 0.5]);
% xlabel('Temperature [\circC]');
% ylabel('Dimensionless Thickness');
% legend('13.8mm','18.5mm','25.4mm','50.8mm');
% box on
% 
% figure
% dline=linspace(-100,200,10);
% cline=zeros(10);
% hold all
% target_time = 164*60;
% layers=-0.5:(1/(InputData.nz-1)):0.5; %dimensionless thickness
% T1 = Output.T-273.15;
% plot(Alpha{1}(:,target_time),layers,'-')
% plot(Alpha{2}(:,target_time),layers,'-.')
% plot(Alpha{3}(:,target_time),layers,'--')
% plot(Alpha{4}(:,target_time),layers,'-.')
% plot(dline,cline,'-k');
% xlim([0 1]);
% ylim([-0.5 0.5]);
% xlabel('Degree of Cure [%]');
% ylabel('Dimensionless Thickness');
% legend('13.8mm','18.5mm','25.4mm','50.8mm');
% box on