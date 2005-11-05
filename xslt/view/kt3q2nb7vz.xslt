<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:n2="http://www.loc.gov/EAD/"
		xmlns:dcterms="http://purl.org/dc/terms/" 
		xmlns:dc="http://purl.org/dc/elements/1.1/"
                version="1.0"
                exclude-result-prefixes="xlink mets xsl cdl dc dcterms">
<xsl:import href="brandCommon.xsl"/>
  <xsl:output method="html"/>

  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <xsl:variable name="page" select="/"/>
  <xsl:variable name="layout" select="document('imageDisplayStructure.xml')"/>
<xsl:param name="brand" select="'oac'"/>
  <xsl:template match="/">
    <xsl:apply-templates select="$layout/html"/>
  </xsl:template>

 <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="insert-brand-links">
 <xsl:copy-of select="$brand.links"/>
</xsl:template>

<xsl:template match="insert-brand-head">
 <xsl:copy-of select="$brand.header"/>
</xsl:template>

<xsl:template match="insert-brand-footer">
 <xsl:copy-of select="$brand.footer"/>
</xsl:template>




  <xsl:template match="insert-head-title">
    <title>OAC: <xsl:value-of select="$page/mets:mets/@LABEL"/></title>
  </xsl:template>

  <xsl:template match="insert-breadcrumb">
    <a href="http://findaid.oac.cdlib.org/search.image.html">Images</a>&#160;&#160;&gt;&#160; 
    <a>
      <xsl:attribute name="href">
      <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='ead']/mets:mdRef/@xlink:href"/>
      </xsl:attribute>
      <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='ead']/mets:mdRef/@LABEL"/>
    </a>
  </xsl:template>

  <xsl:template match="insert-pagetitle">
    <xsl:value-of select="$page/mets:mets/@LABEL"/>
  </xsl:template>

<!-- insert-imagePortion refactoring start --> 

<xsl:template match="insert-imagePortion">
	<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="structMap"/>
</xsl:template>

<xsl:template match="m:structMap" mode="structMap">
	<xsl:apply-templates select="m:div" mode="structMapImage"/>
</xsl:template>

    
<xsl:template match="m:div" mode="structMapImage">
	<xsl:variable name="link">
<xsl:text>/</xsl:text><xsl:value-of select="$page/m:mets/@OBJID"/><xsl:text>/</xsl:text>
	   <xsl:choose>
		<xsl:when test="m:div/m:fptr[@FILEID='med-res']">med-res</xsl:when>
		<xsl:when test="m:div/m:fptr[@FILEID='hi-res']">hi-res</xsl:when>
		<xsl:otherwise/>
	   </xsl:choose>
	</xsl:variable>
	<xsl:if test="m:div/m:fptr[@FILEID='thumbnail']">
<a href="{$link}"><img src="/{$page/m:mets/@OBJID}/thumbnail" border="0" alt="Thumbnail image"/></a>
	</xsl:if>
 	<p><span class="listingTitle">View Options:</span><br/>
	<xsl:apply-templates select="m:div[m:fptr/@FILEID !='thumbnail']" mode="structMapLink"/>
	</p>
</xsl:template>
    
<xsl:template match="m:div" mode="structMapLink">
<a href="/{$page/m:mets/@OBJID}/{./m:fptr/@FILEID}"><xsl:apply-templates select="@LABEL" mode="cleanup"/></a><br/>
</xsl:template>

<xsl:template match="@LABEL" mode="cleanup">
   <xsl:choose>
	<xsl:when test=".='med-res'">Medium Image</xsl:when>
	<xsl:when test=".='hi-res'">Large Image</xsl:when>
	<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
   </xsl:choose>
</xsl:template>

    
  <xsl:template match="insert-imagePortion-fogel">
    <xsl:choose>
      <xsl:when test="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE]">
        <xsl:for-each select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file/mets:FLocat[@xlink:role='thumbnail']">
          <xsl:variable name="imageGroup">
            <xsl:value-of select="parent::mets:file/@GROUPID"/>
          </xsl:variable>
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']">
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='hi-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <img>
              <xsl:attribute name="src">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="parent::mets:file/@ID"/>
              </xsl:attribute>
              <xsl:attribute name="alt">
                <xsl:text>Thumbnail Image: </xsl:text>
                <xsl:value-of select="$page/mets:mets/@LABEL"/>
              </xsl:attribute>
              <xsl:attribute name="border">
                <xsl:text>0</xsl:text>
              </xsl:attribute>
            </img>
          </a>
          <p>
            <span class="listingTitle">View Options:</span><br/>
            <xsl:if test="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']">
              <a class="listing">
                <xsl:attribute name="href">
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
                </xsl:attribute>
                <xsl:text>Medium Image</xsl:text>
              </a>
              <br/>
            </xsl:if>
            <a class="listing">
              <xsl:attribute name="href">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='hi-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
              </xsl:attribute>
              <xsl:text>Large Image</xsl:text>
            </a></p>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']">
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']/@ID"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='hi-res']/@ID"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <img>
              <xsl:attribute name="src">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='thumbnail']/@ID"/>
              </xsl:attribute>
              <xsl:attribute name="border">
                <xsl:text>0</xsl:text>
              </xsl:attribute>
            </img>
          </a>
          <p>
            <span class="listingTitle">View Options:</span><br/>
            <xsl:if test="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']">
              <a class="listing">
                <xsl:attribute name="href">
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']/@ID"/>
                </xsl:attribute>
                <xsl:text>Medium Image</xsl:text>
              </a>
              <br/>
          </xsl:if>
            <a class="listing">
              <xsl:attribute name="href">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='hi-res']/@ID"/>
              </xsl:attribute>
              <xsl:text>Large Image</xsl:text>
            </a></p>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!-- insert-imagePortion refactoring end --> 

  <xsl:template match="insert-metadataPortion">
<xsl:apply-templates select="$page/mets:mets/mets:dmdSec/mets:mdWrap[@MDTYPE='EAD']/mets:xmlData/n2:c"/>
  </xsl:template> 

<xsl:template match='n2:*'>
        <p><xsl:apply-templates/></p>
</xsl:template>


<xsl:template match="n2:series">
<!-- <xsl:apply-templates select="n2:unittitle[@from!='archdesc']" mode="h"/>
-->
<xsl:apply-templates select="n2:unittitle" mode="h"/>
<h4 class="h{../@from}"><xsl:value-of select="../n2:did/n2:unittitle"/></h4>
</xsl:template>

<xsl:template match="n2:c">
<xsl:apply-templates/>
</xsl:template>

                                                                                                                                                
<xsl:template match="n2:series" mode="link1">
<xsl:variable name="par">
<xsl:value-of select="../@parent"/>
</xsl:variable>
<xsl:variable name="link">http://www.oac.cdlib.org/findaid/<xsl:value-of select="$par"/>
</xsl:variable>
<a href="{$link}"><xsl:value-of select="n2:unittitle"/></a>
</xsl:template>
                                                                                                                                                
<xsl:template match="n2:series" mode="link2">
<xsl:variable name="par">http://findaid.oac.cdlib.org/images/<xsl:value-of select="../@parent"/>
</xsl:variable>
<a href="{$par}">Online Images</a>
</xsl:template>
                                                                                                                                                
<xsl:template match="n2:head">
<p><b><xsl:apply-templates/></b></p>
</xsl:template>
                                                                                                                                                
<xsl:template match="n2:emph">
<i><xsl:apply-templates/></i>
</xsl:template>
                      
<xsl:template match="n2:p">
<p><xsl:apply-templates/></p>
</xsl:template>
                      
<xsl:template match="n2:unitdate">
<xsl:apply-templates/>
</xsl:template>
                      
<xsl:template match="n2:unitid">
<br/>Unit ID: <b><xsl:apply-templates/></b><br/>
</xsl:template>
                      
<xsl:template match="n2:unittitle" mode="h">
<h4 class="h{@from}"><xsl:apply-templates/></h4>
</xsl:template>
                      
<xsl:template match="n2:title">
<i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="insert-institution-url">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:identifier[2]"/>
    </xsl:attribute>
    <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
  </a>
</xsl:template>

 
</xsl:stylesheet>
