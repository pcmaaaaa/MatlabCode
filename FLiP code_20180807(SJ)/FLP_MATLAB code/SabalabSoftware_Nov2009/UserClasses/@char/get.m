function varargout=get(wavename, prop)
    if nargin==2
    elseif nargin==1
        error('char/get : expect wavename and property as arguments');
    end
else
    error('char/get : no functionality for non wavename strings');
end