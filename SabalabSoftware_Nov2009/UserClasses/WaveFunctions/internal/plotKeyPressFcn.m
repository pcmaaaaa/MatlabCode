function plotKeyPressFcn
	val = double(get(gcbo,'CurrentCharacter'));
	if length(val) ~= 1
        return
	end