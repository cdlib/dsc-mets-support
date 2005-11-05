<?xml version="1.0"?>
<!--
MODS

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
	xmlns:mods="http://www.loc.gov/mods/v3" 
	exclude-result-prefixes="#all"
>

<!-- collections.[.xslt|.xml] define an xmlns:vc="http://www.cdlib.org/collections/" vc:lookParent function
	and store the data to return "relation" values to enhance the
	indexing record with -->
<xsl:import href="common/collections.xslt"/>

<!-- common-pull.xsl define template match for m:mets mode="map"
	plus defines the "element" named template -->
<xsl:import href="common/common-pull.xsl"/>

<!-- upgrade MODS2 to MODS3; normalize xlink namespace -->
<xsl:import href="common/upMods.xsl"/>

<xsl:output method="xml" />


<xsl:variable name="unfiltered">
        <xsl:apply-templates mode="upMods"/>
</xsl:variable>


<xsl:template match="/">
	<xsl:apply-templates select="$unfiltered" mode="map"/>
</xsl:template>

<xsl:template name="title">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'title'"/>
		<xsl:with-param name="node" select="/m:mets/@LABEL"/>
		<!-- /m:mets/@LABEL | //mods:mods/mods:titleInfo"/ -->
	</xsl:call-template>
</xsl:template>

<xsl:template name="creator">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'creator'"/>
                <xsl:with-param name="node" select="
			//mods:mods/mods:name[./mods:role/mods:roleTerm='creator']/mods:namePart[1]
		"/>
		<!-- | 	//mods:mods/mods:recordInfo/mods:recordContentSource -->
        </xsl:call-template>
</xsl:template>

<xsl:template match="mods:name[./mods:role/mods:roleTerm]">
	<xsl:value-of select="mods:namePart"/>
</xsl:template>

<xsl:template name="subject">
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:subject"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@LABEL"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets//mods:mods//mods:relatedItem/mods:titleInfo/mods:title"/>
        </xsl:call-template>
</xsl:template>

<xsl:template match="mods:subject">
	<xsl:apply-templates select="mods:*" mode="subject"/>
</xsl:template>
	
<xsl:template match="mods:*" mode="subject">
	<xsl:apply-templates mode="subject"/>
	<xsl:if test="following-sibling::*[1]"> -- </xsl:if>
</xsl:template>
	
<xsl:template name="description">
	<xsl:call-template name="element">
                <xsl:with-param name="element">description</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:abstract | //mods:mods/mods:tableOfContents | //mods:mods/mods:note | //mods:mods/mods:subject/mods:name/mods:description"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">description</xsl:with-param>
                <xsl:with-param name="qualifier">abstract</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:abstract"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="publisher">
	<xsl:call-template name="element">
                <xsl:with-param name="element">publisher</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:originInfo/mods:publisher | //mods:mods/mods:publicationInfo/mods:publisher"/>
	<!-- | //mods:mods/mods:location/mods:physicalLocation -->
        </xsl:call-template>
</xsl:template>

<xsl:template name="contributor">
	<xsl:call-template name="element">
                <xsl:with-param name="element">contributor</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:name[./mods:role/mods:roleTerm='contributor']/mods:namePart[1]"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="date">
	<xsl:call-template name="element">
                <xsl:with-param name="element">date</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:originInfo/mods:dateIssued | //mods:mods/mods:publicationInfo/mods:dateIssued | //mods:mods/mods:originInfo/mods:dateCaptured | //mods:mods/mods:originInfo/mods:dateOther"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">date</xsl:with-param>
                <xsl:with-param name="qualifier">created</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:recordInfo/mods:recordCreationDate | //mods:mods/mods:originInfo/mods:dateCreated |//mods:mods/mods:recordInfo/mods:recordChangeDate"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="type">
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/@TYPE"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
                <xsl:with-param name="qualifier">mods</xsl:with-param>
		<xsl:with-param name="node" select="//mods:mods/mods:typeOfResource"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
                <xsl:with-param name="qualifier">genreform</xsl:with-param>
                <xsl:with-param name="node" select="//mods:mods/mods:genre"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="format">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'format'"/>
                <xsl:with-param name="qualifier" select="'medium'"/>
		<xsl:with-param name="node" select="//mods:mods/mods:physicalDescription/mods:extent | //mods:mods/mods:physicalDescription/mods:form | //mods:mods/mods:physicalDescription/mods:internetMediaType | //mods:mods/mods:physicalDescription/mods:digitalOrigin | /mods:mods/mods:physicalDescription/mods:note"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="identifier">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'identifier'"/>
		<xsl:with-param name="node" select="/m:mets/@OBJID | //mods:mods/mods:identifier"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="source">
</xsl:template>


<xsl:template name="language">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'language'"/>
		<xsl:with-param name="node" select="//mods:mods/mods:language"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="relation">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'ispartof'"/>
		<xsl:with-param name="node" select="//mods:mods/mods:relatedItem//mods:url | //mods:mods/mods:relatedItem/mods:identifier"/>
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
		<xsl:with-param name="node" select="//mods:mods/mods:subject/mods:geographic | //mods:mods/mods:subject/mods:cartographic"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="rights">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="node" select="//mods:mods/mods:accessCondition"/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
