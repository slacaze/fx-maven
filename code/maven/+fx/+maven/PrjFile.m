classdef PrjFile < fx.maven.internal.File
    
    properties( GetAccess = protected, Constant )
        ValidNames = '[a-zA-Z]*[.]prj'
    end
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        Name(1,:) char
        Author(1,:) char
        Email(1,:) char
        Company(1,:) char
        Summary(1,:) char
        Description(1,:) char
        Version(1,:) char
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        Guid(1,:) char
    end
    
    methods
        
        function value = get.Name( this )
            value = this.findToken( 'param.appname' );
        end
        
        function this = set.Name( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.appname', value );
        end
        
        function value = get.Author( this )
            value = this.findToken( 'param.authnamewatermark' );
        end
        
        function this = set.Author( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.authnamewatermark', value );
        end
        
        function value = get.Email( this )
            value = this.findToken( 'param.email' );
        end
        
        function this = set.Email( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.email', value );
        end
        
        function value = get.Company( this )
            value = this.findToken( 'param.company' );
        end
        
        function this = set.Company( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.company', value );
        end
        
        function value = get.Summary( this )
            value = this.findToken( 'param.summary' );
        end
        
        function this = set.Summary( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.summary', value );
        end
        
        function value = get.Description( this )
            value = this.findToken( 'param.description' );
        end
        
        function this = set.Description( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.description', value );
        end
        
        function value = get.Version( this )
            value = this.findToken( 'param.version' );
        end
        
        function this = set.Version( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.version', value );
        end
        
        function value = get.Guid( this )
            value = this.findToken( 'param.guid' );
        end
        
        function this = set.Guid( this, value )
            validateattributes( value,...
                {'char'}, {'scalartext'} );
            this.updateToken( 'param.guid', value );
        end
        
    end
    
    methods( Access = public )
        
        function this = PrjFile( path )
            this@fx.maven.internal.File( path );
        end
        
    end
    
    methods( Access = private )
        
        function value = findToken( this, token )
            prjContent = fileread( this.FilePath );
            value = regexp( prjContent, sprintf( '<%s>(.*)</%s>', token, token ), 'once', 'tokens' );
            if isempty( value )
                % The token is unset
                value = char.empty;
            else
                value = value{1};
            end
        end
        
        function updateToken( this, token, value )
            prjContent = fileread( this.FilePath );
            setToken = regexp( prjContent, sprintf( '<%s>(.*)</%s>', token, token ), 'once', 'tokens' );
            if isempty( setToken )
                % The token is unset
                prjContent = regexprep( prjContent,...
                    sprintf( '<%s[ ]?/>', token ),...
                    sprintf( '<%s>%s</%s>', token, value, token ),...
                    1 );
                % There might be a second occurence
                prjContent = regexprep( prjContent,...
                    sprintf( '[ \t]*<%s[ ]?/>[ \t]*\r?\n', token ),...
                    '' );
            else
                prjContent = regexprep( prjContent,...
                    sprintf( '<%s>(.*)</%s>', token, token ),...
                    sprintf( '<%s>%s</%s>', token, value, token ) );
            end
            this.updateFileContent( prjContent );
        end
        
    end
    
end