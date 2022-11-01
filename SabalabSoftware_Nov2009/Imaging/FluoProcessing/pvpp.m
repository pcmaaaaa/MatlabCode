function pv=pvpp(chan)
% % Pixel value per photon
global state imageData
	m=mean2(imageData{chan}(10:end-10, 10:end-10, :));
	s=std2(imageData{chan}(10:end-10, 10:end-10, :));

	m0=0;
	eval(['m0=state.acq.binFactor*state.acq.pmtOffsetChannel' num2str(chan) ';']);
	pv=s*s/(m-m0);
	disp(['offset = ' num2str(m0)]);
	disp(['mean = ' num2str(m-m0)]);
	disp(['var = ' num2str(s*s)]);
    disp(['avg # photons / pixel = ' num2str((m-m0)/pv)]);
	disp(['pvpp on channel ' num2str(chan) ' = ' num2str(pv)]);
	return