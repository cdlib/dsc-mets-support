<?xml version="1.0"?>
<!--
MODS

-->

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:xlink="http://www.w3.org/1999/xlink" 
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

<!-- upgrade MODS2 to MODS3; normalize xlink namespace -->
<xsl:import href="common/upMods.xsl"/>

<!-- common-pull.xsl define template match for m:mets mode="map"
	plus defines the "element" named template -->
<xsl:import href="common/common-pull.xsl"/>

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
		<!-- /m:mets/@LABEL | (//mods:mods)[1]/mods:titleInfo"/ -->
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'title'"/>
                <xsl:with-param name="qualifier">alternative</xsl:with-param>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:titleInfo[position() &gt; 1]"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="creator">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'creator'"/>
                <xsl:with-param name="node" select="
			(//mods:mods)[1]/mods:name[1]
		"/>
		<!-- | 	(//mods:mods)[1]/mods:recordInfo/mods:recordContentSource -->
        </xsl:call-template>
</xsl:template>

<xsl:template match="mods:name">
	<xsl:apply-templates select="mods:namePart, mods:role"/>
</xsl:template>

<xsl:template match="mods:namePart">
        <xsl:value-of select="."/>
        <xsl:if test="following-sibling::mods:namePart"><xsl:text>, </xsl:text></xsl:if>
</xsl:template>

<xsl:template match="mods:role[mods:roleTerm]">
        <xsl:text>, </xsl:text>
        <xsl:choose>
        <xsl:when test="mods:roleTerm[@type='text']">
        <xsl:apply-templates select="mods:roleTerm[@type='text']" mode="relator"/>
        </xsl:when>
        <xsl:otherwise>
        <xsl:apply-templates select="mods:roleTerm[1]" mode="relator"/>
        </xsl:otherwise>
        </xsl:choose>
</xsl:template>

<!-- need to refactor relator code look up -->
<xsl:template match="mods:roleTerm" mode="relator">
        <xsl:choose>
                <!-- Correspondent [crp] -->
                <xsl:when test=".='crp'">Correspondent</xsl:when>
                <!-- Compiler [com] -->
                <xsl:when test=".='com'">Compiler</xsl:when>
                <xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
        </xsl:choose>
</xsl:template>


<xsl:template name="subject">
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="node" 
		select="
			(//mods:mods)[1]/mods:subject[mods:topic] |
			(//mods:mods)[1]/mods:subject[mods:titleInfo] |
			(//mods:mods)[1]/mods:subject[not(mods:*)][text()] |
			(//mods:mods)[1]/mods:subject[mods:name]
			"/>
<!--
-->
        </xsl:call-template>
	<xsl:variable name="parent.label" select="/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@LABEL"/>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@LABEL"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="(//mods:mods)[1]//mods:relatedItem/mods:titleInfo/mods:title[not(text() = $parent.label)]"/>
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
                <xsl:with-param name="node" select="(//mods:mods)[1]/mods:tableOfContents | (//mods:mods)[1]/mods:note | (//mods:mods)[1]/mods:subject/mods:name/mods:description"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">description</xsl:with-param>
                <xsl:with-param name="qualifier">abstract</xsl:with-param>
                <xsl:with-param name="node" select="(//mods:mods)[1]/mods:abstract"/>
        </xsl:call-template>
</xsl:template>

  <!-- mods:location>
      <mods:physicalLocation -->

<xsl:template name="publisher" 
	xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/">
	<xsl:call-template name="element">
                <xsl:with-param name="element">publisher</xsl:with-param>
                <xsl:with-param name="node" select="
	 /m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:title,
	  (//mods:mods)[1]/mods:location/mods:physicalLocation,
          (//mods:mods)[1]/mods:relatedItem[@type='original']/mods:location/mods:physicalLocation,
 	  (//mods:mods)[1]/mods:originInfo[mods:publisher or mods:place] 
"/>
	<!-- | (//mods:mods)[1]/mods:location/mods:physicalLocation -->
        </xsl:call-template>
</xsl:template>

<xsl:template match="mods:originInfo">
 <xsl:choose>
        <xsl:when test="mods:place/mods:placeTerm[@type='text'] and mods:publisher">
                <xsl:value-of select="mods:place/mods:placeTerm[@type='text']"/>
                <xsl:text> : </xsl:text>
                <xsl:value-of select="mods:publisher"/>
        </xsl:when>
        <xsl:when test="mods:publisher">
                <xsl:value-of select="mods:publisher"/>
        </xsl:when>
        <xsl:when test="not(mods:publisher) and mods:place/mods:placeTerm[@type='text']">
                <xsl:text>Published in: </xsl:text>
                <xsl:value-of select="mods:place/mods:placeTerm[@type='text']"/>
        </xsl:when>
        <xsl:otherwise/>
  </xsl:choose>
</xsl:template>


<xsl:template match="cdl:qualifieddc"
	xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/">
	<xsl:value-of select="dc:title"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="dc:identifier[starts-with(.,'http://')][1]"/>
</xsl:template>

<xsl:template name="contributor">
	<xsl:call-template name="element">
                <xsl:with-param name="element">contributor</xsl:with-param>
                <xsl:with-param name="node" select="(//mods:mods)[1]/mods:name"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="date">
	<xsl:call-template name="element">
                <xsl:with-param name="element">date</xsl:with-param>
                <xsl:with-param name="node" select="(//mods:mods)[1]/mods:originInfo/mods:dateIssued | (//mods:mods)[1]/mods:publicationInfo/mods:dateIssued | (//mods:mods)[1]/mods:originInfo/mods:dateCaptured | (//mods:mods)[1]/mods:originInfo/mods:dateOther"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">date</xsl:with-param>
                <xsl:with-param name="qualifier">created</xsl:with-param>
                <xsl:with-param name="node" select="(//mods:mods)[1]/mods:originInfo/mods:dateCreated"/>
        </xsl:call-template>
</xsl:template>

<xsl:template match="mods:dateIssued">
	<xsl:value-of select="."/>
        <xsl:text> (issued)</xsl:text>
</xsl:template>

<xsl:template match="mods:copyrightDate">
	<xsl:value-of select="."/>
        <xsl:text> (copyright)</xsl:text>
</xsl:template>


<xsl:template name="type">
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
		<xsl:with-param name="node" select="/m:mets/@TYPE[.!='generic']"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
                <xsl:with-param name="qualifier">mods</xsl:with-param>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:typeOfResource"/>
        </xsl:call-template>
	<xsl:call-template name="element">
                <xsl:with-param name="element">type</xsl:with-param>
                <xsl:with-param name="qualifier">genreform</xsl:with-param>
                <xsl:with-param name="node" select="(//mods:mods)[1]/mods:genre"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="format">
	<xsl:call-template name="element">
                <xsl:with-param name="element" select="'format'"/>
                <!-- xsl:with-param name="qualifier" select="'medium'"/ -->
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:physicalDescription/mods:extent | (//mods:mods)[1]/mods:physicalDescription/mods:form | (//mods:mods)[1]/mods:physicalDescription/mods:internetMediaType | (//mods:mods)[1]/mods:physicalDescription/mods:digitalOrigin | /mods:mods/mods:physicalDescription/mods:note"/>
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
		<xsl:with-param name="qualifier" select="'mods'"/>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:identifier"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'identifier'"/>
		<xsl:with-param name="qualifier" select="'mods'"/>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:relatedItem[@type='original']/mods:identifier[@type='local']"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="source">
</xsl:template>


<xsl:template name="language">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'language'"/>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:language"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="relation">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:relatedItem//mods:url | (//mods:mods)[1]/mods:relatedItem/mods:identifier | (//mods:mods)[1]/mods:extension/dc:relation | /m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@xlink:href | /m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/*/dc:identifier"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'relation'"/>
		<xsl:with-param name="qualifier" select="'vc'"/>
		<xsl:with-param name="node" select="vc:lookParent(/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='EAD']/m:xmlData/e:c/@parent | /m:mets/m:dmdSec[@ID='ead']/m:mdRef/@xlink:href | /m:mets/@OBJID)"/>
	</xsl:call-template>
	<xsl:if
          test="(/m:mets/@PROFILE != 'http://ark.cdlib.org/ark:/13030/kt5z09p6zn')">
          <xsl:call-template name="element">
                <xsl:with-param name="element" select="'relation'"/>
                <xsl:with-param name="node">http://calisphere.universityofcalifornia.edu/</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
	<!-- should match https as well ... -->
	<xsl:if test="substring-after(
			((//mods:mods)[1]/mods:location/mods:physicalLocation)[1], 
	'http://'
			)">
          <xsl:call-template name="element">
                <xsl:with-param name="element" select="'relation'"/>
                <xsl:with-param name="node">
		<xsl:text>http://</xsl:text>
		<xsl:value-of select="substring-after(normalize-space(((//mods:mods)[1]/mods:location/mods:physicalLocation)[1]),'http://')"/>
		</xsl:with-param>
          </xsl:call-template>
        </xsl:if>
</xsl:template>

<xsl:template name="coverage">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'coverage'"/>
		<xsl:with-param name="qualifier" select="'spatial'"/>
		<xsl:with-param name="node" 
			select="
		(//mods:mods)[1]/mods:subject[mods:geographic] | 
		(//mods:mods)[1]/mods:subject[mods:cartographic]  |
		(//mods:mods)[1]/mods:subject[mods:hierarchialGeographic]  |
		(//mods:mods)[1]/mods:subject[mods:geographicCode]  
		"/>
	</xsl:call-template>
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'coverage'"/>
		<xsl:with-param name="qualifier" select="'temporal'"/>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:subject[mods:temporal]"/>
	</xsl:call-template>
</xsl:template>

<xsl:template name="rights">
	<xsl:call-template name="element">
		<xsl:with-param name="element" select="'rights'"/>
		<xsl:with-param name="node" select="(//mods:mods)[1]/mods:accessCondition"/>
	</xsl:call-template>
</xsl:template>

</xsl:stylesheet>
