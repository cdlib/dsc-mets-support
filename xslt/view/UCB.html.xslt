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
<xsl:import href="./common/google-tracking.xsl"/>
<xsl:import href="./common/MODS-view.xsl"/>
<xsl:include href="structMap.xsl"/>
<xsl:include href="multi-use.xsl"/>
<xsl:include href="insert-print-link.xsl"/>
<xsl:param name="order" select="'1'"/><!-- defaults to first div with content -->
<xsl:param name="debug"/>
<xsl:param name="brand" select="'calisphere'"/>
<xsl:param name="servlet.dir"/>
<xsl:param name="doc.view"/>

<!-- xsl:key name="thumbCount" match="m:fileGrp[contains(@USE,'thumbnail')][1]/m:file"
use="'count'"/ -->
<!-- test for pdf PDF -->
<xsl:variable name="isPdf" select="boolean(
	count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'application')]/m:file[@MIMETYPE='application/pdf']) = 1
	or count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'Application-PDF')]) = 1
                                          )"/>

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
  <!-- xsl:key name="divIsImage" match="m:div[m:div/m:fptr]">
    <xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
  </xsl:key -->
  <!-- xsl:key name="divShowsChild" match="m:div[m:div/m:div/m:fptr]">
    <xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
  </xsl:key>
  <xsl:key name="divChildShowsChild"  match="m:div[m:div/m:div/m:div/m:fptr]">
    <xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
  </xsl:key -->
  
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
	<xsl:if test="$doc.view">
	  <xsl:text>&amp;doc.view=</xsl:text>
	  <xsl:value-of select="$doc.view"/>
	</xsl:if>
  </xsl:variable>
<xsl:variable name="focusDiv" select="key('absPos',$order)"/>

	<xsl:variable name="lsize">
	<xsl:choose>
		<xsl:when test="$size"><xsl:value-of select="$size"/></xsl:when>
		<xsl:otherwise>1</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

  <xsl:variable name="page" select="if (/TEI.2) then /TEI.2 else /"/>
<!-- template specifies .xhtml template file -->
<xsl:param name="layout">
   <xsl:choose>
	<!-- test for PDF -->
	<xsl:when test="$isPdf">
	  <xsl:text>metadata</xsl:text>
  </xsl:when>
	<!-- xsl:when test="count(key('thumbCount','count')) = 1" --> 
	<xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'thumbnail')][1]/m:file) = 1"> 
	  <xsl:text>image-simple</xsl:text>
  </xsl:when>
	<xsl:otherwise>
	  <xsl:text>image-complex</xsl:text>
	</xsl:otherwise>
   </xsl:choose>
</xsl:param>

<xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" omit-xml-declaration="yes" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" indent="yes" method="xhtml" media-type="text/html"/>

  <!-- $page has the METS, $template has HTML and template tags -->
<xsl:variable name="fLayout"   select="replace($layout,'[^\w]','-')"/>
<xsl:variable name="layoutXML" select="document(concat($fLayout,'.xhtml'))"/>

  <!-- default match identity transform -->
  <xsl:template match="@*|node()">
    <!-- xsl:namespace name="" select="'http://www.w3.org/1999/xhtml'"/ -->
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="insert-metadataPortion" name="insert-metadataPortion">
<!-- image-simple metadata printable-details -->
<xsl:comment>insert-metadataPortion (image-simple)</xsl:comment>
 <xsl:choose>
  <xsl:when test="($page/mets:mets/*/@xtf:meta or $page/../TEI.2/xtf:meta or $page/TEI.2/xtf:meta) and not($layout='metadata') and not($layout='iframe')">
	<xsl:comment>@xtf:meta found</xsl:comment>
	<xsl:apply-templates select="$page/m:mets/*[@xtf:meta] | $page/../TEI.2/xtf:meta/* | $page/TEI.2/xtf:meta/*" mode="briefMeta"/>
	<div><h2>Contributing Institution:</h2>
	<xsl:call-template name="insert-institution-name"/></div>
  </xsl:when>
  <xsl:when test="$layout = 'printable-details'">
        <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
  </xsl:when>
  <xsl:otherwise>
	<xsl:if test="$layout != 'metadata' and $layout != 'iframe'"><xsl:comment>@xtf:meta not found</xsl:comment></xsl:if>
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

<!-- xsl:variable name="count-hack" select="if ($mrsid-hack) number($mrsid-hack)
																				else if ($page/m:mets/meta) number(1)
																				else number(0)"/ -->

   <xsl:choose>
	 <!-- test for a pdf -->
   <xsl:when test="boolean($isPdf)">
                   <xsl:if test="
    count($page/m:mets/m:fileSec//m:fileGrp[contains(lower-case(@USE),'application')]/m:file) = 1
    ">
    <!-- change second test to FileExists -->
			<a href="/{$page/m:mets/@OBJID}/{($page/m:mets/m:fileSec//m:fileGrp[contains(lower-case(@USE),'application')]/m:file[@MIMETYPE='application/pdf'])[1]/@ID}">Download PDF</a> (<xsl:value-of select="
	FileUtils:humanFileSize(
		(($page/m:mets/m:fileSec//m:fileGrp[contains(lower-case(@USE),'application')]/m:file)[1]/@SIZE)
		)"/>)

<!-- image/thumbnail -->

  <xsl:variable name="use" select="'thumbnail'"/>
  <xsl:if test="$page/m:mets/m:structMap//m:div[contains(@TYPE,$use)]">
  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="@maxX"/>
      <xsl:with-param name="maxY" select="@maxY"/>
      <xsl:with-param name="x" select="number(($page/m:mets/m:structMap//m:div[contains(@TYPE,$use)])[1]/m:fptr/@cdl2:X)"/>
      <xsl:with-param name="y" select="number(($page/m:mets/m:structMap//m:div[contains(@TYPE,$use)])[1]/m:fptr/@cdl2:Y)"/>
    </xsl:call-template>
  </xsl:variable>


			<a href="/{$page/m:mets/@OBJID}/{($page/m:mets/m:fileSec//m:fileGrp[contains(lower-case(@USE),'application')]/m:file)[1]/@ID}">
  <xsl:variable 
    name="myFileId" 
    select="$page/m:mets/m:structMap//m:div[starts-with(@TYPE,$use) or @TYPE=concat('image/',$use)][1]/m:fptr/@FILEID"
  />
  <xsl:variable name="ext" select="res:getExt($page/key('md',$myFileId)/m:FLocat[1]/@xlink:href)" xmlns:res="x-hack:res"/>
  <img  border="0"
	src="/{$page/m:mets/@OBJID}/{$myFileId}{$ext}" alt="Larger Image"
	width="{$xy/xy/@width}"
	height="{$xy/xy/@height}"
  /></a>
            </xsl:if><!-- - - - - -->
            <!-- xsl:if test="$page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'Application-PDF')]">
                <xsl:apply-templates select="$page/key('md',$focusDiv/m:div/m:fptr/@FILEID)/m:FLocat" mode="dataLink"/>
            </xsl:if --><!-- - - - - -->
      </xsl:if><!-- end of if thumnail -->
   </xsl:when><!-- end of when pdf -->
   <xsl:when test="count($page/m:mets/m:fileSec//m:fileGrp[contains(@USE,'thumbnail')][1]/m:file) = 1"><!-- simple object -->

  <xsl:variable name="use" select="@use"/>
  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="@maxX"/>
      <xsl:with-param name="maxY" select="@maxY"/>
      <xsl:with-param name="x" select="number(($page/m:mets/m:structMap[1]//m:div[contains(@TYPE,$use)])[1]/m:fptr/@cdl2:X)"/>
      <xsl:with-param name="y" select="number(($page/m:mets/m:structMap[1]//m:div[contains(@TYPE,$use)])[1]/m:fptr/@cdl2:Y)"/>
    </xsl:call-template>
  </xsl:variable>

  <xsl:variable name="largerImageLink">
<xsl:text>/</xsl:text>
<xsl:value-of select="$page/m:mets/@OBJID"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="$page/m:mets/m:structMap[1]//m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=(last() - number($mrsid-hack))]/m:fptr/@FILEID"/>
  </xsl:variable>
<a id="zoomMe" href="{$largerImageLink}" title="Larger Image">
  <xsl:variable name="myFileId" select="$page/m:mets/m:structMap[1]//m:div[starts-with(@TYPE,$use) or @TYPE=concat('image/',$use)][1]/m:fptr/@FILEID"/>
  <xsl:variable name="ext" select="res:getExt($page/key('md',$myFileId)/m:FLocat[1]/@xlink:href)" xmlns:res="x-hack:res"/>
  <img  border="0"
	src="/{$page/m:mets/@OBJID}/{$myFileId}{$ext}" alt="Larger Image"
	width="{$xy/xy/@width}"
	height="{$xy/xy/@height}"
  /></a>

<xsl:call-template name="single-image-zoom"/>

   </xsl:when>
   <xsl:otherwise><!-- page in a complex object -->

	<xsl:variable name="thisImage" select="$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=1]"/>

  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="'512'"/>
      <xsl:with-param name="maxY" select="'800'"/>
      <xsl:with-param name="x" select="number($thisImage/m:fptr/@cdl2:X)"/>
      <xsl:with-param name="y" select="number($thisImage/m:fptr/@cdl2:Y)"/>
    </xsl:call-template>
  </xsl:variable>
  <a href="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=(last() - number($mrsid-hack))]/m:fptr/@FILEID}">
  <img
        src="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=1]/m:fptr/@FILEID}"
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
      <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/*/dc:identifier[2]"/>
    </xsl:attribute>
    <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']/mets:xmlData/*/dc:title"/>
  </a>
  </xsl:when>
  <xsl:otherwise>
 	<xsl:apply-templates
	  select="($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location[1]/mods:physicalLocation[1] |
		  ($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:relatedItem[@type='original']/mods:location[1]/mods:physicalLocation[1]" 
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
	<xsl:variable name="modsLocation" select="if (($page//mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location[1]/mods:physicalLocation[1]) then (($page//mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location[1]/mods:physicalLocation[1]) else ($page//mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:relatedItem[@type='original']/mods:location[1]/mods:physicalLocation[1]"/>
 	<xsl:value-of
	  select="
		replace(normalize-space($modsLocation) , '\(?http://.*$' , '')" 
	/>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<!-- calisphere design -->

<!-- toggel back to TEI view; launch other media -->
<xsl:template match="insert-LaunchPad" name="insert-LaunchPad">
<xsl:comment>insert-LaunchPad</xsl:comment>
 <xsl:if test="$page/../TEI.2 or $page/m:mets/m:fileSec/m:fileGrp[@USE='video/reference']">
 <!-- xsl:if test="$page/../TEI.2 or $focusDiv/m:div[@TYPE='video/reference']" -->
      <div id="{@class}" class="nifty4">
          <div class="box4">
		<xsl:choose>
		  <xsl:when test="$page/../TEI.2">
               		<table>
                   	 <tr>
	    		   <td><a href="/{$page/m:mets/@OBJID}?brand={$brand}">view transcription</a></td>
			   <td class="pipe-spacing">|</td>
           		   <td>scanned version</td>
                        </tr>
                     </table>
		  </xsl:when>
		  <!-- xsl:when test="$page/m:mets/m:structMap/m:div//m:div[@TYPE='video/reference']" -->
		  <xsl:when test="$page/m:mets/m:fileSec/m:fileGrp[@USE='video/reference']">
		  <!-- xsl:when test="$focusDiv/m:div[@TYPE='video/reference']" -->
			<table>
                        <tr>
				   <td class="spacer"><!-- qtvr QTVR -->
					<a href="/{$page/m:mets/@OBJID}/?layout=quicktime-object&amp;{$brandCgi}">rotate 360&#xb0;</a> (quicktime required)
                           </td>
						</tr>
                     </table>
		  </xsl:when>
		</xsl:choose>
          </div>
        </div> 
  </xsl:if>
</xsl:template>

<!-- calisphere quicktime-object -->

<xsl:template match="insert-quicktimeObject">
<xsl:comment>insert-quicktimeObject</xsl:comment>
<xsl:variable name="qtFile">
  <xsl:text>/</xsl:text>
  <xsl:value-of select="$page/m:mets/@OBJID"/>
  <xsl:text>/</xsl:text>
  <xsl:value-of select="$page/m:mets/m:structMap/m:div/m:div[@TYPE='video/reference'][1]/m:fptr[1]/@FILEID"/>
</xsl:variable>
<xsl:variable name="fid" select="$page/m:mets/m:structMap/m:div/m:div[@TYPE='video/reference'][1]/m:fptr[1]/@FILEID"/>
<xsl:variable name="qtFileDirect" select="$page/m:mets/m:fileSec//m:file[@ID = $fid]/m:FLocat[1]/@xlink:href"/>
<xsl:variable name="qtX" select="number($page/m:mets/m:structMap/m:div/m:div[@TYPE='video/reference'][1]/m:fptr[1]/@cdl2:X)"/>
<xsl:variable name="qtY" select="number($page/m:mets/m:structMap/m:div/m:div[@TYPE='video/reference'][1]/m:fptr[1]/@cdl2:Y) + 10"/>

<script language="JavaScript" type="text/javascript">
<xsl:comment>
 QT_WriteOBJECT_XHTML('<xsl:value-of select="$qtFileDirect"/>',
       '<xsl:value-of select="$qtX"/>',
       '<xsl:value-of select="$qtY"/>',
       '',
         'autoplay','true',
         'controller','true',
         'pluginspage','http://www.apple.com/quicktime/download/'
 );


<!-- AC_AX_RunContent( 'classid','clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B','width','<xsl:value-of select="$qtX"/>','height','<xsl:value-of select="$qtY"/>','codebase','http://www.apple.com/qtactivex/qtplugin.cab','src','<xsl:value-of select="$qtFileDirect"/>','autoplay','true','controller','true','pluginspage','http://www.apple.com/quicktime/download/' ); //end AC code  -->
// </xsl:comment>
</script>
<noscript>
<object CLASSID="clsid:02BF25D5-8C17-4B23-BC80-D3488ABDDC6B" width="{$qtX}" height="{$qtY}"  CODEBASE="http://www.apple.com/qtactivex/qtplugin.cab">
<param name="SRC" VALUE="{$qtFileDirect}"/>
<param name="CONTROLLER" VALUE="true"/>
<param name="AUTOPLAY" VALUE="true"/>
<embed src="{$qtFileDirect}" width="{$qtX}" height="{$qtY}" autoplay="true" controller="true" PLUGINSPAGE="http://www.apple.com/quicktime/download/"></embed>
</object>
</noscript>

</xsl:template>

<!-- calisphere image-simple -->
<xsl:template match="insert-largerImageLink">
<!-- saving this for 500x400 1200x1000 type image size options -->
</xsl:template>

<!-- calisphere image-complex -->

<xsl:template match="m:mdRef" mode="link">
<div>
	<xsl:if test="position()=1"><h2>Collection:</h2></xsl:if>
	<a href="{@*[local-name()='href']}{$brandCgi}"><xsl:value-of select="@LABEL"/></a>
</div>
</xsl:template>


</xsl:stylesheet>
