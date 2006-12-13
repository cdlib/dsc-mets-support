<!-- this stylesheet is a copy of David Loy's OCA-DC.qdc.xslt but does only admin-dc extraction -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:xlink="http://www.w3.org/TR/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
        xmlns:m="http://www.loc.gov/METS/" xmlns:cdl="http://schemas.cdlib.org/admin-dc/" >

    <!--xsl:template match="/">
        <qdc>
            <xsl:for-each select="//cdl:*">
                <xsl:call-template name="setele">
                    <xsl:with-param name="name" select="local-name()"/>
                    <xsl:with-param name="prefix" select="'cdl.'"/>
                    <xsl:with-param name="value" select="."/>                
                </xsl:call-template>
            </xsl:for-each>
        </qdc>
    </xsl:template-->

    <xsl:template name="cdl-qdc">
<![CDATA[
]]>
            <xsl:for-each select="//cdl:qualifieddc/*">
                <xsl:call-template name="setele">
                    <xsl:with-param name="name" select="local-name()"/>
                    <xsl:with-param name="prefix" select="'cdl.'"/>
                    <xsl:with-param name="value" select="."/>                
                </xsl:call-template>
            </xsl:for-each>
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

