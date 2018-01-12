classdef(Abstract) File
    
    properties( Abstract, GetAccess = protected, Constant )
        ValidNames
    end
    
    properties( GetAccess = public, SetAccess = immutable )
        FilePath char = char.empty
    end
    
    methods( Access = public )
        
        function this = File( filePath )
            fx.maven.util.mustBeValidFileName( filePath );
            filePath = fx.maven.util.getFullPath( filePath );
            assert( exist( filePath, 'file' ) == 2, ...
                'Maven:InvalidFile', ...
                'The file "%s" does not exist.', ...
                filePath );
            [~, name, ext] = fileparts( filePath );
            assert( ~isempty( regexp( [name ext], sprintf( '^%s$', this.ValidNames ), 'once' ) ),...
                'Maven:InvalidFile',...
                'This name "%s" does not mathc the regexp "%s".',...
                [name ext],...
                this.ValidNames );
            this.FilePath = filePath;
        end
        
    end
    
    methods( Access = protected )
        
        function updateFileContent( this, newContent )
            file = fopen( this.FilePath, 'w' );
            closeFile = onCleanup( @() fclose( file ) );
            fprintf( file, '%s', newContent );
        end
        
    end
    
end