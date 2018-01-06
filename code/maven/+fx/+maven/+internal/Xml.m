classdef Xml < handle
    
    properties( GetAccess = public, SetAccess = private, Dependent )
        TagName
    end
    
    properties( GetAccess = public, SetAccess = public, Dependent )
        Text
    end
    
    properties( GetAccess = private, SetAccess = private )
        RootNode(1,1)
    end
    
    methods
        
        function value = get.TagName( this )
            value = char( this.RootNode.getTagName() );
        end
        
        function set.Text( this, value )
            this.RootNode.setTextContent( value );
        end
        
        function value = get.Text( this )
            value = char( this.RootNode.getTextContent() );
        end
        
    end
    
    methods( Access = public )
        
        function this = Xml( rootNode )
            if nargin > 0
                this.RootNode = rootNode;
            end
        end
        
    end
    
    methods( Access = public )
        
        function elements = getElementsByTagName( this, tagName, recursive )
            if nargin < 3
                recursive = true;
            end
            rawElements = this.RootNode.getElementsByTagName( tagName );
            elementIndex = ( 1:rawElements.getLength() ) - 1;
            if ~recursive
                directChild = arrayfun( @(nodeIndex) rawElements.item(nodeIndex).getParentNode() == this.RootNode, ...
                    elementIndex );
                elementIndex = elementIndex( directChild );
            end
            elements = fx.maven.internal.Xml.empty;
            position = 1;
            for index = elementIndex
                elements(position) = fx.maven.internal.Xml( rawElements.item(index) );
                position = position + 1;
            end
        end
        
        function toFile( this, filePath )
            xmlwrite( filePath, this.RootNode );
        end
        
        function elements = children( this )
            childNodes = this.RootNode.getChildNodes();
            elements = fx.maven.internal.Xml.empty;
            for childIndex = 0:( childNodes.getLength() - 1 )
                childNode = childNodes.item( childIndex );
                if childNode.getNodeType() == org.w3c.dom.Node.ELEMENT_NODE
                    elements(end+1) = fx.maven.internal.Xml( childNode ); %#ok<AGROW>
                end
            end
        end
        
    end
    
end