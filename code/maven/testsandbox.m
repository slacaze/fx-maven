function testResults = testsandbox( varargin )
    % Run the tests of the sandbox
    % 
    % Runs a test suite defined in "pom.xml" on the sandbox.
    %
    %   testsandbox() runs the first test suite defined in "pom.xml", for
    %   the sandbox in the current path.
    %    
    %   testsandbox( path ) runs the first test suite defined in
    %   "pom.xml", for the sandbox at the "path" location.
    %    
    %   testsandbox( suite ) runs the "suite" test suite defined in
    %   "pom.xml", for the sandbox in the current path.
    %    
    %   testsandbox( path, suite ) runs the "suite" test suite defined in
    %   "pom.xml", for the sandbox at the "path" location.
    %
    %   Example
    %      testsandbox( 'unittest' );
    %
    %   See also mksandbox, addsandbox, rmsandbox, testaddon,
    %   packagesandbox, installsandbox
    
    testResults = fx.maven.command.testsandbox( varargin{:} );
end