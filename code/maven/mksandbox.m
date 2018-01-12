function mksandbox( varargin )
    % Create a new sandbox
    % 
    % Creates a new sandbox, with a starting fodler structure, a POM file,
    % and PRJ file, some generic starting packages and functions.
    %
    %   mksandbox() creates a sandbox in the current folder, with default
    %   starting parameters.
    %    
    %   mksandbox( artifactId ) uses the specified artifact ID.
    %    
    %   mksandbox( artifactId, groupId ) uses the specified artifact ID,
    %   and group ID.
    %    
    %   mksandbox( artifactId, groupId, path ) uses the specified artifact
    %   ID, group ID, and creates the sandbox in the specified "path".
    %
    %   Example
    %      mksandbox( 'filesystem' );
    %      packagesandbox();
    %      ver filesystem
    %
    %   See also addsandbox, rmsandbox, testsandbox, testaddon,
    %   packagesandbox, installsandbox
    
    fx.maven.command.mksandbox( varargin{:} );
end