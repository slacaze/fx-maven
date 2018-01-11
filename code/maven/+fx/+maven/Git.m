classdef( Hidden ) Git
    
    methods( Static, Access = public )
        
        function decision = isInstalled()
            try
                fx.maven.Git.version();
                decision = true;
            catch
                decision = false;
            end
        end
        
        function version = version()
            txt = fx.maven.Git.run( '--version' );
            match = regexp( txt, 'git version (?<Version>[0-9.a-zA-Z]*)[\r\n]*$', 'once', 'names' );
            assert( ~isempty( match ), ...
                'Maven:MavenNotInstalled', ...
                'GIT does not appear to be installed.' );
            version = match.Version;
        end
        
        function clone( repo, path, echoFlag )
            command = sprintf( ...
                'clone -b develop "%s" "%s"', ...
                repo, path );
            if echoFlag
                fx.maven.Git.runWithEcho( command );
            else
                fx.maven.Git.run( command );
            end
        end
        
    end
    
    methods( Static, Hidden, Access = public )
        
        function varargout = run( varargin )
            if nargout == 0
                fx.maven.Git.doRun( false, varargin{:} );
            else
                [varargout{1:nargout}] = fx.maven.Git.doRun( false, varargin{:} );
            end
        end
        
        function varargout = runWithEcho( varargin )
            if nargout == 0
                fx.maven.Git.doRun( true, varargin{:} );
            else
                [varargout{1:nargout}] = fx.maven.Git.doRun( true, varargin{:} );
            end
        end
        
    end
    
    methods( Static, Access = private )
        
        function varargout = doRun( echoFlag, varargin )
            command = sprintf( 'git %s', strjoin( varargin, ' ' ) );
            if echoFlag
                [flag, output] = system( command, '-echo' );
            else
                [flag, output] = system( command );
            end
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
                        'Maven exception on:\n%s\nWith output:\n%s\n', ...
                        command, ...
                        output );
                end
            end
        end
        
    end
    
end