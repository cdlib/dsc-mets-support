<?xml version="1.0" encoding="utf-8"?>
<!-- object viewer -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:cdl2="http://www.cdlib.org/"
		xmlns:cdlview="http://www.cdlib.org/view"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:mods="http://www.loc.gov/mods/v3"
		xmlns:gdm="http://sunsite.berkeley.edu/MOA2/"
                xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:xtf="http://cdlib.org/xtf"
		xmlns:view_="http://www.cdlib.org/view_"
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
		xmlns:exslt="http://exslt.org/common"
        xmlns:FileUtils="java:org.cdlib.xtf.xslt.FileUtils"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="#all">
<xsl:import href="./common/scaleImage.xsl"/>
<xsl:import href="./common/brandCommon.xsl"/>
<xsl:import href="./common/tracking.xsl"/>
<xsl:import href="./common/MODS-view.xsl"/>
<xsl:include href="structMap.xsl"/>
<xsl:include href="multi-use.xsl"/>
<xsl:include href="insert-print-link.xsl"/>
<xsl:param name="order" select="'1'"/><!-- defaults to first div with content -->
<xsl:param name="debug"/>
<xsl:param name="brand" select="'oac4'"/>
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
<xsl:param name="smLinkStyle"/>
<xsl:param name="rico"/>
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
       <xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'reference')]/m:file[@MIMETYPE='application/pdf']) = 1"> 
           <xsl:text>metadata</xsl:text>
       </xsl:when>
	<xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'thumbnail')]/m:file) = 1"> 
	  <xsl:text>image-simple</xsl:text>
        </xsl:when>
	<xsl:otherwise>
	  <xsl:text>image-complex</xsl:text>
	</xsl:otherwise>
   </xsl:choose>
</xsl:param>

<!-- xsl:output method="html"/ -->

<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" omit-xml-declaration="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" cdata-section-elements="script style" indent="yes" method="xhtml" media-type="text/html"/>

  <!-- $page has the METS, $template has HTML and template tags -->
<xsl:variable name="fLayout"   select="replace($layout,'[^\w]','-')"/>
<xsl:variable name="layoutXML" select="document(concat($fLayout,'.xhtml'))"/>

  <!-- default match identity transform -->
  <xsl:template match="@*|node()">
    <!-- xsl:namespace name="http://www.w3.org/1999/xhtml"/ -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="insert-metadataPortion" name="insert-metadataPortion">
<xsl:comment>insert-metadataPortion (image-simple)</xsl:comment>
<xsl:variable name="thisTranscriptionID">
<xsl:value-of select="$focusDiv//m:div[@TYPE='transcription']/m:fptr/@FILEID"/>
</xsl:variable>

<xsl:choose>
  <xsl:when test="$page/mets:mets/*/@xtf:meta and not($layout='metadata') and not($layout='iframe')">
        <xsl:comment>@xtf:meta found</xsl:comment>
        <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="briefMeta"/>
        <div><h2>Contributing Institution:</h2>
        <xsl:call-template name="insert-institution-name"/>
        </div>
  </xsl:when>
  <xsl:when test="$layout = 'printable-details'">
        <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
  </xsl:when>
  <xsl:otherwise>
        <xsl:if test="$layout != 'metadata' and $layout != 'iframe'"><xsl:comment>@xtf:meta not found</xsl:comment></xsl:if>
        <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
        <div><h2>Contributing Institution:</h2>
        <xsl:call-template name="insert-institution-url"/>
        </div>
	<xsl:if test="$thisTranscriptionID and $thisTranscriptionID != ''">
		<div><h2>Transcription:</h2>
		<xsl:apply-templates 
			select="$page/key('md',$thisTranscriptionID)" 
			mode="transcription"/>
		</div>
	</xsl:if>
  </xsl:otherwise>
 </xsl:choose>

</xsl:template>


<xsl:template match="insert-metadataPortion" mode="MMMmods">
<!-- image-simple metadata printable-details -->
<xsl:comment>insert-metadataPortion (image-simple)</xsl:comment>
 <xsl:choose>
  <xsl:when test="$page/mets:mets/*/@xtf:meta and not($layout='metadata') and not($layout='iframe')">
	<xsl:comment>@xtf:meta found</xsl:comment>
	<xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="briefMeta"/>
	<div><h2>Contributing Institution:</h2>
	<xsl:call-template name="insert-institution-name"/></div>
  </xsl:when>
  <xsl:when test="$layout = 'printable-details'">
        <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
  </xsl:when>
  <xsl:otherwise>
	<xsl:if test="$layout != 'metadata' and $layout !='iframe'"><xsl:comment>@xtf:meta not found</xsl:comment></xsl:if>
	<xsl:copy-of 
	  select="cdlview:MODS(($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1],'')"/>
	<!-- xsl:apply-templates select="$page/m:mets/relation-from[@xtf:meta]" mode="fullDC"/ -->
                <xsl:apply-templates select="$page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']" mode="link"/>
	<div><h2>Contributing Institution:</h2>
	<xsl:call-template name="insert-institution-url"/></div>
  </xsl:otherwise>
 </xsl:choose>
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

   <xsl:if test="count($page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'reference')]/m:file[@MIMETYPE='application/pdf']) = 1"> 
			<a href="/{$page/m:mets/@OBJID}/{($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'reference')]/m:file[@MIMETYPE='application/pdf'])[1]/@ID}">Download PDF</a> (<xsl:value-of select="
	FileUtils:humanFileSize(
		(($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'reference')]/m:file)[1]/@SIZE)
		)"/>)
   </xsl:if>

  <xsl:variable name="use" select="@use"/>
  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="@maxX"/>
      <xsl:with-param name="maxY" select="@maxY"/>
      <xsl:with-param name="x" select="number(($page/m:mets/m:structMap//m:div[starts-with(@TYPE,$use)])[1]/m:fptr/@cdl2:X)"/>
      <xsl:with-param name="y" select="number(($page/m:mets/m:structMap//m:div[starts-with(@TYPE,$use)])[1]/m:fptr/@cdl2:Y)"/>
    </xsl:call-template>
  </xsl:variable>
<a id="zoomMe" href="/{$page/m:mets/@OBJID}/{$page/m:mets/m:structMap//m:div[starts-with(@TYPE,'reference')][position()=(last() - number($mrsid-hack))]/m:fptr/@FILEID}" title="Larger Image">

  <xsl:variable
    name="myFileId"
    select="$page/m:mets/m:structMap//m:div[starts-with(@TYPE,$use)][1]/m:fptr/@FILEID"
  />
  <xsl:variable name="ext" select="res:getExt($page/key('md',$myFileId)/m:FLocat[1]/@xlink:href)" xmlns:res="x-hack:res"/>
  <img  border="0"
	src="/{$page/m:mets/@OBJID}/{$myFileId}{$ext}" alt="Larger Image"
	width="{$xy/xy/@width}"
	height="{$xy/xy/@height}"
  /></a>
<xsl:call-template name="single-image-zoom"/>
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
  <xsl:variable
    name="myFileId"
    select="$focusDiv/m:div[starts-with(@TYPE,'reference')][position()=1]/m:fptr/@FILEID"
  />
  <xsl:variable name="ext" select="res:getExt($page/key('md',$myFileId)/m:FLocat[1]/@xlink:href)" xmlns:res="x-hack:res"/>
  <img
        src="/{$page/m:mets/@OBJID}/{$myFileId}{$ext}"
        width="{$xy/xy/@width}"
        height="{$xy/xy/@height}"
        border="0"
  /></a>

   </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<xsl:template match="insert-institution-url" name="insert-institution-url">
<xsl:comment>insert-institution-url</xsl:comment>
<xsl:variable name="insert-good-institution-url">
  <xsl:call-template name="insert-good-institution-url"/>
</xsl:variable>
<xsl:choose>
  <xsl:when test="$insert-good-institution-url!=''">
    <xsl:copy-of select="$insert-good-institution-url"/>
  </xsl:when>
  <xsl:when test="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData">
 <a>
    <xsl:attribute name="href">
      <xsl:value-of select="
	if ($page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData//dc:identifier[2])
	then $page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData//dc:identifier[2]
	else $page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData//dc:identifier[1]
	"/>
    </xsl:attribute>
    <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData//dc:title"/>
  </a>
  </xsl:when>
  <xsl:otherwise>
	<xsl:variable name="string" select="$page/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:publisher[1]"/>
	<xsl:choose>
               <xsl:when test="substring-after($string,'http://')">
                        <a target="_top" href="http://{substring-after(normalize-space($string),'http://')}">
                        <xsl:value-of select="substring-before(normalize-space($string),'http://')"/>
                        </a>
                </xsl:when>
                        <!-- to do, clean up trailing semi colons -->
                <xsl:otherwise>
                        <xsl:value-of select="$string"/>
                </xsl:otherwise>
	</xsl:choose>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="insert-institution-name" name="insert-institution-name">
<xsl:comment>insert-institution-name</xsl:comment>
<xsl:variable name="insert-good-institution-name">
  <xsl:call-template name="insert-good-institution-name"/>
</xsl:variable>
<xsl:choose>
  <xsl:when test="$insert-good-institution-name!=''">
    <xsl:copy-of select="$insert-good-institution-name"/>
  </xsl:when> 
  <xsl:when test="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData">
    <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData//dc:title"/>
  </xsl:when>
  <xsl:otherwise>
     <xsl:value-of select="$page/m:mets/m:dmdSec/m:mdWrap[@MDTYPE='DC']/m:xmlData/record/dc:publisher"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- calisphere design -->

<xsl:template match="insert-sitesearch">
<xsl:comment>insert-sitesearch</xsl:comment>
<!-- set up variables, fill out template  -->
<xsl:copy-of select="$brand.search.box"/>
</xsl:template>

<!-- calisphere image-simple -->
<xsl:template match="insert-largerImageLink">
<!-- saving this for 500x400 1200x1000 type image size options -->
</xsl:template>

<!-- calisphere image-complex -->

<!-- xsl:template match="insert-inner-paging">
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
</xsl:template -->

<xsl:template match="gdm:LocalID">
<div><h2>Identifier:</h2><xsl:value-of select="."/>
</div>
</xsl:template>

<xsl:template match="gdm:coreDate[@primaryDate or @beginDateNorm]">
<div><h2>Date:</h2><xsl:value-of select="if (@primaryDate)
	then @primaryDate
	else @beginDateNorm"/></div>
</xsl:template>

<xsl:template match="gdm:GDM">
 <xsl:apply-templates select="gdm:Core/gdm:coreDate, gdm:Core/gdm:LocalID"/>
</xsl:template>

<xsl:template match="insert-innerIframe">
<xsl:comment>insert-innerIframe</xsl:comment>
	<xsl:if test="not($order = '1')">
	<xsl:variable name="thisGDM">
                <xsl:for-each select="tokenize($focusDiv/@DMDID, '\s')">
                        <xsl:variable name="why" select="."/>
                        <xsl:apply-templates select="$page/key('md', $why )/m:mdWrap/m:xmlData/gdm:GDM"/>
                </xsl:for-each>
	</xsl:variable>
		<div><h2>Title:</h2>
			<xsl:value-of select="$focusDiv/@LABEL"/>
		</div>
		<xsl:copy-of select="$thisGDM"/>
		<hr/><h1>From:</h1>
	</xsl:if>
</xsl:template>

<xsl:template match="insert-inner-metadata">
<xsl:comment>insert-inner-metadata</xsl:comment>

<xsl:variable name="thisGDM">
                <xsl:for-each select="tokenize($focusDiv/@DMDID, '\s')">
                        <xsl:variable name="why" select="."/>
                        <xsl:apply-templates select="$page/key('md', $why )/m:mdWrap/m:xmlData/gdm:GDM"/>
                </xsl:for-each>
</xsl:variable>

<xsl:variable name="thisTranscriptionID">
	<xsl:value-of select="$focusDiv/m:div[@TYPE='transcription']/m:fptr/@FILEID"/>
</xsl:variable>

<div id="{@css-id}" class="nifty1" xmlns="http://www.w3.org/1999/xhtml">
            <div class="metadata-text">
        <xsl:if test="not($order = '1')">

		<xsl:if test="$thisTranscriptionID and $thisTranscriptionID != ''">
			<div><h2>Transcription:</h2>
			<xsl:apply-templates select="$page/key('md',$thisTranscriptionID)" mode="transcription"/>
			</div>
		</xsl:if>

                <div><h2>Title:</h2>
                <xsl:value-of select="$focusDiv/@LABEL"/>
                </div>
<xsl:copy-of select="$thisGDM"/>
                <div><h2>From:</h2>
                <a href="/{$page/m:mets/@OBJID}?{$brandCgi}"><xsl:value-of select="$page/mets:mets/@LABEL"/></a>
                </div>
                <xsl:apply-templates select="$page/m:mets/relation-from[@xtf:meta]" mode="fullDC"/>
        </xsl:if>
        <xsl:if test="$order = '1'">
                <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
        </xsl:if>
                <div><h2>Contributing Institution:</h2><xsl:call-template name="insert-institution-url"/></div>
            </div>
</div>
</xsl:template>

<xsl:template match="transcription" mode="transcription">
	<div>
		<xsl:apply-templates mode="transcription"/>
	</div>
</xsl:template>

<xsl:template match="m:mdRef" mode="link">
<p>
	<xsl:if test="position()=1"><h2>Collection:</h2></xsl:if>
	<a href="{@*[local-name()='href']}{$brandCgi}"><xsl:value-of select="@LABEL"/></a>
</p>
</xsl:template>


</xsl:stylesheet>
