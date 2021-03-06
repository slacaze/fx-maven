function addsandbox( varargin )
    if ~isempty( ver( 'maven' ) )
        fx.maven.command.addsandbox( varargin{:} );
    else
        thisPath = fileparts( mfilename( 'fullpath' ) );
        addpath( fullfile(...
            thisPath,...
            'code',...
            'maven' ), ...
            '-end' );
        addpath( fullfile(...
            thisPath,...
            'test' ), ...
            '-end' );
    end
end
