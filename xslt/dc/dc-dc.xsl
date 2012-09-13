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
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:creator | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:creator | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:creator"/>

        </xsl:call-template>
</xsl:template>

<xsl:template name="subject">
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:subject | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:subject | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:subject"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@LABEL"/>
        </xsl:call-template>
</xsl:template>
	
<xsl:template name="description">
	<xsl:call-template name="element">
                <xsl:with-param name="element">description</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:description | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:description | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:description "/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="publisher">
	<xsl:call-template name="element">
                <xsl:with-param name="element">publisher</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:publisher | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:publisher | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:publisher"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="contributor">
	<xsl:call-template name="element">
		<xsl:with-param name="element">contributor</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:contributor | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:contributor | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:contributor"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="date">
	<xsl:call-template name="element">
       <xsl:with-param name="element">date</xsl:with-param>
       <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:date | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:date| /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:date"/>
    </xsl:call-template>
	<xsl:call-template name="element">
       <xsl:with-param name="element">date</xsl:with-param>
       <xsl:with-param name="qualifier">dcterms:created</xsl:with-param>
       <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dcterms:created | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dcterms:created | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dcterms:created"/>
    </xsl:call-template>
	<xsl:call-template name="element">
       <xsl:with-param name="element">date</xsl:with-param>
       <xsl:with-param name="qualifier">dcterms:issued</xsl:with-param>
       <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dcterms:issued | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dcterms:issued | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dcterms:issued"/>
    </xsl:call-template>
	<xsl:call-template name="element">
       <xsl:with-param name="element">date</xsl:with-param>
       <xsl:with-param name="qualifier">dcterms:copyrighted</xsl:with-param>
       <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dcterms:copyrighted | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dcterms:copyrighted | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dcterms:copyrighted"/>
    </xsl:call-template>
	<xsl:call-template name="element">
        <xsl:with-param name="element">date</xsl:with-param>
        <xsl:with-param name="qualifier">dcterms:dateCopyrighted</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dcterms:dateCopyrighted | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dcterms:dateCopyrighted | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dcterms:dateCopyrighted"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="type">
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/@TYPE"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
                <xsl:with-param name="qualifier">dc</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:type | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:type | 
/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:type"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="format">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'format'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:format | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:format"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="identifier">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'identifier'"/>
		<xsl:with-param name="prependString" select="'http://ark.cdlib.org/'"/>
		<xsl:with-param name="node" select="/m:mets/@OBJID"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'identifier'"/>
		<xsl:with-param name="qualifier" select="'local'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:identifier | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:identifier | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:identifier"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="source">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'source'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:source | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:source | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:source"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="language">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'language'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:language | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:language | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:language"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="relation">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:relation | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:relation | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:relation"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'ispartof'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='ead']/m:mdRef/@*[local-name(.)='href'] | /m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:identifier | /m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dcterms:isPartOf | /m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/dc:identifier | /m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@*:href"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'vc'"/>
		<xsl:with-param name="node" select="vc:lookParent(/m:mets/m:dmdSec[@ID='ead']/m:mdRef/@*[local-name(.)='href'])"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="node">http://oac.cdlib.org/</xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="node">http://calisphere.universityofcalifornia.edu/</xsl:with-param>
	</xsl:call-template>
</xsl:template>

<xsl:template name="coverage">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'coverage'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:coverage | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:coverage | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:coverage"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="rights">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:rights | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dc:rights | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:rights"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="qualifier" select="'dcterms:rightsHolder'"/>
       <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dcterms:rightsHolder | /m:mets/m:dmdSec[@ID='DC']/m:mdWrap/m:xmlData/dcterms:rightsHolder | /m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dcterms:rightsHolder"/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
