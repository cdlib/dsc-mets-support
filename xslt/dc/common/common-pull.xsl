<?xml version="1.0"?>
<!--
modularizing
Element template <$element qualifier="$qualifier">; in a for-each loop of $node


-->

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xlink="http://www.w3.org/TR/xlink" 
	xmlns:m="http://www.loc.gov/METS/"
	xmlns:e="http://www.loc.gov/EAD/"
	xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/" 
	xmlns:dcterms="http://purl.org/dc/terms/" 
	xmlns:vc="http://www.cdlib.org/collections/"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	exclude-result-prefixes="#all"
	xmlns:dyn="http://exslt.org/dynamic"
>

<xsl:template match="/m:mets" mode="map">
<qdc>
<!--
     Title Creator Subject Description Publisher Contributor Date
     Type Format Identifier Source Language Relation Coverage Rights
-->
	<xsl:call-template name="title"/>
	<xsl:call-template name="creator"/>
	<xsl:call-template name="subject"/>
	<xsl:call-template name="description"/>
	<xsl:call-template name="publisher"/>
	<xsl:call-template name="contributor"/>
	<xsl:call-template name="date"/>
	<xsl:call-template name="type"/>
	<xsl:call-template name="format"/>
	<xsl:call-template name="identifier"/>
	<xsl:call-template name="source"/>
	<xsl:call-template name="language"/>
	<xsl:call-template name="relation"/>
	<xsl:call-template name="coverage"/>
	<xsl:call-template name="rights"/>
		<xsl:text><![CDATA[
]]></xsl:text>
</qdc>
</xsl:template>

<!-- named template to create the actual xml element
	params:
		element: literal element name; use one of DC for now
		qualifier: arbitrary qualifier; use dcterms if possible
			(qualifiers not in dcterms should be ignored
			 by default xslt; in-depth skin'n'slicers could write
			 custom XSLTs?)
		node:	This should be a select="xpath"; it will be for-each'ed through;
			and <apply-templates/> will be done for every node in the
			returned set/series.
-->
<xsl:template name="element">
<xsl:param name="element"/>
<xsl:param name="qualifier"/>
<xsl:param name="node"/>
<xsl:param name="prependString"/>
<xsl:param name="postpendString"/>
<!-- xsl:param name="mode" in the future? -->

<xsl:if test="$node">
	<xsl:for-each select="($node)[text()]">
		<!-- put in a line return -->
		<xsl:text><![CDATA[
]]></xsl:text>
		<xsl:element name="{$element}">
			<xsl:if test="($qualifier)">
				<xsl:attribute name="q">
					<xsl:value-of select="$qualifier"/>
				</xsl:attribute>	
			</xsl:if>
			<xsl:if test="($prependString)">
				<xsl:value-of select="$prependString"/>
			</xsl:if>
			<xsl:choose>
			   <xsl:when test="name()"> 
				<xsl:apply-templates select="."/>
			   </xsl:when> 
			   <xsl:otherwise> 
				<xsl:value-of select="."/> 
			   </xsl:otherwise> 
			</xsl:choose>
			<!-- xsl:copy-of select="."/ -->
			<xsl:if test="($postpendString)">
				<xsl:value-of select="$postpendString"/>
			</xsl:if>
		</xsl:element>
</xsl:for-each>
</xsl:if>
</xsl:template>

</xsl:stylesheet>
