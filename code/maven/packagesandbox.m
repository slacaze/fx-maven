function packagesandbox( varargin )
    % Package the sandbox into an MLTBX
    % 
    % Packages the sandbox into an MLTBX, using the "pom.xml" and the PRJ
    % file.
    %
    %   packagesandbox() packages the sandbox in the current folder.
    %    
    %   packagesandbox( path ) packages the sandbox in the "path" location.
    %
    %   Example
    %      mksandbox( 'filesystem' );
    %      packagesandbox();
    %      ver filesystem
    %
    %   See also mksandbox, addsandbox, rmsandbox, testsandbox, testaddon,
    %   installsandbox
    
    fx.maven.command.packagesandbox( varargin{:} );
end