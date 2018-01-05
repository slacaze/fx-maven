classdef PomFile < fx.maven.internal.File
    
    properties( GetAccess = protected, Constant )
        ValidNames = 'pom[.]xml'
    end
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        ArtifactId(1,:) char
    end
    
    properties( GetAccess = private, SetAccess = private)
        ProjectNode(1,1)
    end
    
    methods
        
        function value = get.ArtifactId( this )
            artifactElements = this.ProjectNode.getElementsByTagName( 'artifactId' );
            elementIndex = ( 1:artifactElements.getLength() ) - 1;
            directChild = arrayfun( @(nodeIndex) artifactElements.item(nodeIndex).getParentNode() == this.ProjectNode, ...
                elementIndex );
            artifactIdIndex = elementIndex( directChild );
            assert( isscalar( artifactIdIndex ), ...
                'Maven:MissingArtifactId', ...
                'The artifactId is missing from "%s".', ...
                this.FilePath );
            value = char( artifactElements.item(artifactIdIndex).getTextContent() );
        end
        
    end
    
    methods( Access = public )
        
        function this = PomFile( path )
            this@fx.maven.internal.File( path );
            xmlDom = xmlread( path );
            this.ProjectNode = xmlDom.getDocumentElement();
        end
        
    end
    
end