clear all;

mousenamelist = {'SJ163','SJ164','SJ165'};

num_days=11;
timebin=500; %timebin of 50ms per data point
duration=40; %analysis duration of 30s
inputrate=1000; %1000Hz
baseline_duration=20; %baseline_duration: duration of the baseline used for the df/f calculation in

cmap = colormap(hsv(num_days));
timestamp=[-baseline_duration:timebin/1000:duration-baseline_duration];
idx=length(timestamp);

% %% Plotting intensity data
% %for mouse=1:length(mousenamelist)
% for mouse=3:3
%     filename = ['analysis_',mousenamelist{mouse},'.mat'];
%     load(filename,'raw_LED','dff_LED','raw_zone','dff_zone','raw_dispense','dff_dispense','raw_receptacle','dff_receptacle','latency_combined','latency2_combined','occupancy_combined','rewardtime_combined');
%     legend_mark=zeros(8,num_days);
%     for d=1:length(dataname);
%         for i=1:num_days
%             %df/f aligned to LED
%             figure(1);
%             plot(timestamp,squeeze(mean(dff_LED(i,d,:,1:idx),3))','color',cmap(i,:));
%             title('df/f(%) vs. time(s): 0s = LED on');
%             legend_mark(1,:)=ones(1,num_days);
%             hold on;
% 
%             %df/f aligned to LED zone entering
%             figure(2);
%             plot(timestamp,squeeze(mean(dff_zone(i,d,:,1:idx),3))','color',cmap(i,:));
%             title('df/f(%) vs. time(s): 0s = LED zone entering');
%             legend_mark(2,:)=ones(1,num_days);
%             hold on;
% 
%             %df/f aligned to pellet dispensing
%             counter=0; temp=[];
%             for j=1:length(rewardtime_combined(i,:))
%                 if(rewardtime_combined(i,j)>0) %if j th trial is a rewarded trial
%                     counter=counter+1;
%                     temp(counter,:)=dff_dispense(i,d,j,1:idx);
%                 end
%             end
%             if counter>0
%                 figure(3);
%                 plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
%                 title('df/f(%) vs. time(s): 0s = pellet dispensed');
%                 hold on;
%                 legend_mark(3,i)=1;
%             end
% 
%             %df/f alinged to receptacle entry
%             counter=0;  temp=[];
%             for j=1:length(rewardtime_combined(i,:))
%                 if(rewardtime_combined(i,j)>0) %if j th trial is a rewarded trial
%                     counter=counter+1;
%                     temp(counter,:)=dff_receptacle(i,d,j,1:idx);
%                 end
%             end
%             if(counter>0)
%                 figure(4);
%                 plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
%                 title('df/f(%) vs. time(s): 0s = receptacle entry');
%                 hold on;
%                 legend_mark(4,i)=1;
%             end
% 
%             %df/f aligned to LED. split into successful entry vs. no-entry
%             %trial
%             counter=0;  temp=[];
%             counter2=0; temp2=[];
%             for j=1:length(rewardtime_combined(i,:))
%                 if(occupancy_combined(i,j)>0) %if j th trial is a successful entry trial
%                     counter=counter+1;
%                     temp(counter,:)=dff_LED(i,d,j,1:idx);
%                 else %if jth trial is a no-entry trial
%                     counter2=counter2+1;
%                     temp2(counter2,:)=dff_LED(i,d,j,1:idx);
%                 end
%             end
%             if(counter>0)
%                 figure(5);
%                 plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
%                 title('df/f(%) vs. time(s): 0s = LED on (successful entry trials)');
%                 hold on;
%                 legend_mark(5,i)=1;
%             end
%             if(counter2>0)
%                 figure(6);
%                 plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
%                 title('df/f(%) vs. time(s): 0s = LED on (no-entry trials)');
%                 hold on;
%                 legend_mark(6,i)=1;
%             end
% 
%             %df/f aligned to zone entering. split into reward vs. no-reward
%             %trials
%             counter=0;  temp=[];
%             counter2=0; temp2=[];
%             for j=1:length(rewardtime_combined(i,:))
%                 if(rewardtime_combined(i,j)>0) %if j th trial is a reward trial
%                     counter=counter+1;
%                     temp(counter,:)=dff_zone(i,d,j,1:idx);
%                 else %if jth trial is a no-reward trial
%                     counter2=counter2+1;
%                     temp2(counter2,:)=dff_zone(i,d,j,1:idx);
%                 end
%             end
%             if(counter>0)
%                 figure(7);
%                 plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
%                 title('df/f(%) vs. time(s): 0s = zone entering (reward trials)');
%                 hold on;
%                 legend_mark(7,i)=1;
%             end
%             if(counter2>0)
%                 figure(8);
%                 plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
%                 title('df/f(%) vs. time(s): 0s = zone entering (no reward trials)');
%                 hold on;
%                 legend_mark(8,i)=1;
%             end
%         end
% 
%         for i=1:8
%             figure(i);
%             legend(legend_maker(legend_mark(i,:)));
%             hold off;
%         end
% 
%         delete(findall(0,'Type','figure'));
% %         stderror=std(dfoverf1,0,1)/sqrt(n);
% %         confplot(timestamp,mean(dfoverf1),stderror,stderror,'color',[1 0 0],'LineWidth',2);
%     end
% end
% 
% return;

%% Plotting normalized intensity data
%for mouse=1:length(mousenamelist)
for mouse=3:3
    filename = ['analysis_',mousenamelist{mouse},'.mat'];
    load(filename,'dff_LED_normalized','dff_zone_normalized','dff_dispense_normalized','dff_receptacle_normalized','latency_combined','latency2_combined','occupancy_combined','rewardtime_combined');
    legend_mark=zeros(8,num_days);
    for d=1:length(dataname);
        for i=1:num_days
            %df/f aligned to LED
            figure(1);
            plot(timestamp,squeeze(mean(dff_LED_normalized(i,d,:,1:idx),3))','color',cmap(i,:));
            title('normalized df/f(fraction) vs. time(s): 0s = LED on');
            legend_mark(1,:)=ones(1,num_days);
            hold on;

            %df/f aligned to LED zone entering
            figure(2);
            plot(timestamp,squeeze(mean(dff_zone_normalized(i,d,:,1:idx),3))','color',cmap(i,:));
            title('normalized df/f(fraction) vs. time(s): 0s = LED zone entering');
            legend_mark(2,:)=ones(1,num_days);
            hold on;

            %df/f aligned to pellet dispensing
            counter=0; temp=[];
            for j=1:length(rewardtime_combined(i,:))
                if(rewardtime_combined(i,j)>0) %if j th trial is a rewarded trial
                    counter=counter+1;
                    temp(counter,:)=dff_dispense_normalized(i,d,j,1:idx);
                end
            end
            if counter>0
                figure(3);
                plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
                title('normalized df/f (fraction) vs. time(s): 0s = pellet dispensed');
                hold on;
                legend_mark(3,i)=1;
            end

            %df/f alinged to receptacle entry
            counter=0;  temp=[];
            for j=1:length(rewardtime_combined(i,:))
                if(rewardtime_combined(i,j)>0) %if j th trial is a rewarded trial
                    counter=counter+1;
                    temp(counter,:)=dff_receptacle_normalized(i,d,j,1:idx);
                end
            end
            if(counter>0)
                figure(4);
                plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
                title('normalized df/f (fraction) vs. time(s): 0s = receptacle entry');
                hold on;
                legend_mark(4,i)=1;
            end

            %df/f aligned to LED. split into successful entry vs. no-entry
            %trial
            counter=0;  temp=[];
            counter2=0; temp2=[];
            for j=1:length(rewardtime_combined(i,:))
                if(occupancy_combined(i,j)>0) %if j th trial is a successful entry trial
                    counter=counter+1;
                    temp(counter,:)=dff_LED_normalized(i,d,j,1:idx);
                else %if jth trial is a no-entry trial
                    counter2=counter2+1;
                    temp2(counter2,:)=dff_LED_normalized(i,d,j,1:idx);
                end
            end
            if(counter>0)
                figure(5);
                plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
                title('normalized df/f (fraction) vs. time(s): 0s = LED on (successful entry trials)');
                hold on;
                legend_mark(5,i)=1;
            end
            if(counter2>0)
                figure(6);
                plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
                title('normalized df/f (fraction) vs. time(s): 0s = LED on (no-entry trials)');
                hold on;
                legend_mark(6,i)=1;
            end

            %df/f aligned to zone entering. split into reward vs. no-reward
            %trials
            counter=0;  temp=[];
            counter2=0; temp2=[];
            for j=1:length(rewardtime_combined(i,:))
                if(rewardtime_combined(i,j)>0) %if j th trial is a reward trial
                    counter=counter+1;
                    temp(counter,:)=dff_zone_normalized(i,d,j,1:idx);
                else %if jth trial is a no-reward trial
                    counter2=counter2+1;
                    temp2(counter2,:)=dff_zone_normalized(i,d,j,1:idx);
                end
            end
            if(counter>0)
                figure(7);
                plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
                title('normalized df/f (fraction) vs. time(s): 0s = zone entering (reward trials)');
                hold on;
                legend_mark(7,i)=1;
            end
            if(counter2>0)
                figure(8);
                plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
                title('normalized df/f (fraction) vs. time(s): 0s = zone entering (no reward trials)');
                hold on;
                legend_mark(8,i)=1;
            end
        end

        for i=1:8
            figure(i);
            legend(legend_maker(legend_mark(i,:)));
            hold off;
        end

        delete(findall(0,'Type','figure'));
%         stderror=std(dfoverf1,0,1)/sqrt(n);
%         confplot(timestamp,mean(dfoverf1),stderror,stderror,'color',[1 0 0],'LineWidth',2);
    end
end

return;
%% Plotting lifetime data
timebin = 1; %1s
duration=150; %duration of analysis=ITI interval
baseline_duration=50;%50s duration for baseline lifetime calculation
timebin=1; %1s timebin for FLIM data

timestamp=[-baseline_duration:timebin:duration-baseline_duration];
idx=length(timestamp);

for mouse=1:length(mousenamelist)
    filename = ['analysis_',mousenamelist{mouse},'.mat'];
    %load(filename,'dtau_LED','time_LED','dtau_zone','time_zone','dtau_dispense','time_dispense','dtau_receptacle','time_receptacle','latency_combined','latency2_combined','occupancy_combined','rewardtime_combined');
    load(filename,'dtau_LED','time_LED','pc_LED','dtau_zone','time_zone','pc_zone','dtau_dispense','time_dispense','pc_dispense','dtau_receptacle','time_receptacle','pc_receptacle','latency_combined','latency2_combined','occupancy_combined','rewardtime_combined');
    legend_mark=zeros(12,num_days);
   
    for i=1:num_days
        if(i==5)
            continue;
        end
        
        %         cmap2=hsv(size(pc_LED,2));
        %         for j=1:size(pc_LED,2)
        %             figure(20);
        %             plot(squeeze(pc_LED(i,j,1:idx)),'color',cmap2(j,:));
        %             hold on;
        %         end
        %         display('');
        %
        %         if(i==8)
        %             for j=1:limit
        %                 figure(21);
        %                 plot(squeeze(dtau_LED(i,j,1:idx)),'color',cmap2(j,:));
        %                 hold on;
        %             end
        %             display('');
        %         end

        list=zeros(1,size(pc_LED,2));
        %find out if all 20 trials were recorded correctly or the session
        %recording was cut short
        for j=1:size(pc_LED,2)
            if(pc_LED(i,j,1)~=0 && pc_zone(i,j,1)~=0)
                list(j)=1;
                if(rewardtime_combined(i,j)>0 && pc_dispense(i,j,1)==0)
                    list(j)=0;
                    display('recording was cut short');
                    display(mouse);
                    display(i);
                    display(j);
                end
                if(rewardtime_combined(i,j)>0 && pc_receptacle(i,j,1)==0)
                    list(j)=0;
                    display('recording was cut short');
                    display(mouse);
                    display(i);
                    display(j);
                end
            end
            
            if(pc_LED(i,j,1)==0)
                display('recording was cut short');
                display(mouse);
                display(i);
                display(j);
            end
        end
        
        %delta lifetime aligned to LED
        counter=0; temp=[]; temp2=[];
        for j=1:size(pc_LED,2)
            if(list(j)==1) %if the data was collected correctly during this trial
                counter=counter+1;
                temp(counter,:)=dtau_LED(i,j,1:idx);
                temp2(counter,:)=pc_LED(i,j,1:idx);
            end
        end
        if counter>0
            figure(1);
            plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = LED on');
            legend_mark(1,i)=1;
            hold on;
            
            figure(9);
            plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
            title('normalized photoncount vs. time(s): 0s = LED on');
            legend_mark(9,i)=1;
            hold on;
        end
        
        %delta lifetime aligned to LED zone entering
        counter=0; temp=[]; temp2=[];
        for j=1:size(pc_zone,2)
            if(list(j)==1) %if the data was collected correctly during this trial
                counter=counter+1;
                temp(counter,:)=dtau_zone(i,j,1:idx);
                temp2(counter,:)=pc_zone(i,j,1:idx);
            end
        end
        if counter>0
            figure(2);
            plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = LED zone entering');
            legend_mark(2,i)=1;
            hold on;
            
            figure(10);
            plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
            title('normalized photoncount vs. time(s): 0s = LED zone entering');
            legend_mark(10,i)=1;
            hold on;
        end
        
        %delta lifetime aligned to pellet dispensing
        counter=0; temp=[]; temp2=[];
        %for j=1:length(rewardtime_combined(i,:))
        for j=1:size(pc_dispense,2)
            if(rewardtime_combined(i,j)>0 && pc_dispense(i,j,1)~=0) %if j th trial is a rewarded trial
                counter=counter+1;
                temp(counter,:)=dtau_dispense(i,j,1:idx);
                temp2(counter,:)=pc_dispense(i,j,1:idx);
            end
        end
        if counter>0
            figure(3);
            plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = pellet dispensed');
            hold on;
            legend_mark(3,i)=1;
            
            figure(11);
            plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
            title('normalized photoncount vs. time(s): 0s = pellet dispensed');
            legend_mark(11,i)=1;
            hold on;
        end
        
        %delta lifetime alinged to receptacle entry
        counter=0;  temp=[];    temp2=[];
        %for j=1:length(rewardtime_combined(i,:))
        for j=1:size(pc_receptacle,2)
            if(rewardtime_combined(i,j)>0 && pc_receptacle(i,j,1)~=0) %if j th trial is a rewarded trial
                counter=counter+1;
                temp(counter,:)=dtau_receptacle(i,j,1:idx);
                temp2(counter,:)=pc_receptacle(i,j,1:idx);
            end
        end
        if(counter>0)
            figure(4);
            plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = receptacle entry');
            hold on;
            legend_mark(4,i)=1;
            
            figure(12);
            plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
            title('normalized photoncount vs. time(s): 0s = receptacle entry');
            legend_mark(12,i)=1;
            hold on;
        end
        
        %delta lifetime aligned to LED. split into successful entry vs. no-entry
        %trial
        counter=0;  temp=[];
        counter2=0; temp2=[];
        %for j=1:length(rewardtime_combined(i,:))
        for j=1:size(pc_LED,2)
            if(occupancy_combined(i,j)>0 && pc_LED(i,j,1)~=0) %if j th trial is a successful entry trial
                counter=counter+1;
                temp(counter,:)=dtau_LED(i,j,1:idx);
            elseif pc_LED(i,j,1)~=0%if jth trial is a no-entry trial
                counter2=counter2+1;
                temp2(counter2,:)=dtau_LED(i,j,1:idx);
            end
        end
        if(counter>0)
            figure(5);
            plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = LED on (successful entry trials)');
            hold on;
            legend_mark(5,i)=1;
        end
        if(counter2>0)
            figure(6);
            plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = LED on (no-entry trials)');
            hold on;
            legend_mark(6,i)=1;
        end
        
        %delta lifetime aligned to zone entering. split into reward vs. no-reward
        %trials
        counter=0;  temp=[];
        counter2=0; temp2=[];
        %for j=1:length(rewardtime_combined(i,:))
        for j=1:size(pc_zone,2)
            if(rewardtime_combined(i,j)>0 && pc_zone(i,j,1)~=0) %if j th trial is a reward trial
                counter=counter+1;
                temp(counter,:)=dtau_zone(i,j,1:idx);
            elseif pc_zone(i,j,1)~=0 %if jth trial is a no-reward trial
                counter2=counter2+1;
                temp2(counter2,:)=dtau_zone(i,j,1:idx);
            end
        end
        if(counter>0)
            figure(7);
            plot(timestamp,squeeze(mean(temp,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = zone entering (reward trials)');
            hold on;
            legend_mark(7,i)=1;
        end
        if(counter2>0)
            figure(8);
            plot(timestamp,squeeze(mean(temp2,1))','color',cmap(i,:));
            title('delta lifetime(ns) vs. time(s): 0s = zone entering (no reward trials)');
            hold on;
            legend_mark(8,i)=1;
        end
    end
    for i=1:size(legend_mark,1)
        figure(i);
        legend(legend_maker(legend_mark(i,:)));
        hold off;
    end
    delete(findall(0,'Type','figure'));
    %         stderror=std(dfoverf1,0,1)/sqrt(n);
    %         confplot(timestamp,mean(dfoverf1),stderror,stderror,'color',[1 0 0],'LineWidth',2);
end