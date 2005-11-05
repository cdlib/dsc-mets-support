<?xml version="1.0"?>
<!--
change old xlink namespace to new xlink namespace
-->

<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:mets="http://www.loc.gov/METS/"
>

<xsl:template match="/">
	<xsl:apply-templates mode="upMets"/>
</xsl:template>

<xsl:template match="mets:*/@*[namespace-uri(.)='http://www.w3.org/TR/xlink']" mode="upMets">
	<xsl:attribute name="{name()}" namespace="http://www.w3.org/1999/xlink">
	<xsl:value-of select="."/>
        </xsl:attribute>
</xsl:template>

<xsl:template match='*|@*' mode="upMets">
        <xsl:copy>
                <xsl:apply-templates select='@*|node()' mode="upMets"/>
        </xsl:copy>
</xsl:template>

</xsl:stylesheet>
