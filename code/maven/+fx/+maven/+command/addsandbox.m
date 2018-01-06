function addsandbox( varargin )
    parser = inputParser;
    parser.addOptional( 'Path', pwd,...
        @fx.fcam.util.mustBeValidPath );
    parser.parse( varargin{:} );
    inputs = parser.Results;
    sandbox = fx.maven.ToolboxSandbox( inputs.Path );
    sandbox.addToPath();
end