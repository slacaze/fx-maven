classdef SandboxGenerator
    
    methods( Access = public )
        
        function this = SandboxGenerator()
            assert( fx.maven.Maven.isInstalled(), ...
                'Maven:MavenNotInstalled', ...
                'MAVEN is required to use this toolbox. Make sure "mvn" is accessible.' );
        end
        
    end
    
    methods( Access = public )
        
        function projectPath = createToolboxSandbox( ~, groupId, artifactId )
            validateattributes( groupId,...
                {'char'}, {'scalartext'} );
            validateattributes( artifactId,...
                {'char'}, {'scalartext'} );
            projectPath = fx.maven.Maven.createArchetype( ...
                'fx.maven', 'toolbox-archetype', '1.0-SNAPSHOT', ...
                groupId, artifactId );
        end
        
    end
    
end