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
                version="2.0"
		xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="#all">
<xsl:import href="./common/brandCommon.xsl"/>
<xsl:import href="./common/tracking.xsl"/>
<xsl:import href="./common/scaleImage.xsl"/>
<xsl:import href="./common/MODS-view.xsl"/>
<xsl:include href="multi-use.xsl"/>
<xsl:include href="structMap.xsl"/>
<xsl:include href="insert-print-link.xsl"/>
<xsl:param name="order" select="'1'"/><!-- defaults to first div with content -->
<xsl:param name="servlet.dir"/>
<xsl:param name="debug"/>
<xsl:param name="mode"/>
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

<xsl:variable name="av_content" select="if ($page/m:mets/@PROFILE='pamela://year1') then 'true' else ''"/>
<xsl:variable name="av_cdn" select="'http://av-cdn.calisphere.org/'"/>
<xsl:variable name="av_stream" select="'rtmp://av-stream.calisphere.org/cfx/st/'"/>

<xsl:param name="layout">
   <xsl:choose>
 	<xsl:when test="count(
                $page/m:mets/m:fileSec//m:fileGrp[starts-with(@USE,'thumbnail')][1]/m:file |
                $page/m:mets/m:fileSec//m:fileGrp/m:file[starts-with(@USE,'thumbnail')][1]
                ) = 1">
          <xsl:text>image-simple</xsl:text>
        </xsl:when>
        <xsl:when test="$av_content!=''">
          <xsl:text>metadata</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>image-complex</xsl:text>
        </xsl:otherwise>
   </xsl:choose>
</xsl:param>

<!-- xsl:output method="html"/ -->

<!-- xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/ -->

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

<xsl:template match="insert-audio" name="insert-audio">
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
        <xsl:apply-templates select="$page/m:mets/*[@xtf:meta]" mode="fullDC"/>
	<div><h2>Contributing Institution:</h2>
        <xsl:call-template name="insert-institution-url"/>
        </div>
        <xsl:if test="$creditExperiment.on='on'">
          <div>
            <h2>Persistent URL:</h2>
            http://content.cdlib.org/<xsl:value-of select="$page/m:mets/@OBJID"/>
          </div>
        </xsl:if>
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
<xsl:choose>
  <xsl:when test="$page/m:mets/@PROFILE='pamela://year1' and lower-case($page/m:mets/@TYPE)='sound'">
<link xmlns="" rel="stylesheet"
                  href="http://calispherel-dev.cdlib.org/avdemo/mediaelement/build/mediaelementplayer.css"></link>
		  <xsl:apply-templates select="$page/m:mets/m:structMap/m:div[1]/m:fptr[1]/@FILEID" mode="audio-element"/>
<xsl:apply-templates select="$page/m:mets/m:structMap/m:div[1]/m:fptr[position()&gt;1]/@FILEID" mode="audio-element-extra"/>
    <script><xsl:comment>
    // new MediaElementPlayer('audio',{mode:'shim'});
    // http://stackoverflow.com/questions/6190831/mediaelement-js-malfunction-in-ie-no-flashback-works
var opts = {
  /* enablePluginDebug: true,
  success: function(media, node, player) {
    if (media.pluginType == 'flash' &amp;&amp; node.getAttribute('data-rtmp')) {
      media.setSrc(node.getAttribute('data-rtmp'));
      media.load();
      media.play();
    }
  }, */
  audioWidth: 219, 
  pauseOtherPlayers: true, 
  features: ['playpause','progress','current','duration','tracks','volume','googleanalytics']
};
// ie9 needs this try/catch
// see: https://github.com/Modernizr/Modernizr/issues/224
try {
    // check if the native video player will work
    // http://stackoverflow.com/questions/3572113/how-to-check-if-the-browser-can-play-mp4-via-html5-video-tag
    var a = document.createElement('audio');
    if(! (a.canPlayType &amp;&amp; a.canPlayType('audio/mp3').replace(/no/, '')) ) {
      opts.mode = 'shim';
    }
} catch(e) { }
/*@cc_on
  @if (@_jscript_version == 9)
    opts.mode = 'shim';
  @end
@*/
$($('audio').mediaelementplayer(opts));
    </xsl:comment></script>
  </xsl:when>
  <!-- video thumbnail -->
  <xsl:when test="$page/m:mets/@PROFILE='pamela://year1'">
    <xsl:variable name="use" select="'thumbnail'"/>
      <xsl:choose>
       <xsl:when test="@use = 'thumbnail'">
        <xsl:variable name="ext" select="res:getExt($page/key('md',$use)/m:FLocat[1]/@xlink:href)" xmlns:res="x-hack:res"/>
        <xsl:variable name="xy">
          <xsl:call-template name="scale-maxXY">
            <xsl:with-param name="maxX" select="@maxX"/>
            <xsl:with-param name="maxY" select="@maxY"/>
            <xsl:with-param name="x" select="number(($page/m:mets/m:structMap//m:div/m:fptr[@FILEID=$use])[1]/@cdl2:X)"/>
            <xsl:with-param name="y" select="number(($page/m:mets/m:structMap//m:div/m:fptr[@FILEID=$use])[1]/@cdl2:Y)"/>
          </xsl:call-template>
        </xsl:variable>
        <a id="zoomMe" href="/{$page/m:mets/@OBJID}/?layout=printable-details{if($brand!='calisphere') then concat('&amp;brand=',$brand) else ''}" style="text-decoration: none; display: block; position:relative;">
          <div><img  border="0"
	    src="/{$page/m:mets/@OBJID}/{$use}{$ext}" 
	    width="{$xy/xy/@width}"
	    height="{$xy/xy/@height}"
        /></div>
        <div class="play" style="position: absolute; color: #000;
      top: 40px;
      left: 100px;
      margin: auto;
      width: 2em; 
      line-height:2em;  
      border: 1px solid;
      background: #FFFFFF; opacity:0.6;filter:alpha(opacity=60)">▶</div>
    </a>
      </xsl:when>
      <!-- insert video -->
      <xsl:otherwise>
        <xsl:variable name="data-setup">
          <xsl:text>{'techOrder': ['flash', 'html5']}</xsl:text>
        </xsl:variable>
<link rel="stylesheet" href="http://calispherel-dev.cdlib.org/avdemo/mediaelement/build/mediaelementplayer.css" />
<div align="center">
<xsl:apply-templates select="$page/m:mets/m:structMap/m:div[1]/m:fptr[1]/@FILEID" mode="video-element"/>
<xsl:apply-templates select="$page/m:mets/m:structMap/m:div[1]/m:fptr[position()&gt;1]/@FILEID" mode="video-element-extra"/>
<script><xsl:comment>
var opts = {
  // http://stackoverflow.com/questions/9113633/replacing-media-source-http-with-rtmp-in-mediaelementsjs-based-on-browser-capa
  success: function(media, node, player) {
    if (media.pluginType == 'flash' &amp;&amp; node.getAttribute('data-rtmp')) {
      media.setSrc(node.getAttribute('data-rtmp'));
      media.load();
      media.play();
    }
  }, 
  features: ['playpause','progress','current','duration','tracks','volume','fullscreen' ,'googleanalytics'],
  pauseOtherPlayers: true,
};
if(FlashDetect.installed){
  opts.mode='shim';
}
$($('video').mediaelementplayer(opts));
</xsl:comment></script>
</div>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:when>
  <xsl:when test="count($page/m:mets/m:fileSec/m:fileGrp//m:file[@USE='thumbnail' or @ID='thumbnail']) = 1">
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
	  <xsl:otherwise>
		<xsl:text>hi-res</xsl:text>
	  </xsl:otherwise>
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
<a id="zoomMe" href="/{$page/m:mets/@OBJID}/hi-res">
  <img  border="0"
	src="/{$page/m:mets/@OBJID}/{$use}{$ext}" 
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
   <img
         src="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference')][position()=1]/m:fptr/@FILEID}"
         width="{$xy/xy/@width}"
         height="{$xy/xy/@height}"
         border="0"
   /></a>
    </xsl:otherwise>

</xsl:choose>
</xsl:template>

<xsl:template match="@FILEID" mode="video-element">
  <video controls="controls" width="640" height="480" preload="metadata" src="{$av_cdn}{.}" type="video/mp4" data-rtmp="{$av_stream}mp4:{.}">
  </video>
</xsl:template>

<xsl:template match="@FILEID" mode="video-element-extra">
  <video controls="controls" width="640" height="480" preload="metadata" src="{$av_cdn}{.}" type="video/mp4" data-rtmp="{$av_stream}mp4:{.}">
  </video>
</xsl:template>

<xsl:template match="@FILEID" mode="audio-element">
    <audio src="{$av_cdn}{.}" type="audio/mpeg"
      width="219" controls="controls" preload="none" data-rtmp="{$av_stream}mp3:{.}">
    </audio>
</xsl:template>

<xsl:template match="@FILEID" mode="audio-element-extra">
    <audio src="{$av_cdn}{.}" type="audio/mpeg" data-rtmp="{$av_stream}mp3:{.}"
      width="219" controls="controls" preload="none">
    </audio>
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
    <xsl:otherwise>

    <xsl:for-each select="$page/mets:mets/mets:dmdSec[@ID='repo']">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:identifier[2]"/>
        </xsl:attribute>
        <xsl:value-of select="mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
      </a>
    </xsl:for-each>
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
    <xsl:otherwise>
    <xsl:for-each select="$page/mets:mets/mets:dmdSec[@ID='repo']">
        <xsl:value-of select="mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
    </xsl:for-each>
    </xsl:otherwise>
  </xsl:choose>
</xsl:template>

<!-- calisphere design -->

<xsl:template match="insert-sitesearch">
<xsl:comment>insert-sitesearch</xsl:comment>
<!-- set up variables, fill out template  -->
<xsl:copy-of select="$brand.search.box"/>
</xsl:template>

<xsl:template match="insert-innerIframe">
<xsl:comment>insert-innerIframe</xsl:comment>
	<xsl:if test="not($order = '1')">
		<div><h2>Title:</h2>
		<xsl:value-of select="$focusDiv/@LABEL"/>
		</div>
		<hr/>
		<h1>From:</h1>
	</xsl:if>
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
                <div><h2>Contributing Institution:</h2><xsl:call-template name="insert-institution-url"/>
								</div>
            </div>
</div>
</xsl:template>


</xsl:stylesheet>
