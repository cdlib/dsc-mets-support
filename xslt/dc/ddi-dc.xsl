<?xml version="1.0"?>
<!--
DDI to Dublin Core translation: CMS migration to XTF
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
xmlns:n1="http://www.loc.gov/METS/"
xmlns:n2="http://www.icpsr.umich.edu/DDI"
xmlns:n3="http://countingcalifornia.cdlib.org/mudd.service"
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
		<xsl:with-param name="node" select="/m:mets/n1:dmdSec[@ID='datadictionary-tbl']/n1:mdWrap/n1:xmlData/n3:tbl/n3:labl"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="creator">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'creator'"/>
                <xsl:with-param name="node" select="/m:mets/n1:dmdSec[@ID='DDI1-2']/n1:mdWrap/n1:xmlData/n2:codeBook/n2:stdyDscr/n2:citation/n2:prodStmt/n2:producer"/>

        </xsl:call-template>
</xsl:template>

<xsl:template name="subject">
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">concept</xsl:with-param>
                <xsl:with-param name="node" select="/n1:mets/n1:dmdSec[@ID='datadictionary-tbl']/n1:mdWrap/n1:xmlData/n3:tbl/n3:concept"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='ead']/m:mdRef/@LABEL"/>
        </xsl:call-template>
</xsl:template>
	
<xsl:template name="description">
	<xsl:call-template name="element">
                <xsl:with-param name="element">description</xsl:with-param>
                <xsl:with-param name="node">
			<xsl:value-of select="n1:dmdSec[@ID='datadictionary-tbl']/n1:mdWrap/n1:xmlData/n3:tbl/n3:hdg"/>
		</xsl:with-param>
		<xsl:with-param name="prependString">
			<xsl:text>TABLE HEADERS - </xsl:text>
		</xsl:with-param>
        </xsl:call-template>
</xsl:template>

<xsl:template name="publisher">
	<xsl:call-template name="element">
                <xsl:with-param name="element">publisher</xsl:with-param>
                <xsl:with-param name="node">
			<xsl:text>California Digital Library</xsl:text>
		</xsl:with-param>
        </xsl:call-template>
</xsl:template>

<xsl:template name="contributor">
	<xsl:call-template name="element">
		<xsl:with-param name="element">contributor</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:contributor"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="date">
	<xsl:call-template name="element">
                <xsl:with-param name="element">date</xsl:with-param>
                <xsl:with-param name="node" select="n1:dmdSec[@ID='DDI1-2']/n1:mdWrap/n1:xmlData/n2:codeBook/n2:stdyDscr/n2:stdyInfo/n2:sumDscr/n2:timePrd"/>
        </xsl:call-template>
</xsl:template>

<xsl:template match="n2:timePrd">
<xsl:choose>
	<xsl:when test="@event='start'">
		<xsl:choose>
			<xsl:when test="@date"><xsl:value-of select="@date"/></xsl:when>
			<xsl:otherwise> <xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:when>
	<xsl:when test="@event='end'">
		to
		<xsl:choose>
			<xsl:when test="@date"><xsl:value-of select="@date"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:when>
	<xsl:when test='@event="single"'>
		<xsl:choose>
			<xsl:when test="@date"><xsl:value-of select="@date"/></xsl:when>
			<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
		</xsl:choose>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="."/>
	</xsl:otherwise>
</xsl:choose>   
</xsl:template>

<xsl:template name="type">
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/@TYPE"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
                <xsl:with-param name="qualifier">dc</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:type"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="format">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'format'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:format"/>
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
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:identifier"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="source">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'source'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:source"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="language">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'language'"/>
		<xsl:with-param name="node" select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:language"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="relation">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'ispartof'"/>
		<xsl:with-param name="node" select="/n1:mets/n1:metsHdr/n1:altRecordID[@TYPE='CDLstudy']"/>
		<xsl:with-param name="prependString">http://countingcalifornia.cdlib.org/title/</xsl:with-param>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'ispartof'"/>
		<xsl:with-param name="node" select="/m:mets/n1:dmdSec[@ID='datadictionary-tbl']/n1:mdWrap/n1:xmlData/n3:tbl/@id"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="coverage">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'coverage'"/>
		<xsl:with-param name="qualifier" select="'spatial'"/>
		<xsl:with-param name="node" select="n1:dmdSec[@ID='DDI1-2']/n1:mdWrap/n1:xmlData/n2:codeBook/n2:stdyDscr/n2:stdyInfo/n2:sumDscr/n2:geogUnit"/>
	</xsl:call-template>

	<!-- xsl:call-template name="element">
		<xsl:with-param name="element" select="'coverage'"/>
		<xsl:with-param name="qualifier" select="'temporal'"/>
		<xsl:with-param name="node" select=""/>
	</xsl:call-template -->
</xsl:template>

<xsl:template name="rights">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="node" select="/n1:mets/n1:amdSec/n1:rightsMD[@ID='access_restriction']/n1:mdWrap/n1:xmlData/n1:access"/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
