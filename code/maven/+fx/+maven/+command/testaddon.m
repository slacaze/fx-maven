function testResults = testaddon( varargin )
    parser = inputParser;
    parser.KeepUnmatched = true;
    parser.addOptional( 'Path', pwd,...
        @fx.maven.util.mustBeValidPath );
    parser.addOptional( 'Suite', '',...
        @fx.maven.util.mustBeValidPackageName );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    try
        sandbox = fx.maven.ToolboxSandbox( inputs.Path );
        testResults = sandbox.testPackagedAddon( inputs.Suite, parser.Unmatched );
    catch matlabException
        if strcmp( matlabException.identifier, 'Maven:InvalidRoot' )
            % Try if the first argument was a suite
            inputs.Suite = inputs.Path;
            inputs.Path = pwd;
            sandbox = fx.maven.ToolboxSandbox( inputs.Path );
            testResults = sandbox.testPackagedAddon( inputs.Suite, parser.Unmatched );
        else
            matlabException.rethrow();
        end
    end
end