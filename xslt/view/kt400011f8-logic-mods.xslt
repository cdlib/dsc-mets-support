<?xml version="1.0" encoding="utf-8"?>
<!-- object viewer -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/1999/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:ead="http://www.loc.gov/EAD/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:cdl2="http://www.cdlib.org/"
		xmlns:cdlview="http://www.cdlib.org/view"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:dcterms="http://purl.org/dc/terms/"
		xmlns:xtf="http://cdlib.org/xtf"
                version="2.0"
		xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="#all">
<xsl:import href="./common/brandCommon.xsl"/>
<xsl:import href="./common/scaleImage.xsl"/>
<xsl:import href="./common/MODS-view.xsl"/>
<xsl:include href="structMap.xsl"/>
<xsl:include href="multi-use.xsl"/>
<xsl:include href="insert-print-link.xsl"/>

<xsl:param name="order" select="'1'"/><!-- defaults to first div with content -->
<xsl:param name="servlet.dir"/>
<xsl:param name="debug"/>
<xsl:param name="brand" select="'oac4'"/>
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
	<xsl:value-of select="count( preceding::m:div[@ORDER][m:div] | ancestor::m:div[@ORDER][m:div])+1"/>
</xsl:key>
<xsl:key name="md" match="*" use="@ID"/>
<xsl:param name="rico"/>
<xsl:param name="structMap"/>
<xsl:param name="smLinkStyle"/>
<xsl:param name="size"/>
<xsl:param name="this.base" select="$page/m:mets/@OBJID"/>
<xsl:variable name="MOA2"/>
  <xsl:variable name="brandCgi">
    <xsl:choose>
	<xsl:when test="$brand">
	  <xsl:text>&amp;brand=</xsl:text>
	  <xsl:value-of select="$brand"/>
	</xsl:when>
	<xsl:otherwise/>
    </xsl:choose>
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
        <xsl:when test="count(
		$page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'thumbnail')][1]/m:file |
		$page/m:mets/m:fileSec//m:fileGrp/m:file[starts-with(@USE,'thumbnail')][1] 
		) = 1">
          <xsl:text>image-simple</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>image-complex</xsl:text>
        </xsl:otherwise>
   </xsl:choose>
</xsl:param>



<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" cdata-section-elements="script style" indent="yes" method="xhtml" media-type="text/html"/>
  <!-- $page has the METS, $template has HTML and template tags -->

<xsl:variable name="fLayout"   select="replace($layout,'[^\w]','-')"/>
<xsl:variable name="layoutXML" select="document(concat($fLayout,'.xhtml'))"/>

  <!-- default match identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nbsp"><xsl:text disable-output-escaping='yes'><![CDATA[&nbsp;]]></xsl:text></xsl:template>

<xsl:template match="insert-metadataPortion" name="insert-metadataPortion">
<xsl:comment>insert-metadataPortion (image-simple)</xsl:comment>
 <xsl:choose>
  <xsl:when test="$page/mets:mets/*/@xtf:meta and not($layout='metadata') and not($layout='iframe')">
	<!-- mini MD -->
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
        <xsl:copy-of
          select="cdlview:MODS(($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1],'')"/>
        <xsl:apply-templates select="$page/m:mets/relation-from[@xtf:meta]" mode="fullDC"/>
	<div><h2>Contributing Institution:</h2>
        <xsl:call-template name="insert-institution-url"/>
        </div>
  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

  <xsl:template match="insert-head-title">
<xsl:comment>insert-head-title</xsl:comment>
    <title><xsl:value-of select="$page/mets:mets/@LABEL"/></title>
  </xsl:template>

  <xsl:template match="insert-main-title">
<xsl:comment>insert-main-title</xsl:comment>
 <a href="/{$page/m:mets/@OBJID}">
    <xsl:value-of select="$page/m:mets/@LABEL"/>
 </a>
  </xsl:template>

  <xsl:template match="insert-breadcrumb">
<xsl:comment>insert-breadcrumb</xsl:comment>
<!-- breadcrumb variables -->
<xsl:variable name="class">
  <xsl:choose>
	<xsl:when test="contains($page/m:mets/@TYPE,'image')">breadcrumb-img</xsl:when>
	<xsl:when test="$page/m:mets/@TYPE='facsimile text'">breadcrumb-txt</xsl:when>
	<xsl:otherwise>breadcrumb-img</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="url">
  <xsl:choose>
	<xsl:when test="contains($page/m:mets/@TYPE,'image')">http://www.oac.cdlib.org/search.image.html</xsl:when>
	<xsl:when test="$page/m:mets/@TYPE='facsimile text'">http://www.oac.cdlib.org/texts/</xsl:when>
	<xsl:otherwise>http://www.oac.cdlib.org/</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<xsl:variable name="oactype">
  <xsl:choose>
	<xsl:when test="contains($page/m:mets/@TYPE,'image')">Images</xsl:when>
	<xsl:when test="$page/m:mets/@TYPE='facsimile text'">Texts</xsl:when>
	<xsl:otherwise>Online Archive of California</xsl:otherwise>
  </xsl:choose>
</xsl:variable>

<!-- okay, now we can start to HTML the crumbs! -->
<div class="{$class}">
<!-- crumb 1 -->
    <a href="{$url}"><xsl:value-of select="$oactype"/></a>
&#160;&#160;&gt;&#160; 
 <a href="http://www.oac.cdlib.org/findaid/ark:/{substring-after($page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@*[local-name()='href'],'ark:/')}">
<xsl:value-of select="$page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@LABEL"/></a>
<!-- img src="http://www.oac.cdlib.org/images/text_icon.gif"/ --> 
<!-- crumb 2 -->
  <xsl:choose>
	<xsl:when test="$order">
			&#160;&#160;&gt;&#160; 
		<a href="/{$page/m:mets/@OBJID}"><xsl:value-of select="$page/mets:mets/@LABEL"/></a>
			&#160;&gt;&#160;
			<xsl:value-of select="$focusDiv/@LABEL"/>
	</xsl:when>
	<xsl:otherwise/>
  </xsl:choose>
</div>
  </xsl:template>
 
  <xsl:template match="insert-pagetitle">
<xsl:comment>insert-pagetitle</xsl:comment>
     <xsl:choose>
	<xsl:when test="$order">
<xsl:value-of select="$focusDiv/@LABEL"/>

	</xsl:when>
	<xsl:otherwise>
    		<xsl:value-of select="$page/mets:mets/@LABEL"/>
	</xsl:otherwise>
     </xsl:choose>
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
   <!-- xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'thumbnail')][1]/m:file) = 1" -->
   <xsl:when test="count($page/m:mets/m:fileSec/m:fileGrp//m:file[@USE='thumbnail'] | $page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'thumbnail')][1]/m:file) = 1">
<!-- simple object -->
<xsl:variable name="use">
  <xsl:choose>
   <xsl:when test="@use = 'thumbnail'">
	<xsl:value-of select="@use"/>
   </xsl:when>
   <xsl:when test="@use = 'reference'">
      <xsl:choose>
	<xsl:when test="$focusDiv/m:div/m:fptr[@FILEID='med-res'] and not ($focusDiv/m:div/m:fptr[@FILEID='hi-res'])">
		<xsl:text>med-res</xsl:text>
	</xsl:when>
	<xsl:when test="$focusDiv/m:div/m:fptr[@FILEID='hi-res']">
		<xsl:text>hi-res</xsl:text>
	</xsl:when>
      </xsl:choose>
   </xsl:when>
   <xsl:otherwise/>
  </xsl:choose>
</xsl:variable>
<xsl:variable name="ext" select="res:getExt($page/key('md',$use)/m:FLocat[1]/@xlink:href)" xmlns:res="x-hack:res"/>
  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="@maxX"/>
      <xsl:with-param name="maxY" select="@maxY"/>
      <xsl:with-param name="x" select="number(($page/m:mets/m:structMap//m:div/m:fptr[@FILEID=$use])[1]/@cdl2:X)"/>
      <xsl:with-param name="y" select="number(($page/m:mets/m:structMap//m:div/m:fptr[@FILEID=$use])[1]/@cdl2:Y)"/>
    </xsl:call-template>

  </xsl:variable>

  <xsl:choose>
    <!-- special case for -->
    <xsl:when test="$page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='dao']">
	<a href="/{$page/m:mets/@OBJID}/dao">MOA2 Object</a>
    </xsl:when>
    <!-- the normal case -->
    <xsl:otherwise>
	<a id="zoomMe" href="/{$page/m:mets/@OBJID}/hi-res">
  	<img  border="0"
		src="/{$page/m:mets/@OBJID}/{$use}{$ext}" 
		width="{$xy/xy/@width}"
		height="{$xy/xy/@height}"
  	/></a>
    </xsl:otherwise>
  </xsl:choose>
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
  <img
        src="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference')][position()=1]/m:fptr/@FILEID}"
        width="{$xy/xy/@width}"
        height="{$xy/xy/@height}"
        border="0"
  /></a>
   </xsl:otherwise>
  </xsl:choose>

</xsl:template>

<xsl:template match="insert-sm2">
<xsl:comment>insert-sm2</xsl:comment>
	<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="structMap2"/>
</xsl:template>

<xsl:template match="m:structMap" mode="structMap">
	<xsl:apply-templates select="m:div" mode="structMap"/>
</xsl:template>

<xsl:template match="m:structMap" mode="divNavAlt1">
<xsl:comment>http://www.kryogenix.org/code/browser/aqlists/</xsl:comment>
<ul class="aqtree3clickable">
	<xsl:apply-templates select="m:div[@ORDER][m:div]" mode="recursiveDivs"/>
</ul>
</xsl:template>

 <xsl:template match="m:div[@LABEL]" mode="recursiveDivs">
 <li><a href="/{$this.base}/?order={count( preceding::m:div[@ORDER][m:div] | ancestor::m:div[@ORDER][m:div])+1}"><xsl:value-of select="@LABEL"/></a>
 <xsl:if test="m:div[@ORDER][m:div]"><ul>
 <xsl:apply-templates select="m:div[@ORDER][m:div]"  mode="recursiveDivs"/>
 </ul></xsl:if></li>
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
<xsl:comment>insert-institution-name</xsl:comment>
<xsl:variable name="insert-good-institution-name">
  <xsl:call-template name="insert-good-institution-name"/>
</xsl:variable>
<xsl:choose>
  <xsl:when test="$insert-good-institution-name!=''">
    <xsl:copy-of select="$insert-good-institution-name"/>
  </xsl:when>
  <xsl:when test="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData">
    <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/*/dc:title"/>
  </xsl:when>
  <xsl:otherwise>
        <xsl:value-of
          select="($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location[1]/mods:physicalLocation[1]"
        />
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

<xsl:template match="insert-innerIframe">
<xsl:comment>insert-innerIframe</xsl:comment>
        <xsl:if test="not($order = '1')">
<xsl:variable name="thisMODS">
                <xsl:for-each select="tokenize($focusDiv/@DMDID, '\s')">
                        <xsl:variable name="why" select="."/>
                        <xsl:copy-of select="cdlview:MODS($page/key('md', $why )//mods:mods, '')"/>
                </xsl:for-each>
</xsl:variable>
           <xsl:choose>
                        <xsl:when test="normalize-space($thisMODS) != ''">
                                <xsl:copy-of select="$thisMODS"/>
                        </xsl:when>
                <xsl:otherwise>
                        <h2>Title:</h2>
                        <h2>From:</h2>
                </xsl:otherwise>
           </xsl:choose>
	<hr/><h1>From:</h1>
        </xsl:if>
</xsl:template>

<xsl:template match="insert-inner-metadata">
<xsl:comment>insert-inner-metadata</xsl:comment>
<xsl:variable name="thisMODS">
                <xsl:for-each select="tokenize($focusDiv/@DMDID, '\s')">
                        <xsl:variable name="why" select="."/>
                        <xsl:copy-of select="cdlview:MODS($page/key('md', $why )//mods:mods, '')"/>
                </xsl:for-each>
</xsl:variable>
<div id="{@css-id}" class="nifty1" xmlns="http://www.w3.org/1999/xhtml">
            <div class="metadata-text">
        <xsl:if test="not($order = '1')">
           <xsl:choose>
                        <xsl:when test="normalize-space($thisMODS) != ''">
                                <xsl:copy-of select="$thisMODS"/><h2>From:</h2>
                        </xsl:when>
                <xsl:otherwise>
                        <h2>Title:</h2>
                        <p><xsl:value-of select="$focusDiv/@LABEL"/></p>
                        <h2>From:</h2>
                </xsl:otherwise>
           </xsl:choose>
                <a href="/{$page/m:mets/@OBJID}?{$brandCgi}"><xsl:value-of select="$page/mets:mets/@LABEL"/></a>
        </xsl:if>
        <xsl:if test="$order = '1'">
                <xsl:copy-of select="$thisMODS"/>
        </xsl:if>
                <xsl:apply-templates select="$page/m:mets/relation-from[@xtf:meta]" mode="fullDC"/>
                <h2>Contributing Institution:</h2><xsl:call-template name="insert-institution-url"/>
            </div>
</div>
</xsl:template>


</xsl:stylesheet>
