<?xml version="1.0"?>
<!--
EAD to Dublin Core translation: CMS migration to XTF
supports profiles for EAD Collections and EAD Extracted Components w/ dao*s
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
>

<!-- collections.[.xslt|.xml] define an xmlns:vc="http://www.cdlib.org/collections/" vc:lookParent function
	and store the data to return "relation" values to enhance the
	indexing record with --> 
<xsl:import href="common/collections.xslt"/>

<!-- common-pull.xsl define template match for m:mets mode="map"
	plus defines the "element" named template -->
<xsl:import href="common/common-pull.xsl"/>

<xsl:output method="xml" />

<xsl:template match="/">
	<xsl:apply-templates mode="map"/>
</xsl:template>

<xsl:template name="title">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'title'"/>
		<xsl:with-param name="node" select="/m:mets/@LABEL"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="creator">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'creator'"/>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c/e:did//e:origination"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="subject">
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c//e:subject"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c//e:series/e:unittitle"/>
        </xsl:call-template>
</xsl:template>
	
<xsl:template name="description">
	<xsl:call-template name="element">
                <xsl:with-param name="element">description</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c//e:abstract"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="publisher">
	<xsl:call-template name="element">
                <xsl:with-param name="element">publisher</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:title"/>
        </xsl:call-template>
	<xsl:for-each
select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c//e:custodhist">
	<xsl:call-template name="element">
                <xsl:with-param name="element">publisher</xsl:with-param>
                <xsl:with-param name="qualifier">custodhist</xsl:with-param>
                <xsl:with-param name="node" select="."/>
        </xsl:call-template>
        </xsl:for-each>
</xsl:template>

<xsl:template name="contributor">
</xsl:template>

<xsl:template name="date">
<xsl:for-each
select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c/e:did/e:unitdate">
	<xsl:call-template name="element">
                <xsl:with-param name="element">date</xsl:with-param>
                <xsl:with-param name="node" select="."/>
        </xsl:call-template>
</xsl:for-each>
</xsl:template>

<xsl:template name="type">
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/@TYPE"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
                <xsl:with-param name="qualifier">genreform</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c/e:did/e:physdesc/e:genreform"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="format">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'format'"/>
                <xsl:with-param name="qualifier" select="'medium'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c/e:did/e:physdesc"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="identifier">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'identifier'"/>
		<xsl:with-param name="node" select="/m:mets/@OBJID"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="source">
</xsl:template>

<xsl:template name="language">
</xsl:template>

<xsl:template name="relation">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'ispartof'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c/@parent | /m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:identifier "/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'vc'"/>
		<xsl:with-param name="node" select="vc:lookParent(/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c/@parent)"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="coverage">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'coverage'"/>
		<xsl:with-param name="qualifier" select="'spatial'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c//e:geogname"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="rights">
</xsl:template>

</xsl:stylesheet>
