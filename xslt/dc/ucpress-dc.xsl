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

<xsl:output method="xml" />

<xsl:template name="title">
<Title><v><xsl:value-of select="dmdSec[@ID='ucpress']/mdWrap/xmlData/ROW/UCPnum.TitleMain"/><xsl:if test="dmdSec[@ID='ucpress']/mdWrap/xmlData/ROW/UCPnum.TitleSub">: <xsl:value-of select="dmdSec[@ID='ucpress']/mdWrap/xmlData/ROW/UCPnum.TitleSub"/></xsl:if></v></Title>
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
<Creator>
<v><xsl:value-of select="dmdSec[@ID='ucpress']/mdWrap/xmlData/ROW/UCPnum.AUTHOR_CITATION_FWD"/></v></Creator>
</xsl:template>

<xsl:template name="description">
<Description><v><xsl:apply-templates select="dmdSec[@ID='ucpress']/mdWrap/xmlData/ROW/UCPnum.Copy"/></v></Description>
</xsl:template>

<xsl:template name="date">
<Date><v><xsl:value-of select="dmdSec[@ID='ucpress']/mdWrap/xmlData/ROW/UCPnum.Pub_Date"/></v>
</Date>
</xsl:template>

<xsl:template name="rights">
<Rights><v><xsl:value-of select="amdSec/rightsMD[@ID='access_restriction']/mdWrap/xmlData/access"/></v>
</Rights>
</xsl:template>


</xsl:stylesheet>
