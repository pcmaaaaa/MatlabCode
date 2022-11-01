function siProcessImageStripe(stripeData, averaging)

% siProcessImageStripe.m*****
% Takes data from data acquisition engine,
% formats it into a proper intensity image,
% and displays it
%
% Written by: Bernardo Sabatini
% Harvard Medical School
% HHMI
% 2009

	global state lastAcquiredFrame compositeData
	persistent vStripeW

	if nargin<2
		averaging=0;
	end
	
	if state.acq.dualLaserMode==2	% we are acquiring with alternating
		tempStripe=cell(1, state.init.maximumNumberOfInputChannels);
	else
		tempStripe=cell(1, state.init.maximumNumberOfInputChannels+10);
	end
	
	channelList=find(state.acq.acquiringChannel);
	startLine = 1 + state.acq.linesPerFrame/state.internal.numberOfStripes*state.internal.stripeCounter;
	stopLine = startLine + state.acq.linesPerFrame/state.internal.numberOfStripes - 1;
	
	for channelCounter = 1:length(channelList)
		channel=channelList(channelCounter);
		if state.acq.acquiringChannel(channel)  % are we acquiring data on this channel?
			if getfield(state.acq, ['pmtOffsetAutoSubtractChannel' num2str(channelCounter)])
				offset=getfield(state.acq, ['pmtOffsetChannel' num2str(channelCounter)]); % get PMT offset for channel
			else
				offset=0;
			end
								
			if state.acq.dualLaserMode==1 % both lasers are on at once
				displayChannel=channel;
				
				processedData = reshape(stripeData(:, channelCounter)/state.internal.intensityScaleFactor,  ...
					state.internal.samplesPerLine, ...
					(state.acq.linesPerFrame/state.internal.numberOfStripes))' ...
					- offset;
				
				if state.acq.bidi		% We are acquiring in both directions
					% so flip every other line
					processedData(2:2:end,:)=fliplr(processedData(2:2:end,:));
					
					if ~isnumeric(vStripeW) || isempty(vStripeW)
						vStripeW=0;
					end
					
					lenBD=state.internal.endDataColumnInLine-state.internal.startDataColumnInLine;
					startBD=floor((state.internal.samplesPerLine-lenBD)/2);

					if channel==state.acq.trackerChannel % put call in here to figure out if need cross-correl
						oddLine=sum(processedData(1:2:end,floor(end/10):floor(8*end/10)));
						evenLine=sum(processedData(2:2:end,floor(end/10):floor(8*end/10)));
						cc = normxcorr2(evenLine,oddLine);
						[maxCC, imax] = max(abs(cc(:)));
						if maxCC>0.2 && imax>=length(oddLine)
							vStripeW=imax-length(oddLine); %(xpeak-size(evenStripe,2))
						end
					end
					
					if vStripeW>0
 						vStripe=processedData(2:2:end,end-vStripeW:end);
 						processedData(2:2:end, :)=[vStripe processedData(2:2:end, 1:end-vStripeW-1)];
 					end
					tempStripe{channel}=...
						add2d(...
						processedData(:, startBD:startBD+lenBD), ...
						state.acq.binFactor...
						);  
				else
					tempStripe{channel}=...
						add2d(...
						processedData(:, state.internal.startDataColumnInLine:state.internal.endDataColumnInLine), ...
						state.acq.binFactor...
						);  
				end
			elseif state.acq.dualLaserMode==2 % we are acquiring with alternating
				% lasers.  So process as two separate channels
				displayChannel=[channel channel+10];
				
				processedData=reshape(stripeData(:, channelCounter)/state.internal.intensityScaleFactor,  ...
					state.internal.samplesPerLine, ...
					(2*state.acq.linesPerFrame/state.internal.numberOfStripes))' ...
					- offset; % get twice as much data

				if state.acq.bidi		% We are acquiring in both directions
					% so flip every other line
 					processedData(2:2:end,:)=fliplr(processedData(2:2:end,:));
				end
				
				tempStripe{channel}=...
					add2d(...
					processedData(1:2:end-1, state.internal.startDataColumnInLine:state.internal.endDataColumnInLine), ...
					state.acq.binFactor...
					);  
				
				tempStripe{channel+10}=...
					add2d(...
					processedData(2:2:end, state.internal.startDataColumnInLine:state.internal.endDataColumnInLine), ...
					state.acq.binFactor...
					);  
			else
				disp('error')
			end
			
			clear processedData

			for channelToDisplay=displayChannel
				if averaging && (state.internal.frameCounter>1)
					lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:) = ...
						(((state.internal.frameCounter - 1) ...	
						* lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:))...
						+ tempStripe{channelToDisplay})...
						/state.internal.frameCounter;					
				else
					lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:) = tempStripe{channelToDisplay};
				end
				
				if state.acq.imagingChannel(channel)
					set(state.internal.imagehandle(channelToDisplay), 'EraseMode', 'none', 'CData', ...
						lastAcquiredFrame{channelToDisplay}(startLine:stopLine,:), ...
						'YData', [startLine stopLine]);
				end
			end
		end	
	end
	

	if state.internal.composite
		for counter=1:3
			channel=state.internal.compositeChannelSelections(counter);
			
			if channel>0 && channel<99 && state.acq.acquiringChannel(mod(channel,10)) && ...
					(state.acq.dualLaserMode==2 || (state.acq.dualLaserMode==1 && channel<=4))
				
				low = getfield(state.internal, ['lowPixelValue' num2str(channel)]);
				high = getfield(state.internal, ['highPixelValue' num2str(channel)]);

				compositeData(startLine:stopLine,:,counter)=...
					min(max(...
					(lastAcquiredFrame{channel}(startLine:stopLine,:) - low) / ...
					max(high-low,1)...
					,0)...
					,1);
			end
		end
		set(state.internal.compositeImagehandle, 'EraseMode', 'none', 'CData', compositeData(startLine:stopLine,:,:), ...
			'YData', [startLine stopLine]);
	end
	
	clear tempStripe displayChannel
	drawnow;




		