function rmsandbox( varargin )
    % Remove the sandbox from the MATLAB path
    %
    % Removes the source code, and the test folders of the sandbox from the
    % MATLAB path. A "pom.xml" must be present to define the sandbox.
    %
    %   rmsandbox() removes the sandbox in the current folder from the
    %   MATLAB path.
    %    
    %   rmsandbox( path ) removes the sandbox at the "path" location from
    %   the MALTAB path.
    %
    %   Example
    %      rmsandbox();
    %
    %   See also mksandbox, addsandbox, testsandbox, testaddon,
    %   packagesandbox
    
    fx.maven.command.rmsandbox( varargin{:} );
end