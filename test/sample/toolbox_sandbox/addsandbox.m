function addsandbox()
    if ~isempty( ver( 'fcam' ) )
        fx.fcam.command.addsandbox();
    else
        thisPath = fileparts( mfilename( 'fullpath' ) );
        addpath( fullfile(...
            thisPath,...
            'code',...
            'myapp' ) );
        addpath( fullfile(...
            thisPath,...
            'test' ) );
    end
end