function installsandbox( varargin )
    % Install the sandbox on Maven
    % 
    % Run the "install" Maven goal on this sandbox. A "pom.xml" must be
    % present to define the sandbox.
    %
    %   installsandbox() installs the sandbox in the current folder.
    %    
    %   installsandbox( path ) installs the sandbox at the "path" location.
    %
    %   Example
    %      installsandbox();
    %
    %   See also mksandbox, addsandbox, rmsandbox, testsandbox, testaddon,
    %   packagesandbox
    
    fx.maven.command.installsandbox( varargin{:} );
end