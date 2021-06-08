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
                version="2.0"
		xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="#all">
<xsl:import href="./common/brandCommon.xsl"/>
<xsl:import href="./common/google-tracking.xsl"/>
<xsl:import href="./common/scaleImage.xsl"/>
<xsl:import href="./common/MODS-view.xsl"/>
<!-- xsl:include href="multi-use.xsl"/ -->
<xsl:include href="structMap.xsl"/>
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
<xsl:param name="layout" select="'removed'"/>


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

<xsl:template match="insert-metadata">
<xsl:apply-templates select="$page/mets:mets/mets:dmdSec[1]/mets:mdWrap[1]/mets:xmlData[1]/qdc/*" mode="fullDC"/>
</xsl:template>

<xsl:template match="insert-metadataB">
<xsl:apply-templates select="$page/mets:mets/mets:dmdSec[1]/mets:mdWrap[1]/mets:xmlData[1]/qdc/*" mode="fullDC"/>
</xsl:template>

<xsl:template match="@*" mode="attrComments">
@<xsl:value-of select="name()"/> <xsl:value-of select="."/>
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
	<xsl:otherwise>
		<xsl:text>hi-res</xsl:text>
	</xsl:otherwise>
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
<a href="/{$page/m:mets/@OBJID}/hi-res">
  <img  border="0"
	src="/{$page/m:mets/@OBJID}/{$use}" 
	width="{$xy/xy/@width}"
	height="{$xy/xy/@height}"
  /></a>
</xsl:template>


<xsl:template match="insert-institution-url" name="insert-institution-url">
    <xsl:for-each select="$page/mets:mets/mets:dmdSec[@ID='repo']">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:identifier[2]"/>
        </xsl:attribute>
        <xsl:value-of select="mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
      </a>
    </xsl:for-each>
  </xsl:template>

<xsl:template match="insert-institution-name" name="insert-institution-name">
    <xsl:for-each select="$page/mets:mets/mets:dmdSec[@ID='repo']">
        <xsl:value-of select="mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
    </xsl:for-each>
  </xsl:template>

<!-- calisphere design -->

<xsl:template match="insert-sitesearch">
<xsl:comment>insert-sitesearch</xsl:comment>
<!-- set up variables, fill out template  -->
<xsl:copy-of select="$brand.search.box"/>
</xsl:template>

<xsl:template match="insert-suggestSearch">
<p>We're sorry, the item identifed as 
<b><xsl:value-of select="$page/mets:mets/@OBJID"/></b> has been 
removed.
</p>

<div>
               
               <div>
                  
                  <div>
                     
                     <form action="/search" class="search-form" name="searchFormAuto" method="get" id="searchFormAuto" target="_top">
                        <input type="hidden" name="facet" value="type-tab" />
                        <input type="hidden" name="relation" value="calisphere.universityofcalifornia.edu"/>
                        <input type="hidden" name="style" value="cui" />
                        <input name="newKeyword" type="text" class="text-field" size="40" />

                        <input type="image" src="http://www.calisphere.universityofcalifornia.edu/images/buttons/search-grn_wht_bg.gif" class="search-button" alt="Search" title="Search" />
                        
                     </form>
                     <script type="text/javascript" language="JavaScript"></script>
                     </div>
                  
               </div>
               
            </div>
</xsl:template>

<xsl:template match="insert-inner-metadata">
<xsl:comment>insert-inner-metadata</xsl:comment>
<div id="{@css-id}" class="nifty1" xmlns="http://www.w3.org/1999/xhtml">
            <div class="metadata-text">
        <xsl:if test="not($order = '1')">
		<div><h2>Title:</h2>
		<xsl:value-of select="$focusDiv/@LABEL"/>
		</div>
		<div><h2>From:</h2>
                <a href="/{$page/m:mets/@OBJID}?{$brandCgi}"><xsl:value-of select="$page/mets:mets/@LABEL"/></a>
		</div>
                <xsl:apply-templates select="$page/m:mets/relation-from[@xtf:meta]" mode="fullDC"/>
        </xsl:if>
        <xsl:if test="$order = '1'">
                <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
        </xsl:if>
								<div>
                <h2>Contributing Institution:</h2><xsl:call-template name="insert-institution-url"/>
								</div>
            </div>
</div>
</xsl:template>

<xsl:template match="title[1][text()]| contributor[1][text()]| description[@q='abstract'][text()][1]| date[1][text()]"  mode="briefMeta">
<p>
	<h2>
	<xsl:value-of select="upper-case(substring(local-name(),1,1))"/>
	<xsl:value-of select="substring(local-name(),2,string-length(local-name()))"/>
	<xsl:text>:</xsl:text>
	</h2>
	<xsl:text> </xsl:text><xsl:value-of select="."/>
</p>
</xsl:template>

<xsl:template match="title| contributor" mode="briefMeta">
	<p><xsl:apply-templates mode="magic"/></p>
</xsl:template>

<xsl:template match="date" mode="briefMeta">
</xsl:template>

<xsl:template match="*" mode="briefMeta">
</xsl:template>

<xsl:template match="title[1][text()]| creator[1][text()]| subject[not(@q='series')][1][text()]| description[1][text()]| publisher[1][text()]| contributor[1][text()]| date[1][text()]| type[@q][1][text()]| format[1][text()]| identifier[1][text()]| source[1][text()]| language[1][text()]| coverage[1][text()]| rights[1][text()]"
	mode="fullDC">
<p>
	<h2>
	<xsl:value-of select="upper-case(substring(local-name(),1,1))"/>
	<xsl:value-of select="substring(local-name(),2,string-length(local-name()))"/>
	<xsl:text>:</xsl:text>
	</h2><xsl:text> </xsl:text>
<xsl:variable name="apos">&apos;</xsl:variable>
<xsl:variable name="quot">&quot;</xsl:variable>
<xsl:variable name="lparen">(</xsl:variable>
<xsl:variable name="rparen">)</xsl:variable>
<xsl:variable name="fm">
	<xsl:text>[</xsl:text>
	<xsl:value-of select="$apos"/>
	<xsl:text>|</xsl:text>
	<xsl:value-of select="$quot"/>
	<xsl:text>|</xsl:text>
	<xsl:value-of select="$lparen"/>
	<xsl:text>|</xsl:text>
	<xsl:value-of select="$rparen"/>
	<xsl:text>]</xsl:text>
</xsl:variable>
<xsl:variable name="this">
	<xsl:value-of select="replace(normalize-space(.), $fm,' ')"/>
</xsl:variable> 
<xsl:variable name="js">
<xsl:text>window.document.searchFormAuto.newKeyword.value=&apos;</xsl:text>
<xsl:value-of select="$this"/>
<xsl:text>&apos;</xsl:text>
</xsl:variable> 
	<s><a onMouseOver="{$js}"><xsl:apply-templates mode="magic"/></a></s></p>
</xsl:template>



<xsl:template match="title| creator| description| contributor| date| 
	format| identifier| source| language| coverage| rights| subject"
	mode="fullDC">
<xsl:variable name="apos">&apos;</xsl:variable>
<xsl:variable name="quot">&quot;</xsl:variable>
<xsl:variable name="lparen">(</xsl:variable>
<xsl:variable name="rparen">)</xsl:variable>
<xsl:variable name="fm">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="$apos"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$quot"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$lparen"/>
        <xsl:text>|</xsl:text>
        <xsl:value-of select="$rparen"/>
        <xsl:text>]</xsl:text>
</xsl:variable>
<xsl:variable name="this">
        <xsl:value-of select="replace(normalize-space(.), $fm,'')"/>
</xsl:variable>
<xsl:variable name="js">
<xsl:text>window.document.searchFormAuto.newKeyword.value=&apos;</xsl:text>
<xsl:value-of select="$this"/>
<xsl:text>&apos;</xsl:text>
</xsl:variable>
        <p><s><a onMouseOver="{$js}"><xsl:apply-templates mode="magic"/></a></s></p>
</xsl:template>

<xsl:template match="subject[@q='series']" mode="fullDC">
</xsl:template>

<xsl:template match="subject[@q='series']" mode="subjectSeries">
	<xsl:value-of select="."/>
	<xsl:if test="following-sibling::subject[@q='series']">
		<xsl:text>, </xsl:text>
	</xsl:if>
</xsl:template>

<xsl:template match="subject">
	<p><xsl:apply-templates mode="magic"/></p>
</xsl:template>

<xsl:template match="relation-from" mode="fullDC">
<p><h2>Collection:</h2><xsl:text> </xsl:text>
<xsl:variable name="in-url" select="substring-before(.,'|')"/>
<xsl:variable name="out-url">
   <xsl:choose>
	<xsl:when test="matches($in-url,'.*oac\.cdlib\.org.*')">
		<xsl:value-of select="$in-url"/>
		<xsl:text>?</xsl:text>
		<xsl:value-of select="$brandCgi"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:value-of select="$in-url"/>
	</xsl:otherwise>
   </xsl:choose>
</xsl:variable>
<a href="{$out-url}"><xsl:value-of select="substring-after(.,'|')"/></a>
</p>
</xsl:template>

<xsl:template match="*" mode="fullDC">
</xsl:template>

<!-- magic to link things that end in http://a.link -->
<xsl:template match="text()" mode="magic">
        <xsl:variable name="string">
		<xsl:value-of select="."/>
		<!-- xsl:value-of select="upper-case(substring(.,1,1))"/>
        	<xsl:value-of select="substring(.,2,string-length(.))"/ -->
        </xsl:variable>
        <xsl:choose>
                <xsl:when test="substring-after($string,'http://')">
			<xsl:if test="substring-before(normalize-space($string),'http://')">
                        <xsl:value-of select="substring-before(normalize-space($string),'http://')"/>
			<br/>
			</xsl:if>
                        <a href="http://{substring-after(normalize-space($string),'http://')}">
			<xsl:text>http://</xsl:text>
                        <xsl:value-of select="substring-after(normalize-space($string),'http://')"/>
                        </a>
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="$string"/>
                </xsl:otherwise>
        </xsl:choose>
</xsl:template>

<xsl:template name="insert-metadataPortion"/>

</xsl:stylesheet>
