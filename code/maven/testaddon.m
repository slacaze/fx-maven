function testResults = testaddon( varargin )
    % Run the tests on the packaged Add-On
    % 
    % Runs a test suite defined in "pom.xml" on the packaged Add-On.
    %
    %   testaddon() runs the first test suite defined in "pom.xml", for the
    %   sandbox in the current path.
    %    
    %   testaddon( path ) runs the first test suite defined in "pom.xml",
    %   for the sandbox at the "path" location.
    %    
    %   testaddon( suite ) runs the "suite" test suite defined in
    %   "pom.xml", for the sandbox in the current path.
    %    
    %   testaddon( path, suite ) runs the "suite" test suite defined in
    %   "pom.xml", for the sandbox at the "path" location.
    %
    %   Example
    %      testaddon( 'unittest' );
    %
    %   See also mksandbox, addsandbox, rmsandbox, testsandbox,
    %   packagesandbox, installsandbox
    
    testResults = fx.maven.command.testaddon( varargin{:} );
end