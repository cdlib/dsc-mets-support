<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xlink="http://www.w3.org/TR/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:m="http://www.loc.gov/METS/" xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
        xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/">
        
<!-- turn 'qdc2' xml into 'qdc' xml -->

    <xsl:template match="/">
        <qdc>
            <xsl:for-each select="//dc:*">
                <xsl:call-template name="setele">
                    <xsl:with-param name="name" select="local-name()"/>
                    <xsl:with-param name="prefix" select="''"/>
                    <xsl:with-param name="value" select="."/>                
                </xsl:call-template>
            </xsl:for-each>
            
            <xsl:for-each select="//cdl:*">
                <xsl:if test="not(local-name() = 'qualifieddc')">
                    <xsl:call-template name="setele">
                        <xsl:with-param name="name" select="local-name()"/>
                        <xsl:with-param name="prefix" select="'cdl.'"/>
                        <xsl:with-param name="value" select="."/>                
                    </xsl:call-template>
                </xsl:if>
            </xsl:for-each>
        </qdc>
    </xsl:template>
            
            <xsl:template name="setele">
                <xsl:param name="name"/>
                <xsl:param name="prefix"/>
                <xsl:param name="value"/>
                <xsl:variable name="newname" select="concat($prefix,$name)"/>
                <xsl:element name="{$newname}">
                    <xsl:value-of select="$value"/>
                </xsl:element>
             </xsl:template>
</xsl:stylesheet>

