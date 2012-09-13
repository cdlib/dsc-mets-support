<?xml version="1.0"?>
<!--
Dublic Core to Dublin Core translation: CMS migration to XTF
supports profiles that are based on DC, including LSTA images and OAC TEXT DC
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
	xmlns:xs="http://www.w3.org/2001/XMLSchema"
	exclude-result-prefixes="#all"
>

<!-- xmlns:xdt="http://www.w3.org/2005/xpath-datatypes" -->

<!-- collections.[.xslt|.xml] define an xmlns:vc="http://www.cdlib.org/collections/" vc:lookParent function
	and store the data to return "relation" values to enhance the
	indexing record with --> 
<xsl:import href="common/collections.xslt"/>

<!-- common-pull.xsl define template match for m:mets mode="map"
	plus defines the "element" named template -->

<xsl:import href="dc-dc.xsl"/>

<xsl:import href="common/common-pull.xsl"/>

<xsl:output method="xml" />

<xsl:template match="/">
	<xsl:apply-templates mode="map"/>
</xsl:template>

	
<xsl:template name="rights">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:rights | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:rights[text()]"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="node" 
			select="/m:mets/m:amdSec/m:rightsMD/m:mdWrap[@MDTYPE='OTHER'][@OTHERMDTYPE='METSRights']/m:xmlData/*:RightsDeclarationMD/*:Context/*:Constraints/*:ConstraintDescription"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="qualifier" select="'dcterms:rightsHolder'"/>
       <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dcterms:rightsHolder | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dcterms:rightsHolder | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dcterms:rightsHolder"/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
