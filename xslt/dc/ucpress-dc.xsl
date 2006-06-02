<?xml version="1.0"?>
<!--
MODS + filemaker from ucpress

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
	xmlns:fm="http://www.cdlib.org/schemas/xmldata"
	exclude-result-prefixes="#all"
>

<xsl:import href="mods-dc.xsl"/>

<xsl:import href="common/common-pull.xsl"/>

<xsl:output method="xml" />

<xsl:template match="/">
        <xsl:apply-imports />
</xsl:template>

<xsl:template name="title">
        <xsl:call-template name="element">
                <xsl:with-param name="element">title</xsl:with-param>
                <xsl:with-param name="node">
			<xsl:value-of select="/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:UCPnum.TitleMain/fm:DATA"/>
			<xsl:if test="/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:UCPnum.TitleSub/fm:DATA[text()]">
			<xsl:text>: </xsl:text>
				<xsl:value-of select="/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:UCPnum.TitleSub/fm:DATA"/>
			</xsl:if>
		</xsl:with-param>
        </xsl:call-template>
</xsl:template>

<xsl:template name="subject">
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="node"
                select="
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs1[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs2[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs3[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs4[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs5[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs6[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs7[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs8[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs9[text()] |
	/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:SubDescs10[text()] 
			"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">lcsh</xsl:with-param>
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
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@LABEL"/>
        </xsl:call-template>
        <xsl:call-template name="element">
                <xsl:with-param name="element">subject</xsl:with-param>
                <xsl:with-param name="qualifier">series</xsl:with-param>
                <xsl:with-param name="node" select="(//mods:mods)[1]//mods:relatedItem/mods:titleInfo/mods:title"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="creator">
        <xsl:call-template name="element">
                <xsl:with-param name="element">creator</xsl:with-param>
                <xsl:with-param name="node" 	
			select="/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:UCPnum.AUTHOR_CITATION_FWD/fm:DATA"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="description">
        <xsl:call-template name="element">
                <xsl:with-param name="element">description</xsl:with-param>
                <xsl:with-param name="node" 	
			select="/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:UCPnum.Copy/fm:DATA"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="date">
        <xsl:call-template name="element">
                <xsl:with-param name="element">date</xsl:with-param>
                <xsl:with-param name="node" 	
			select="/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:UCPnum.Pub_Date/fm:DATA"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="rights">
        <xsl:call-template name="element">
                <xsl:with-param name="element">rights</xsl:with-param>
                <xsl:with-param name="node" 	
			select="/m:mets/m:dmdSec[@ID='ucpress']/m:mdWrap/m:xmlData/fm:ROW/fm:public_nonPublic"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="relation">
        <xsl:call-template name="element">
                <xsl:with-param name="element" select="'relation'"/>
                <xsl:with-param name="node" select="(//mods:mods)[1]/mods:relatedItem//mods:url | (//mods:mods)[1]/mods:relatedItem/mods:identifier | (//mods:mods)[1]/mods:extension/dc:relation | /m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@xlink:href | /m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/*/dc:identifier"/>
        </xsl:call-template>
</xsl:template>

<xsl:template name="publisher"
        xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/">
        <xsl:call-template name="element">
                <xsl:with-param name="element">publisher</xsl:with-param>
                <xsl:with-param name="node" select="
          (//mods:mods)[1]/mods:originInfo/mods:publisher
        | (//mods:mods)[1]/mods:publicationInfo/mods:publisher
        | /m:mets/m:dmdSec[@ID='repo']/m:mdWrap/m:xmlData/cdl:qualifieddc"/>
        <!-- | (//mods:mods)[1]/mods:location/mods:physicalLocation -->
        </xsl:call-template>
</xsl:template>

</xsl:stylesheet>
