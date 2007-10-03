<?xml version="1.0" encoding="utf-8"?>
<!-- object viewer -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
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
<!-- xsl:import href="MODS-view.xsl"/ -->
<xsl:include href="multi-use.xsl"/>
<xsl:include href="insert-print-link.xsl"/>
<xsl:param name="servlet.dir"/>
<xsl:param name="order" select="'1'"/><!-- defaults to first div with content -->
<xsl:param name="debug"/>
<xsl:param name="brand" select="'calisphere'"/>
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
<xsl:key name="divByOrder" match="m:div[@ORDER]" use="@ORDER"/>
<xsl:key name="absPos" match="m:div[@ORDER][m:div]">
	<xsl:value-of select="count( preceding::m:div[@ORDER][m:div] | ancestor::m:div[@ORDER][m:div])+1"/>
</xsl:key>
<xsl:key name="absPosItem" match="m:div[m:div/m:fptr]">
	<!-- xsl:value-of select="count( preceding::m:div[m:div/m:fptr] | ancestor::m:div[m:div/m:fptr])+1" -->
	<xsl:value-of select="count( preceding::m:div[@ORDER][m:div] | ancestor::m:div[@ORDER][m:div])+1"/>
</xsl:key>
<xsl:key name="md" match="*" use="@ID"/>
<xsl:param name="rico"/>
<xsl:param name="structMap"/>
<xsl:param name="size"/>
<xsl:param name="this.base" select="$page/m:mets/@OBJID"/>

  <xsl:variable name="brandCgi">
    <xsl:choose>
	<xsl:when test="$brand">
	  <xsl:text>&amp;brand=</xsl:text>
	  <xsl:value-of select="$brand"/>
	</xsl:when>
	<xsl:otherwise/>
    </xsl:choose>
  </xsl:variable>
<xsl:variable name="focusDiv" select="($page/m:mets/m:structMap/m:div[m:div/m:fptr])[1]"/>
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
	<xsl:when test="$MOA2='MOA2'">
		<xsl:text>metadata</xsl:text>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>image-simple</xsl:text>
	</xsl:otherwise>
  </xsl:choose>
</xsl:param> 

<xsl:variable name="MOA2">
   <xsl:choose>
	<xsl:when test="$page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='dao']
                        or
ends-with(($page/m:mets/m:fileSec/m:fileGrp/m:file[@ID='hi-res'])[1]/m:FLocat/@*[local-name()='href'],'.xml')
        "><xsl:text>MOA2</xsl:text>
	</xsl:when>
	<xsl:otherwise/>
   </xsl:choose>
</xsl:variable>

<!-- xsl:output method="html"/ -->

<!-- xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/ -->

<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" omit-xml-declaration="yes" cdata-section-elements="script style" indent="yes" method="xhtml" media-type="text/html"/>


  <!-- $page has the METS, $template has HTML and template tags -->

<xsl:variable name="fLayout"   select="replace($layout,'[^\w]','-')"/>
<xsl:variable name="layoutXML" select="document(concat($fLayout,'.xhtml'))"/>

  <xsl:template match="/">
<xsl:comment> dynaXML xtf.sf.net
xml: <xsl:value-of select="base-uri($page)"/>
PROFILE: <xsl:value-of select="$page/m:mets/@PROFILE"/>
xslt: <xsl:value-of select="static-base-uri()"/>
layout: <xsl:value-of select="base-uri($layoutXML)"/>
brand: <xsl:value-of select="$brand"/> 
</xsl:comment>

  <xsl:apply-templates 
	select="($layoutXML)//*[local-name()='html']"/>
  </xsl:template>

  <!-- default match identity transform -->
  <xsl:template match="@*|node()">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nbsp"><xsl:text disable-output-escaping='yes'><![CDATA[&nbsp;]]></xsl:text></xsl:template>

<xsl:template match="insert-institution-url" name="insert-institution-url">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:identifier[2]"/>
    </xsl:attribute>
    <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
  </a>
</xsl:template>

<xsl:template match="insert-institution-name" name="insert-institution-name">
    <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
</xsl:template>

<xsl:template match="insert-metadataPortion" name="insert-metadataPortion">
<xsl:comment>insert-metadataPortion (image-simple)</xsl:comment>
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
<xsl:comment>from an EAD snippet</xsl:comment>

<xsl:apply-templates select="$page/m:mets/m:dmdSec[@ID='dsc']/m:mdWrap/m:xmlData/ead:c"/>
	<div><h2>Contributing Institution:</h2>
	<xsl:call-template name="insert-institution-url"/>
	</div>

  </xsl:otherwise>
 </xsl:choose>
</xsl:template>

<!-- xsl:template match='ead:*'>
        <xsl:if test="descendant-or-self::*[text()]"><p><xsl:apply-templates/></p></xsl:if>
</xsl:template -->

<xsl:template match="ead:*">
        <xsl:if test="@label">
        <h2><xsl:value-of select="@label"/>
                <xsl:if test="
                        substring(@label,string-length(@label)) != ':'
                        and
                        substring(@label, string-length(@label)-1) != ': '
                ">:
                </xsl:if>
        </h2>
        </xsl:if>

        <xsl:apply-templates/>

<xsl:if test="child::text() and not((ancestor::ead:dsc) and (../ead:did))">
<xsl:text disable-output-escaping='yes'><![CDATA[<br/>]]></xsl:text>
</xsl:if>

</xsl:template>

<!-- xsl:template match="ead:*">
	<p>
        <xsl:apply-templates/>
	</p>

<xsl:if test="child::text() and not((ancestor::ead:dsc) and (../ead:did))">
<xsl:text disable-output-escaping='yes'><![CDATA[<br/>]]></xsl:text>
</xsl:if>
</xsl:template -->

<xsl:template match="ead:lb">
<xsl:text> -- </xsl:text>
</xsl:template>

<xsl:template match="ead:c">
		<xsl:apply-templates select="ead:did" mode="did"/>
		<xsl:apply-templates select="ead:*[local-name() != 'series'][local-name() !='did']"/>
	<xsl:if test="ead:series">
		<div><h2>Collection:</h2><xsl:text> </xsl:text>
		<xsl:apply-templates select="ead:series" mode="link1"/>
		</div>
	</xsl:if>
</xsl:template>

<xsl:template match="ead:repository">
</xsl:template>

<xsl:template match="ead:origination" mode="did">
	<xsl:apply-templates select="*" mode="did"/>
</xsl:template>

<xsl:template match="ead:origination[1]" mode="did">
<xsl:choose>
  <xsl:when test="text() and not (ead:*)">
<div><h2>Creator/Contributor:</h2>
	<xsl:value-of select="."/>
</div>
  </xsl:when>
  <xsl:otherwise>
<div><h2>Creator/Contributor:</h2>
</div>
	<xsl:apply-templates select="*" mode="did"/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="ead:persname | ead:corpname" mode="did">
	<p><xsl:value-of select="."/></p>
</xsl:template>

<xsl:template match="ead:persname[@role] | ead:corpname[@role]" mode="did">
	<p><xsl:value-of select="."/> (<xsl:value-of select="@role"/>)</p>
</xsl:template>


<xsl:template match="ead:did" mode="did">
	<xsl:if test="not(ead:unittitle) or (ead:unittitle and ead:unittitle='')">
<div><h2>Title:</h2>
<xsl:value-of select="../ead:series/ead:unittitle[position() = last()]"/>
</div></xsl:if>
        <xsl:apply-templates select=".//ead:unittitle[text()], .//ead:origination, .//ead:unitdate, .//ead:unitid | .//ead:container, .//ead:physdesc" mode="did"/>
        <xsl:apply-templates select="ead:abstract | ead:langmaterial | ead:materialspec | ead:note | ead:physloc " mode="did"/>
<!-- abstract, container, dao, daogrp, head, langmaterial, materialspec, note, origination, physdesc, physloc, repository, unitdate, unitid, unittitle -->
</xsl:template>

<xsl:template match="*" mode="did">
	<p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="ead:physdesc" mode="did">
<div><h2>Format:</h2>
<xsl:value-of select="."/>
</div>
</xsl:template>

<xsl:template match="ead:unitdate" mode="did">
<div><h2>Date:</h2>
<xsl:value-of select="."/>
</div>
</xsl:template>

<xsl:template match="ead:unitid | ead:container" mode="did">
<div><h2>Identifier:</h2>
<xsl:value-of select="."/>
</div>
</xsl:template>

<xsl:template match="ead:unittitle" mode="did">
<div><h2>Title:</h2>
<xsl:apply-templates select="text()|ead:lb"/>
</div>
</xsl:template>



<xsl:template match="text()" mode="dscdid">
        <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="ead:p" mode="dscdid">
        <p><xsl:apply-templates/></p>
</xsl:template>

<xsl:template match="*[@label][local-name()!='container']" mode="dscdid">

        <div><h2><xsl:value-of select="@label"/>
                <xsl:if test="
                        substring(@label,string-length(@label)) != ':'
                        and
                        substring(@label, string-length(@label)-1) != ': '
                ">:
                </xsl:if><xsl:text disable-output-escaping='yes'><![CDATA[<br />]]></xsl:text>
        </h2><xsl:apply-templates/>
        </div>

</xsl:template>

                                                                                                                                                
<xsl:template match="ead:series" mode="link1">
<xsl:variable name="par">
<xsl:value-of select="../@parent"/>
</xsl:variable>
<xsl:variable name="link">http://www.oac.cdlib.org/findaid/<xsl:value-of select="$par"/>/?<xsl:value-of select="$brandCgi"/>
</xsl:variable>
<a href="{$link}"><xsl:value-of select="ead:unittitle[1]"/></a>
<xsl:text> </xsl:text>
<xsl:value-of select="ead:unittitle[position() &gt; 1]"/>
</xsl:template>
                                                                                                                                                
<xsl:template match="ead:series" mode="link2">
<xsl:variable name="par">http://findaid.oac.cdlib.org/images/<xsl:value-of select="../@parent"/>
</xsl:variable>
<a href="{$par}">Online Images</a>
</xsl:template>
                                                                                                                                                
<xsl:template match="ead:head">
<xsl:if test="not(../ead:controlaccess/ead:head)">
	<h2><xsl:value-of select="."/>
 	<xsl:if test="not(matches(.,'.*[.:;,]+\s*$'))">: </xsl:if>
	</h2>
</xsl:if>
</xsl:template>

<xsl:template match="ead:emph">
<i><xsl:apply-templates/></i>
</xsl:template>
                      
<xsl:template match="ead:p[1]">
<xsl:apply-templates/>
</xsl:template>
                      
<xsl:template match="ead:p">
<p><xsl:apply-templates/></p>
</xsl:template>
                      
<xsl:template match="ead:unitdate">
<xsl:apply-templates/>
</xsl:template>
                      
<xsl:template match="ead:unitid">
<br/>Unit ID: <b><xsl:apply-templates/></b><br/>
</xsl:template>
                      
<xsl:template match="ead:unittitle" mode="h">
<h4 class="h{@from}"><xsl:apply-templates/></h4>
</xsl:template>
                      
<xsl:template match="ead:title">
<i><xsl:apply-templates/></i>
</xsl:template>

<xsl:template match="insert-brand-links">
<xsl:comment>insert-brand-links</xsl:comment>
 <xsl:copy-of select="$brand.links"/>
<xsl:if test="$rico='rico'">
    <script type="text/javascript" src="/js3p/prototype.js"></script>
    <script type="text/javascript" src="/js3p/rico.js"></script>
    <script type="text/javascript">
        window.onload=function(){new Rico.Accordion( $('ricoStructMap') )}
    </script>
</xsl:if>
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

<xsl:template match="insert-structMap">
<xsl:comment>insert-structMap <xsl:apply-templates select="@*" mode="attrComments"/></xsl:comment>
<xsl:choose>
  <xsl:when test="$structMap = 'alt2'">
<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="divNavAlt2"/>
  </xsl:when>
  <xsl:when test="$structMap = 'alt1'">
<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="divNavAlt1"/>
  </xsl:when>
  <xsl:when test="$rico = 'rico'">
<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="divNavRico"/>
  </xsl:when>
  <xsl:otherwise>
<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="divNavAlt2"/>
  </xsl:otherwise>
</xsl:choose>
<a href="/{$page/m:mets/@OBJID}/?structMap=alt1">alt1</a> |
<a href="/{$page/m:mets/@OBJID}/?rico=rico">rico</a> 
</xsl:template>

<xsl:template match="@*" mode="attrComments">
@<xsl:value-of select="name()"/> <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="insert-structMap-pagination">
</xsl:template>

<xsl:template match="insert-prevORDER">
<xsl:comment>insert-prevORDER</xsl:comment>
 <xsl:if test="$focusDiv/preceding::m:div/@LABEL[position()=last()]"> 
  <xsl:variable name="link">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/?order=</xsl:text>
	<xsl:value-of select="number($order) -1"/>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>
  </xsl:variable>
 <a href="{$link}">
<img src="http://oac.cdlib.org/images/previous.gif" width="72" height="22" border="0" alt="&lt;&lt; previous" class="prevNextButton" align="middle"/><br/>
	<xsl:value-of select="($focusDiv/preceding::m:div/@LABEL)[position()=last()]"/>
 </a>
 </xsl:if>
</xsl:template>

<xsl:template match="insert-nextORDER">
<xsl:comment>insert-nextORDER</xsl:comment>
 <xsl:if test="$focusDiv/following::m:div/@LABEL">
  <xsl:variable name="link">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/?order=</xsl:text>
	<xsl:value-of select="number($order) +1"/>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>
  </xsl:variable>
 <a href="{$link}">
<img src="http://oac.cdlib.org/images/next.gif" width="51" height="22" border="0" alt="next &gt;&gt;" class="prevNextButton" align="middle"/><br/>
 <xsl:value-of select="$focusDiv/following::m:div[1]/@LABEL"/>
 </a>
 </xsl:if>
</xsl:template>

<xsl:template match="insert-thisLABEL">
<xsl:comment>insert-thisLABEL</xsl:comment>
	<xsl:value-of select="$focusDiv/@LABEL"/>
</xsl:template>
  
<xsl:template match="insert-thisDiv">
<xsl:comment>insert-thisDiv</xsl:comment>
	<xsl:apply-templates select="$focusDiv" mode="divPage"/>
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
  
      
<xsl:template match="insert-imagePortion|insert-sm1">
<xsl:comment>insert-sm1|insert-imagePortion</xsl:comment>
	<xsl:if test="$debug">
		<div><img src="/{$page/m:mets/@OBJID}/thumbnail"/></div>
	</xsl:if>
	<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="structMap"/>
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
	<xsl:otherwise><xsl:text>reference</xsl:text></xsl:otherwise>
      </xsl:choose>
   </xsl:when>
   <xsl:otherwise/>
  </xsl:choose>
</xsl:variable>

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
	<a href="/{$page/m:mets/@OBJID}/dao">Click to view item</a>
    </xsl:when>
    <!-- special case for -->
    <xsl:when test="not($page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='hi-res'])">
	<a id="zoomMe" href="/{$page/m:mets/@OBJID}/{$use}">
  	<img  border="0"
		src="/{$page/m:mets/@OBJID}/{$use}" 
		width="{$xy/xy/@width}"
		height="{$xy/xy/@height}"
  	/></a>
    </xsl:when>
    <!-- the normal case -->
    <xsl:otherwise>
	<a id="zoomMe" href="/{$page/m:mets/@OBJID}/hi-res">
  	<img  border="0"
		src="/{$page/m:mets/@OBJID}/{$use}" 
		width="{$xy/xy/@width}"
		height="{$xy/xy/@height}"
  	/></a>
    </xsl:otherwise>
  </xsl:choose>
<xsl:call-template name="single-image-zoom"/>
  <!-- UCR Kmast -->
  <xsl:if test="$page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='stereo'] or
	         $page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='back']">
   <p>
   <xsl:if test="$page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='stereo']">
	<a href="/{$page/m:mets/@OBJID}/stereo">stereo view</a>
   </xsl:if>
   <xsl:if test="$page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='stereo'] and
	         $page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='back']">
	<xsl:text> | </xsl:text>
   </xsl:if>
   <xsl:if test="$page/m:mets/m:structMap/m:div/m:div/m:fptr[@FILEID='back']">
	<a href="/{$page/m:mets/@OBJID}/back">reverse side</a>
   </xsl:if>
   </p>
  </xsl:if>

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

<xsl:template match="m:structMap" mode="divNavAlt2">
	<xsl:apply-templates select="m:div[@ORDER][m:div]" mode="alt2"/>
</xsl:template>

<xsl:template match="m:div[@ORDER][m:div]" mode="alt2">
<div style="padding-left:4px">
<xsl:choose>
	<xsl:when test=". is $focusDiv">
		<xsl:value-of select="@LABEL"/>
	</xsl:when>
	<xsl:otherwise>
<a href="/{$this.base}/?order={count( preceding::m:div[@ORDER][m:div] | ancestor::m:div[@ORDER][m:div])+1}"><xsl:value-of select="@LABEL"/></a>
	</xsl:otherwise>
</xsl:choose>
<xsl:variable name="focusDivIsPreggers">
	<xsl:if test="$focusDiv/m:div/m:div/m:fptr">true</xsl:if> 
</xsl:variable>
<xsl:variable name="focusDivIsImage">
	<xsl:if test="$focusDiv/m:div/m:fptr">true</xsl:if> 
</xsl:variable>
<xsl:variable name="selfAction">
   <xsl:choose>
	<!-- xsl:when test="$order = '1'">tableIsNext</xsl:when -->
	<!-- I am the parent of the focus div, and -->
	<xsl:when test="(. is $focusDiv/..) 
		and not ($focusDivIsPreggers = 'true')
		and ($focusDivIsImage = 'true')">tableIsNext</xsl:when>
	<!-- I am the focus div, and I have kids with pictures -->
	<xsl:when test="(. is $focusDiv)
		and ($focusDivIsPreggers = 'true')">tableIsNext</xsl:when>
	<!-- one of my kids has the focus and content -->
	<xsl:when test="m:div[. is $focusDiv]
		and $focusDiv/m:div/m:fptr
		and not ($focusDivIsPreggers = 'true')">tableIsNext</xsl:when>
	<!-- follow the focus with recursion -->
	<xsl:when test=".//m:div[. is $focusDiv]">recurse</xsl:when>
	<!-- I am the focus div -->
	<xsl:when test=". is $focusDiv">recurse</xsl:when>
	<xsl:otherwise></xsl:otherwise>
 </xsl:choose>
</xsl:variable>
	<xsl:choose>
           <xsl:when test="$selfAction = 'tableIsNext'">
		<table border="0">
		  <xsl:apply-templates 
			select="m:div[@ORDER][m:div]" 
			mode="image-table"/>
		</table>
	  </xsl:when>
	  <xsl:when test="$selfAction = 'recurse'">
	<xsl:apply-templates select="m:div[@ORDER][m:div]" mode="alt2"/>
	  </xsl:when>
	  <xsl:otherwise><xsl:value-of select="$selfAction"/>
	<!-- xsl:apply-templates select="m:div[@ORDER][m:div]" mode="alt2"/ -->
	  </xsl:otherwise>
	</xsl:choose>
</div>
</xsl:template>

<xsl:template match="m:div[@ORDER][m:div]" mode="image-table">
<xsl:variable name="thisInCount" select="count( preceding-sibling::m:div[@ORDER][m:div])"/>
<xsl:variable name="node2" 
	select="following-sibling::m:div[@ORDER][m:div][1]"/>
<xsl:variable name="node3" 
	select="following-sibling::m:div[@ORDER][m:div][2]"/>

<xsl:choose>
 <xsl:when test="(($thisInCount) mod 3 = 0)">
  <tr>
	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="."/>
		<xsl:with-param name="number" 
			select="(count(preceding::m:div[@ORDER][m:div] | ancestor::m:div[@ORDER][m:div]) + 1)"/>
	  	<xsl:with-param name="pos" select="'left'"/>
	   </xsl:call-template>

	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="$node2"/>
		<xsl:with-param name="number" select="(count($node2/preceding::m:div[@ORDER][m:div] | $node2/ancestor::m:div[@ORDER][m:div]) + 1)"/>
	   </xsl:call-template>
	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="$node3"/>
		<xsl:with-param name="number" select="(count($node3/preceding::m:div[@ORDER][m:div] | $node3/ancestor::m:div[@ORDER][m:div]) + 1)"/>
	  	<xsl:with-param name="pos" select="'right'"/>
	   </xsl:call-template>
  </tr>
 </xsl:when>
 <xsl:otherwise/>
</xsl:choose>
</xsl:template>

<xsl:template match="m:structMap" mode="divNav">
<table border="0">
   <xsl:for-each select="1 to 20">
	<xsl:variable name="countPos" select="."/>
	<tr>
	   <xsl:call-template name="divNav">
		<xsl:with-param name="node" select="$page/key('absPos',$countPos)"/>
		<xsl:with-param name="number" select="."/>
	   </xsl:call-template>
	</tr>
   </xsl:for-each>
</table>
</xsl:template>

<xsl:template match="m:structMap" mode="divNavRico">
<div id="ricoStructMap">
	<xsl:apply-templates select="m:div/m:div" mode="ricoTab"/>
</div>
</xsl:template>

<xsl:template match="m:div" mode="ricoTab">
   <div>
	<div><xsl:value-of select="@LABEL"/></div>
<div>
	<div style="height:195px;overflow:auto">
<table border="0">
   <xsl:for-each select="1 to 12">
	<xsl:variable name="countPos" select="."/>
  <tr>
	   <xsl:call-template name="divNavRico">
	   <!-- xsl:call-template name="divNav" -->
		<xsl:with-param name="node" select="$page/key('absPosItem',$countPos)"/>
		<xsl:with-param name="number" select="."/>
	   </xsl:call-template>
  </tr>
   </xsl:for-each>
</table>
	</div>
</div>
   </div>
</xsl:template>

<xsl:template match="m:structMap" mode="sheet">
	<xsl:apply-templates select="m:div" mode="out-sheet"/>
</xsl:template>

<xsl:template match="m:structMap" mode="structMap2">
	<xsl:apply-templates select="m:div" mode="structMap2"/>
</xsl:template>

<!-- generic navigation from structMap div's -->
<xsl:template name="divNav">
   <xsl:param name="node"/>
   <xsl:param name="number"/>
   <xsl:variable name="imagePos" select="(count( $node/preceding-sibling::m:div[@ORDER][m:div]))"/>
   <xsl:choose>	
	<xsl:when test="not ($node)"/><!-- skip it -->
	<!-- heading with no metadata -->
	<xsl:when test="$node/@LABEL and not ($node/m:div/m:fptr) and not ($node/@DMDID)">
		<td colspan="3" align="center" valign="middle">
		   <xsl:if test="number($order) = number($number)">
			<xsl:attribute name="class" select="'on'"/>
		   </xsl:if>
	           <xsl:value-of select="$node/@LABEL"/>
		</td>
	</xsl:when>
	<!-- heading with metadata -->
	<xsl:when test="$node/@LABEL and not ($node/m:div/m:fptr) and ($node/@DMDID)">
		<td colspan="3">
		   <xsl:if test="number($order) = number($number)">
			<xsl:attribute name="class" select="'on'"/>
		   </xsl:if>
		<xsl:value-of select="$node/@LABEL"/>
		<xsl:text> </xsl:text>
		<a href="{$this.base}?order={$number}{$brandCgi}">[link]</a>
		</td>
	</xsl:when>
	<!-- row of images -->
	<xsl:when test="($node/m:div/m:fptr) and ($imagePos mod 3 = 0)">
		<xsl:call-template name="navThumb">
		   <xsl:with-param name="node" select="$node"/>
		   <xsl:with-param name="number" select="$number"/>
		   <xsl:with-param name="pos" select="'left'"/>
		</xsl:call-template>
		<xsl:call-template name="navThumb">
		   <xsl:with-param name="node" select="$page/key('absPos', ($number + 1) )"/>
		   <xsl:with-param name="number" select="$number + 1"/>
		</xsl:call-template>
		<xsl:call-template name="navThumb">
		   <xsl:with-param name="node" select="$page/key('absPos', ($number + 2) )"/>
		   <xsl:with-param name="number" select="$number + 2"/>
		   <xsl:with-param name="pos" select="'right'"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise/>
   </xsl:choose>	
</xsl:template>

<!-- generic navigation from structMap div's -->
<xsl:template name="divNavRico">
   <xsl:param name="node"/>
   <xsl:param name="number"/>
   <xsl:variable name="imagePos" select="(count( $node/preceding-sibling::m:div[@ORDER][m:div]))"/>
   <xsl:choose>	
	<xsl:when test="not ($node)"/><!-- skip it -->
	<!-- heading with metadata -->
	<!-- row of images -->
	<xsl:when test="($node/m:div/m:fptr) and ($imagePos mod 3 = 0)">
		<xsl:call-template name="navThumb">
		   <xsl:with-param name="node" select="$node"/>
		   <xsl:with-param name="number" select="$number"/>
		   <xsl:with-param name="pos" select="'left'"/>
		</xsl:call-template>
		<xsl:call-template name="navThumb">
		   <xsl:with-param name="node" select="$page/key('absPos', ($number + 1) )"/>
		   <xsl:with-param name="number" select="$number + 1"/>
		</xsl:call-template>
		<xsl:call-template name="navThumb">
		   <xsl:with-param name="node" select="$page/key('absPos', ($number + 2) )"/>
		   <xsl:with-param name="number" select="$number + 2"/>
		   <xsl:with-param name="pos" select="'right'"/>
		</xsl:call-template>
	</xsl:when>
	<xsl:otherwise/>
   </xsl:choose>	
</xsl:template>

<xsl:template name="navThumb">
   <xsl:param name="node"/><!-- div from structMap -->
   <xsl:param name="number"/><!-- order= source oroder of div -->
   <xsl:param name="pos"/><!-- left or right or blank -->
   <xsl:variable name="imagePos" select="(count( $node/preceding-sibling::m:div[m:div/m:fptr]))"/>
	<!-- need class="on" on td if this cell has an image in it -->
		<!-- pos=left will always have content -->
		<!-- $imagePos &gt; 0 will be true when other divs have content -->
   <td align="center" valign="middle">
	<xsl:choose>
	   <xsl:when test=" ( number($order) = number($number) and
				(  ($pos='left') or ( $imagePos &gt; 0 )  ) )
		">
		<xsl:attribute name="class" select="'on'"/>
	   </xsl:when>
	   <xsl:otherwise>
		<xsl:attribute name="class" select="'right'"/>
	   </xsl:otherwise>
	</xsl:choose>
   <xsl:choose>
     <xsl:when test="$node/m:div/m:fptr and ( ($imagePos &gt; 0) or ($pos = 'left') )">
 	<xsl:variable name="naillink">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$node/m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
        </xsl:variable>

 	<xsl:variable name="nailref">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/?order=</xsl:text>
           <xsl:value-of select="$number"/>
           <xsl:if test="$size">
           <xsl:text>&amp;size=</xsl:text>
           <xsl:value-of select="$size"/>
           <xsl:value-of select="$brandCgi"/>
           </xsl:if>
        </xsl:variable>

	<xsl:variable name="xy">
           <xsl:call-template name="scale-max">
           	<xsl:with-param name="max" select="number(65)"/>
           	<xsl:with-param name="x" select="$node/m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X"/>
           	<xsl:with-param name="y" select="$node/m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y"/>
           </xsl:call-template>
   	</xsl:variable>


	<a href="{$nailref}">
	<img border="0" width="{$xy/xy/@width}" height="{$xy/xy/@height}" src="{$naillink}"/>
	<br/>
	<xsl:value-of select="$node/@LABEL"/>
	</a>
     </xsl:when>
     <xsl:otherwise/>
   </xsl:choose>
   </td>
</xsl:template>

<xsl:template match="m:div" mode="sheet">
 	<xsl:variable name="naillink">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/</xsl:text>
           <xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
        </xsl:variable>

 	<xsl:variable name="nailref">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/?order=</xsl:text>
           <xsl:value-of select="count( preceding::m:div[m:div/m:fptr] | ancestor::m:div[m:div/m:fptr])+1"/>
           <xsl:if test="$size">
           <xsl:text>&amp;size=</xsl:text>
           <xsl:value-of select="$size"/>
           <xsl:value-of select="$brandCgi"/>
           </xsl:if>
        </xsl:variable>

	<xsl:variable name="xy">
           <xsl:call-template name="scale-max">
           	<xsl:with-param name="max" select="number(65)"/>
           	<xsl:with-param name="x" select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X"/>
           	<xsl:with-param name="y" select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y"/>
           </xsl:call-template>
   	</xsl:variable>


	<a href="{$nailref}">
	<img border="0" width="{$xy/xy/@width}" height="{$xy/xy/@height}" src="{$naillink}"/>
	<br/>
	<xsl:value-of select="@LABEL"/>
	</a>
</xsl:template>

<xsl:template match="m:div" mode="structMap2">
<div>
<xsl:choose>
 <xsl:when test="not(m:div/@ORDER)">
	<xsl:value-of select="@LABEL"/>
	<xsl:apply-templates mode="structMap2"/>
 </xsl:when>
<xsl:otherwise>
        <xsl:variable name="link">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/?order=</xsl:text>
        <xsl:value-of select="count( preceding::m:div[m:div/m:fptr] | ancestor::m:div[m:div/m:fptr])+1"/>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>
        </xsl:variable>

        <xsl:variable name="naillink">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
        </xsl:variable>

        <xsl:if test="@LABEL != $page/m:mets/@LABEL">
        <a href="{$link}"><xsl:value-of select="@LABEL"/>
        </a>
        </xsl:if>
 </xsl:otherwise>
</xsl:choose>
</div>
</xsl:template>

<xsl:template match="m:div" mode="triLevelStructMap">
<div>
	<xsl:choose>
	<xsl:when test="m:div/m:div/m:fptr or m:div/m:div/m:div/m:fptr">
		<h4><xsl:value-of select="@LABEL"/></h4>
		<xsl:apply-templates mode="triLevelStructMap"/>
	</xsl:when>
	<xsl:otherwise>
 	<xsl:variable name="link">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/?order=</xsl:text>
        <xsl:value-of select="count( preceding::m:div[m:div/m:fptr] | ancestor::m:div[m:div/m:fptr])+1"/>
        <xsl:if test="$size">
        <xsl:text>&amp;size=</xsl:text>
        <xsl:value-of select="$size"/>
        </xsl:if>
        </xsl:variable>

	<a href="{$link}"><img alt="[Online image]" width="17" border="0" height="14" src="http://oac.cdlib.org/images/image_icon.gif"/></a>
	<!-- xsl:if test="@LABEL != $page/m:mets/@LABEL" -->
        <a href="{$link}">
        <xsl:value-of select="@LABEL"/>
        </a>
        <!-- /xsl:if -->
	</xsl:otherwise>
</xsl:choose>
</div>
</xsl:template>

<xsl:template match="m:div" mode="structMap">
<div>
<xsl:choose>
 <!-- three level METS -->
 <xsl:when test="m:div/m:div/m:div/m:fptr">  
	<xsl:apply-templates mode="triLevelStructMap"/>
 </xsl:when>
 <!-- xsl:when test="not(m:div/m:fptr)" -->
 <xsl:when test="m:div/m:div/m:fptr">  
	<xsl:if test="@LABEL != $page/m:mets/@LABEL">
		<xsl:value-of select="@LABEL"/>
	</xsl:if>
	<xsl:choose>
	  <xsl:when test="count($page/m:mets/m:structMap/m:div/m:div[m:div]) &gt; 5">
		<xsl:apply-templates select="m:div[m:div][position() &lt; 6]" mode="structMap"/>
		<div><a href="/{$page/m:mets/@OBJID}/?sheet=1">more ...</a></div>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:apply-templates mode="structMap"/>
	  </xsl:otherwise>
	</xsl:choose>
 </xsl:when>
 <xsl:when test="$page/m:mets/m:structMap/m:div[@ORDER='1']/m:div/m:fptr 
		  and not ($page/m:mets/m:structMap/m:div[@ORDER='1']/m:div[@ORDER='1'])">
        <xsl:value-of select="@LABEL"/>
        <!-- xsl:copy-of select="./m:div[starts-with(@TYPE,'reference')][1]/m:fptr/@FILEID"/ -->
   	<xsl:variable name="link">
		<xsl:text>/</xsl:text><xsl:value-of select="$page/m:mets/@OBJID"/>
	   <xsl:choose>
		<xsl:when test="$size">
        		<xsl:text>/</xsl:text><xsl:value-of select="./m:div[starts-with(@TYPE,'reference')][$lsize]/m:fptr/@FILEID"/>
			<xsl:text>&amp;size=</xsl:text>
			<xsl:value-of select="$size"/>
		</xsl:when>
		<xsl:otherwise>
        		<xsl:text>/</xsl:text><xsl:value-of select="./m:div[starts-with(@TYPE,'reference')][1]/m:fptr/@FILEID"/>
		</xsl:otherwise>
	   </xsl:choose>
        </xsl:variable>

        <xsl:variable name="naillink">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
        </xsl:variable>

        <br/>
        <a href="{$link}"><img width="{m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X}" height="{m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y}" border="0" src="{$naillink}"/>
        </a><p>
<span class="listingTitle">View Options:</span><br/>
	<xsl:choose>
	  <xsl:when test="count($page/m:mets/m:fileSec/m:fileGrp[starts-with(@USE,'reference')]) &gt;= 2">
<a href="/{$page/m:mets/@OBJID}/{m:div[starts-with(@TYPE,'reference')][1]/m:fptr/@FILEID}">Medium Image</a><br/>
<a href="/{$page/m:mets/@OBJID}/{m:div[starts-with(@TYPE,'reference')][2]/m:fptr/@FILEID}">Large Image</a>
	  </xsl:when>
	  <xsl:when test="count($page/m:mets/m:fileSec/m:fileGrp[starts-with(@USE,'reference')]) = 1">
<a href="/{$page/m:mets/@OBJID}/{m:div[starts-with(@TYPE,'reference')]/m:fptr/@FILEID}">Large Image</a>
	  </xsl:when>
	  <xsl:otherwise>

	  </xsl:otherwise>
	</xsl:choose>
	</p>


 </xsl:when>
 <!-- these have an fptr? -->
 <xsl:otherwise>
	<xsl:variable name="link">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/?order=</xsl:text>
        <xsl:value-of select="count( preceding::m:div[m:div/m:fptr] | ancestor::m:div[m:div/m:fptr])+1"/>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>
	</xsl:variable>

	<xsl:variable name="naillink">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/</xsl:text>
	<xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
	</xsl:variable>

	<!-- xsl:if test="@LABEL != $page/m:mets/@LABEL" -->
	<a href="{$link}"><img border="0" width="{m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X}" height="{m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y}" src="{$naillink}"/>
	<br/>
	<xsl:value-of select="@LABEL"/>
	</a>
	<!-- /xsl:if -->
	<!-- xsl:apply-templates/ -->
 </xsl:otherwise>
</xsl:choose>
</div>
</xsl:template>
    
<xsl:template match="m:div" mode="structMap-j">
 	<xsl:variable name="link">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="m:div[starts-with(@TYPE,'reference')][$lsize]/m:fptr/@FILEID"/>
        </xsl:variable>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>

        <xsl:variable name="naillink">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
        </xsl:variable>

        <xsl:if test="@LABEL != $page/m:mets/@LABEL">
        <a href="{$link}"><img border="0" width="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X" height="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y" src="{$naillink}"/>
        <br/>
	<!-- xsl:copy-of select="."/ -->
        <xsl:value-of select="@LABEL"/>
        </a>
        </xsl:if>

</xsl:template>

<xsl:template match="m:div" mode="structMap-o">
<div>
<!-- xsl:choose>
 <xsl:when test="not(m:div/m:fptr)" >
	<xsl:if test="@LABEL != $page/m:mets/@LABEL">
	<xsl:value-of select="@LABEL"/>
	</xsl:if>
	<xsl:apply-templates mode="structMap"/>
 </xsl:when>
 <xsl:otherwise -->
	<xsl:variable name="link">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/</xsl:text>
	<xsl:value-of select="m:div[starts-with(@TYPE,'reference')][$lsize]/m:fptr/@FILEID"/>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>
	</xsl:variable>
	<xsl:variable name="naillink">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/</xsl:text>
	<xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
	</xsl:variable>
	<xsl:if test="@LABEL != $page/m:mets/@LABEL">
	<xsl:value-of select="@LABEL"/>
	<br/>
	</xsl:if>
	<a href="{$link}"><img src="{$naillink}"/></a>
	<p><span class="listingTitle">2 View Options:</span><br/>
        <xsl:apply-templates select="m:div[starts-with(m:fptr/@TYPE,'reference')]" mode="structMapLink"/>
        <xsl:apply-templates select="m:div[starts-with(@TYPE,'reference')]" mode="structMapLink"/>
        </p>

 <!-- /xsl:otherwise>
</xsl:choose -->
</div>
</xsl:template>

    
<xsl:template match="m:div" mode="divPage">
	<xsl:variable name="refImg">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/</xsl:text>
        <xsl:value-of select="m:div[starts-with(@TYPE,'reference')][position()=$lsize]/m:fptr/@FILEID"/>
        </xsl:variable>
	<!-- xsl:copy-of select="."/ -->
	<img src="{$refImg}" width="{m:div[starts-with(@TYPE,'reference')][position()=$lsize]/m:fptr/@cdl2:X}" height="{m:div[starts-with(@TYPE,'reference')][position()=$lsize]/m:fptr/@cdl2:Y}"/>
</xsl:template>

<xsl:template match="insert-imageToggle">
<xsl:comment>insert-imageToggle</xsl:comment>
	<xsl:choose>
		<xsl:when test="$lsize = 2">
		<a href="/{$page/m:mets/@OBJID}/?order={$order}">Smaller image</a>
		</xsl:when>
		<xsl:otherwise>
		<xsl:if test="count($page/m:mets/m:fileSec/m:fileGrp[starts-with(@USE,'reference')]) &gt;= 2">
			<a href="/{$page/m:mets/@OBJID}/?order={$order}&amp;size=2">Larger image</a>
		</xsl:if>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="insert-sheetLink">
<xsl:comment>insert-sheetLink</xsl:comment>
<xsl:variable name="link">
        <xsl:text>/</xsl:text>
        <xsl:value-of select="$page/m:mets/@OBJID"/>
        <xsl:text>/?sheet=</xsl:text>
        <xsl:value-of select="ceiling(number($order) div 25)"/>
        <xsl:if test="$size">
        <xsl:text>&amp;size=</xsl:text>
        <xsl:value-of select="$size"/>
        </xsl:if>
  </xsl:variable>

	<a href="{$link}">Thumbnail view</a>
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

    


<xsl:template match="insert-institution-url">
<xsl:comment>insert-institution-url</xsl:comment>
 <xsl:apply-templates
select="($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location/mods:physicalLocation" mode="mods"/>

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

<xsl:template match="insert-innerIframe"/>

<!-- calisphere image-complex -->

<!-- xsl:template match="insert-inner-paging">
<xsl:comment>insert-inner-paging</xsl:comment>
<xsl:choose>
  <xsl:when test="number($order) &lt;  0">
	<a href="?order={number($order) - 1}{$brandCgi}">previous</a>
  </xsl:when>
  <xsl:when test="number($order) = 1">
	<a href="?order={number($order) + 1}{$brandCgi}">next</a>
  </xsl:when>
  <xsl:otherwise>
	<a href="?order={number($order) - 1}{$brandCgi}">previous</a>
	<span class="bullet">|</span>
	<a href="?order={number($order) + 1}{$brandCgi}">next</a>
  </xsl:otherwise>
</xsl:choose>
</xsl:template -->

 
</xsl:stylesheet>
