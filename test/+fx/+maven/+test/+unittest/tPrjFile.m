classdef tPrjFile < fx.maven.test.WithCleanWorkingDirectory
    
    properties
        FilePath = 'prjfile.prj'
    end
    
    properties( TestParameter )
        PropertyName = {...
            'Name',...
            'Author',...
            'Email',...
            'Company',...
            'Summary',...
            'Description',...
            }
        Token = {...
            'param.appname',...
            'param.authnamewatermark',...
            'param.email',...
            'param.company',...
            'param.summary',...
            'param.description',...
            }
    end
    
    methods( TestMethodSetup )
        
        function addPrjFile( this )
            copyfile( ...
                fullfile( maventestroot, 'Sample', 'prjfile.prj' ), ...
                fullfile( this.Root, this.FilePath ) );
        end
        
    end
    
    methods( Test, ParameterCombination = 'sequential' )
        
        function testCheckTokenUpdate( this, PropertyName, Token )
            prjFile = fx.maven.PrjFile( this.FilePath );
            this.verifyEqual( prjFile.(PropertyName), '' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s[ ]?/>', Token ) ), 2 );
            prjFile.(PropertyName) = 'SomeValue';
            this.verifyEqual( prjFile.(PropertyName), 'SomeValue' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s[ ]?/>', Token ) ), 0 );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s>%s</%s>', Token, 'SomeValue', Token ) ), 1 );
            prjFile.(PropertyName) = 'Some Other Value';
            this.verifyEqual( prjFile.(PropertyName), 'Some Other Value' );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s[ ]?/>', Token ) ), 0 );
            this.verifyNumElements( regexp( fileread( this.FilePath ), sprintf( '<%s>%s</%s>', Token, 'Some Other Value', Token ) ), 1 );
        end
        
    end
    
    methods( Access = private )
        
        function setProp( ~, prjFile, propName, propValue )
            prjFile.(propName) = propValue;
        end
        
    end
    
end