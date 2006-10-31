<?xml version="1.0" encoding="utf-8"?>
<!-- object viewer -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:cdl2="http://www.cdlib.org/"
		xmlns:cdlview="http://www.cdlib.org/view"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:xtf="http://cdlib.org/xtf"
		xmlns:view_="http://www.cdlib.org/view_"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
		xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="#all">
<xsl:import href="./common/scaleImage.xsl"/>
<xsl:import href="./common/brandCommon.xsl"/>
<xsl:import href="./common/MODS-view.xsl"/>
<xsl:include href="structMap.xsl"/>
<xsl:include href="multi-use.xsl"/>
<xsl:include href="insert-print-link.xsl"/>
<xsl:param name="order" select="'1'"/><!-- defaults to first div with content -->
<xsl:param name="debug"/>
<xsl:param name="brand" select="'oac'"/>
<xsl:param name="servlet.dir"/>

<!-- temporary for oac -> oacui transition -->
  <xsl:param name="brand.file">
    <xsl:choose>
      <xsl:when test="$brand = 'oac'">
        <xsl:copy-of select="document(concat($servlet.dir,'/brand/oacui.xml'))"/>
      </xsl:when>
      <xsl:when test="$brand = 'eqf'">
        <xsl:copy-of select="document(concat($servlet.dir,'/brand/eqfui.xml'))"/>
      </xsl:when>
      <xsl:when test="$brand != ''">
        <xsl:copy-of select="document(concat($servlet.dir,'/brand/',$brand,'.xml'))"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="document(concat($servlet.dir,'/brand/default.xml'))"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:param>
  <!-- end temp -->

<xsl:key name="absPos" match="m:div[@ORDER or @LABEL][m:div]">
	<xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
</xsl:key>
<xsl:key name="absPosItem" match="m:div[m:div/m:fptr]">
	<!-- xsl:value-of select="count( preceding::m:div[m:div/m:fptr] | ancestor::m:div[m:div/m:fptr])+1" -->
	<xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
</xsl:key>
<xsl:key name="md" match="*" use="@ID"/>
  <xsl:key name="divIsImage" match="m:div[m:div/m:fptr]" use="@ID"/>
  <xsl:key name="divShowsChild" match="m:div[m:div/m:div/m:fptr][not(m:div/m:div/m:div/m:fptr)]" use="@ID"/>
  
  
<xsl:param name="smLinkStyle"/>

<xsl:param name="structMap"/>
<xsl:param name="size"/>
<xsl:param name="this.base" select="$page/m:mets/@OBJID"/>
<xsl:variable name="MOA2"/>
  <xsl:variable name="brandCgi">
	<xsl:if test="$brand">
	  <xsl:text>&amp;brand=</xsl:text>
	  <xsl:value-of select="$brand"/>
	</xsl:if>
	<xsl:if test="$smLinkStyle">
	  <xsl:text>&amp;smLinkStyle=</xsl:text>
	  <xsl:value-of select="$smLinkStyle"/>
	</xsl:if>
  </xsl:variable>
<xsl:variable name="focusDiv" select="key('absPos',$order)"/>

	<xsl:variable name="lsize">
	<xsl:choose>
		<xsl:when test="$size"><xsl:value-of select="$size"/></xsl:when>
		<xsl:otherwise>1</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

  <xsl:variable name="page" select="/"/>
<!-- template specifies .xhtml template file -->
<xsl:param name="layout">
   <xsl:choose>
	<xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'thumbnail')][1]/m:file) = 1"> 
	  <xsl:text>image-simple</xsl:text>
        </xsl:when>
	<xsl:otherwise>
	  <xsl:text>image-complex</xsl:text>
	</xsl:otherwise>
   </xsl:choose>
</xsl:param>

<!-- xsl:output method="html"/ -->

<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" omit-xml-declaration="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" cdata-section-elements="script style" indent="yes" method="xhtml"/>

  <!-- $page has the METS, $template has HTML and template tags -->
<xsl:variable name="fLayout"   select="replace($layout,'[^\w]','-')"/>
<xsl:variable name="layoutXML" select="document(concat($fLayout,'.xhtml'))"/>

<!-- root template -->
<xsl:template match="/">
	<xsl:comment>dynaXML xtf.sf.net
	xml: <xsl:value-of select="base-uri($page)"/>
	PROFILE: <xsl:value-of select="$page/m:mets/@PROFILE"/>
	xslt: <xsl:value-of select="static-base-uri()"/>
	layout: <xsl:value-of select="base-uri($layoutXML)"/>
	brand: <xsl:value-of select="$brand"/> 
	</xsl:comment>
  	<xsl:apply-templates select="($layoutXML)//*[local-name()='html']"/>
</xsl:template>

  <!-- default match identity transform -->
  <xsl:template match="@*|node()">
    <!-- xsl:namespace name="" select="'http://www.w3.org/1999/xhtml'"/ -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="insert-metadataPortion">
<!-- image-simple metadata printable-details -->
<xsl:comment>insert-metadataPortion (image-simple)</xsl:comment>
 <xsl:choose>
  <xsl:when test="$page/mets:mets/*/@xtf:meta and not($layout='metadata')">
	<xsl:comment>@xtf:meta found</xsl:comment>
	<xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="briefMeta"/>
	<p><h2>Contributing Institution:</h2>
	<xsl:call-template name="insert-institution-name"/></p>
  </xsl:when>
  <xsl:when test="$layout = 'printable-details'">
        <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
  </xsl:when>
  <xsl:otherwise>
	<xsl:if test="$layout != 'metadata'"><xsl:comment>@xtf:meta not found</xsl:comment></xsl:if>
	<xsl:copy-of 
	  select="cdlview:MODS(($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1],'')"/>
	<!-- xsl:apply-templates select="$page/m:mets/relation-from[@xtf:meta]" mode="fullDC"/ -->
                <xsl:apply-templates select="$page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']" mode="link"/>
	<p><h2>Contributing Institution:</h2>
	<xsl:call-template name="insert-institution-url"/></p>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<xsl:template match="insert-brand-links">
<xsl:comment>insert-brand-links</xsl:comment>
 <xsl:apply-templates select="$brand.links"/>

<xsl:if test="$structMap='alt1'">
    <script type="text/javascript" src="/js3p/aqlists/aqtree3clickable.js"></script>
	<link rel="stylesheet" href="/js3p/aqlists/aqtree3clickable.css"/>
</xsl:if>
</xsl:template>

<xsl:template match="insert-brand-head">
<xsl:comment>insert-brand-head</xsl:comment>
 <xsl:copy-of select="$brand.header"/>
</xsl:template>

<xsl:template match="insert-brand-footer">
<xsl:comment>insert-brand-footer</xsl:comment>
 <xsl:copy-of select="$brand.footer"/>
</xsl:template>

<xsl:template match="@*" mode="attrComments">
@<xsl:value-of select="name()"/> <xsl:value-of select="."/>
</xsl:template>

  <xsl:template match="insert-head-title">
<xsl:comment>insert-head-title</xsl:comment>
    <title><xsl:value-of select="$page/mets:mets/@LABEL"/></title>
  </xsl:template>

<xsl:template match="insert-image-simple">
<xsl:comment>
	<xsl:text>insert-image-simple @use=</xsl:text>
	<xsl:value-of select="@use"/>
	<xsl:text> @maxX=</xsl:text>
	<xsl:value-of select="@maxX"/>
	<xsl:text> @maxY=</xsl:text>
	<xsl:value-of select="@maxY"/>
</xsl:comment>
   <xsl:choose>
   <xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'thumbnail')][1]/m:file) = 1"><!-- simple object -->
  <xsl:variable name="use" select="@use"/>
  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="@maxX"/>
      <xsl:with-param name="maxY" select="@maxY"/>
      <xsl:with-param name="x" select="number(($page/m:mets/m:structMap//m:div[starts-with(@TYPE,$use)])[1]/m:fptr/@cdl2:X)"/>
      <xsl:with-param name="y" select="number(($page/m:mets/m:structMap//m:div[starts-with(@TYPE,$use)])[1]/m:fptr/@cdl2:Y)"/>
    </xsl:call-template>
  </xsl:variable>
<a href="/{$page/m:mets/@OBJID}/{$page/m:mets/m:structMap//m:div[starts-with(@TYPE,'reference')][position()=(last() - number($mrsid-hack))]/m:fptr/@FILEID}" title="Larger Image">
  <img  border="0"
	src="/{$page/m:mets/@OBJID}/{$page/m:mets/m:structMap//m:div[starts-with(@TYPE,$use)][1]/m:fptr/@FILEID}" alt="Larger Image"
	width="{$xy/xy/@width}"
	height="{$xy/xy/@height}"
  /></a>
   </xsl:when>
   <xsl:otherwise><!-- page in a complex object -->

	<xsl:variable name="thisImage" select="$focusDiv/m:div[starts-with(@TYPE,'reference')][position()=1]"/>

  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="'512'"/>
      <xsl:with-param name="maxY" select="'800'"/>
      <xsl:with-param name="x" select="number($thisImage/m:fptr/@cdl2:X)"/>
      <xsl:with-param name="y" select="number($thisImage/m:fptr/@cdl2:Y)"/>
    </xsl:call-template>
  </xsl:variable>
  <a href="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference')][position()=(last() - number($mrsid-hack))]/m:fptr/@FILEID}">
  <img
        src="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference')][position()=1]/m:fptr/@FILEID}"
        width="{$xy/xy/@width}"
        height="{$xy/xy/@height}"
        border="0"
  /></a>

   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="insert-institution-url" name="insert-institution-url">
<xsl:comment>insert-institution-url</xsl:comment>
<xsl:choose>
  <xsl:when test="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData">
 <a>
    <xsl:attribute name="href">
      <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/*/dc:identifier[2]"/>
    </xsl:attribute>
    <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/*/dc:title"/>
  </a>
  </xsl:when>
  <xsl:otherwise>
 	<xsl:apply-templates
	  select="($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location[1]/mods:physicalLocation[1]" 
	  mode="viewMODS"
	/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="insert-institution-name" name="insert-institution-name">
<xsl:comment>insert-institution-url</xsl:comment>
<xsl:choose>
  <xsl:when test="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData">
    <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/*/dc:title"/>
  </xsl:when>
  <xsl:otherwise>
 	<xsl:value-of
	  select="
		replace(normalize-space(
($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location[1]/mods:physicalLocation[1]) , 'http://.*$' , '')" 
	/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- calisphere design -->

<!-- calisphere image-simple -->
<xsl:template match="insert-largerImageLink">
<!-- saving this for 500x400 1200x1000 type image size options -->
</xsl:template>

<!-- calisphere image-complex -->

<xsl:template match="insert-inner-paging">
<xsl:comment>insert-inner-paging</xsl:comment>
<xsl:variable name="imageIsNext">
	<xsl:if test="$page/key('absPos',number($order) +1)/m:div/m:fptr">true</xsl:if>
</xsl:variable>
<xsl:variable name="imageIsBefore">
	<xsl:if test="$page/key('absPos',number($order) -1)/m:div/m:fptr">true</xsl:if>
</xsl:variable>

<xsl:if test="$imageIsBefore = 'true'">
	<a href="/{$page/m:mets/@OBJID}/?order={number($order) - 1}{$brandCgi}">previous</a>
</xsl:if>
<xsl:if test="$imageIsBefore = 'true' and $imageIsNext = 'true'">
	<span class="bullet">|</span>
</xsl:if>
<xsl:if test="$imageIsNext = 'true'">
	<a href="/{$page/m:mets/@OBJID}/?order={number($order) + 1}{$brandCgi}">next</a>
</xsl:if>
</xsl:template>

<xsl:template match="m:mdRef" mode="link">
<p>
	<xsl:if test="position()=1"><h2>Collection:</h2></xsl:if>
	<a href="{@*[local-name()='href']}{$brandCgi}"><xsl:value-of select="@LABEL"/></a>
</p>
</xsl:template>


</xsl:stylesheet>
