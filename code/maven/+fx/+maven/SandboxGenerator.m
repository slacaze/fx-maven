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
            archetypeGroupId = 'fx.maven';
            archetypeArtifactId = 'toolbox-archetype';
            archetypeVersion = '1.0-SNAPSHOT';
            assert( fx.maven.Maven.isArchetypeAvailable( archetypeGroupId, archetypeArtifactId, archetypeVersion ), ...
                'Maven:ArchetypeNotAvailable', ...
                'The archetype "%s:%s:%s" was not found, please run %s.', ...
                archetypeGroupId, archetypeArtifactId, archetypeVersion, ...
                '<a href="matlab: installMavenPlugin( ''RunTests'', false );">installMavenPlugin</a>' );
            projectPath = fx.maven.Maven.createArchetype( ...
                archetypeGroupId, archetypeArtifactId, archetypeVersion, ...
                groupId, artifactId );
        end
        
    end
    
end