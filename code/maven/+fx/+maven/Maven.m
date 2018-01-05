classdef( Hidden ) Maven
    
    methods( Static, Access = public )
        
        function decision = isInstalled()
            try
                fx.maven.Maven.version();
                decision = true;
            catch
                decision = false;
            end
        end
        
        function version = version()
            txt = fx.maven.Maven.run( '--version' );
            match = regexp( txt, '^Apache Maven (?<Version>[0-9.]*)', 'once', 'names' );
            assert( ~isempty( match ), ...
                'FCAM:MavenNotInstalled', ...
                'Maven does not appear to be installed.' );
            version = match.Version;
        end
        
        function decision = isArchetypeAvailable( archetypeGroupId, archetypeArtifactId )
            [output, ~] = fx.maven.Maven.run( ...
                sprintf( 'archetype:generate -DinteractiveMode=false -DarchetypeGroupId=%s -DarchetypeArtifactId=%s', archetypeGroupId, archetypeArtifactId ) );
            packageLine = regexp( ...
                output, ...
                sprintf( '\\[INFO\\] Archetype \\[%s:%s:[^\\]]*\\] found', archetypeGroupId, archetypeArtifactId ), ...
                'match' );
            decision = ~isempty( packageLine );
        end
        
        function projectPath = createArchetype( archetypeGroupId, archetypeArtifactId, archetypeVersion, groupId, artifactId )
            tempDir = tempname;
            mkdir( tempDir );
            here = cd( tempDir );
            comeBack = onCleanup( @() cd( here ) );
            command = sprintf( ...
                'archetype:generate -DinteractiveMode=false "-DarchetypeGroupId=%s" "-DarchetypeArtifactId=%s" "-DarchetypeVersion=%s" "-DgroupId=%s" "-DartifactId=%s" -Dgoals=matlab:fix-package-folder-names', ...
                archetypeGroupId, ...
                archetypeArtifactId, ...
                archetypeVersion, ...
                groupId, ...
                artifactId );
            fx.maven.Maven.run( command );
            projectPath = fullfile( tempDir, artifactId );
        end
        
    end
    
    methods( Static, Hidden, Access = public )
        
        function varargout = run( varargin )
            [flag, output] = system( ...
                sprintf( 'mvn %s', strjoin( varargin, ' ' ) ) );
            varargout{1} = output;
            if nargout > 1
                % Requesting the flag, not erroring out
                varargout{2} = flag;
            elseif flag ~= 0
                % Error handling
                missingMessage = '''mvn'' is not recognized as an internal or external command, operable program or batch file.';
                missingMessage = strrep( missingMessage, ' ', '[ \r\n]*' );
                if ~isempty( regexp( output, missingMessage, 'once' ) )
                    error( ...
                        'Maven:MavenNotInstalled', ...
                        'Maven does not appear to be installed.' );
                else
                    error( ...
                        'Maven:MavenError', ...
                        'Maven exception:\n%s\n', ...
                        output );
                end
            end
        end
        
    end
    
end