function addsandbox( varargin )
    % Add the sandbox to the MATLAB path
    % 
    % Adds the source code, and the test folders to the MATLAB path. A
    % "pom.xml" must be present to define the sandbox.
    %
    %   addsandbox() adds the sandbox in the current folder to the MATLAB
    %   path.
    %    
    %   addsandbox( path ) adds the sandbox at the "path" location to the
    %   MATLAB path.
    %
    %   Example
    %      addsandbox();
    %
    %   See also mksandbox, rmsandbox, testsandbox, testaddon,
    %   packagesandbox
    
    fx.maven.command.addsandbox( varargin{:} );
end