<xsl:stylesheet
   version="2.0"
   xmlns:view="http://www.cdlib.org/view"
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns:mets="http://www.loc.gov/METS/"
   xmlns:m="http://www.loc.gov/METS/" 
	 xmlns:xtf="http://cdlib.org/xtf"
   xmlns:session="java:org.cdlib.xtf.xslt.Session"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	 exclude-result-prefixes="#all"	>

<xsl:param name="http.referer"/>
<xsl:param name="http.Referer"/>
<xsl:param name="root.path"/>
<xsl:param name="a2a.on"/>
<xsl:param name="moreLike.on"/>

<xsl:variable name="theHost" select="replace($root.path , ':[0-9]+.+' , '')"/> 

<xsl:template match="*:a2a">
  <xsl:if test="$a2a.on='on'">
    <xsl:apply-templates/>
  </xsl:if>
</xsl:template>

<xsl:template match="insert-moreLike">
<xsl:if test="$moreLike.on='on'">
<xsl:comment>insert-moreLike</xsl:comment>
<div xmlns="http://www.w3.org/1999/xhtml" id="moreLike"/>
<script xmlns="http://www.w3.org/1999/xhtml"> var objid = "<xsl:value-of select="$page/m:mets/@OBJID"/>"; </script>
</xsl:if>
</xsl:template>

<xsl:template match="insert-metadataLink">
<xsl:comment>insert-metadataLink</xsl:comment>
<p class="more-info"><a href="/{$page/m:mets/@OBJID}/?layout=metadata{$brandCgi}">More information about this image</a></p>
</xsl:template>

<xsl:template match="insert-print-footer">
<xsl:comment>insert-print-footer</xsl:comment>
<!-- set up variables, fill out template  -->
<xsl:copy-of select="$brand.print.footer"/>
  <xsl:call-template name="insert-google-tracking">
    <xsl:with-param name="brand" select="$brand"/>
    <xsl:with-param name="onContent" select="'onContent'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="insert-brand-footer">
<xsl:comment>insert-brand-footer</xsl:comment>
 <xsl:copy-of select="$brand.footer"/>
  <xsl:call-template name="insert-google-tracking">
    <xsl:with-param name="brand" select="$brand"/>
    <xsl:with-param name="onContent" select="'onContent'"/>
  </xsl:call-template>
</xsl:template>

<xsl:template match="insert-sitesearch">
<xsl:comment>insert-sitesearch</xsl:comment>
<!-- set up variables, fill out template  -->
<xsl:copy-of select="$brand.search.box"/>
</xsl:template>

<xsl:template match="date[1][text()]"  mode="briefMeta">
	<div>
	<h2>Date:</h2>
	<xsl:choose>
	   <xsl:when test="../date[@q='created'] and not(../date[@q='created'] = '')">
		<xsl:value-of select="../date[@q='created'][1]"/>
	   </xsl:when>
	   <xsl:otherwise>
		<xsl:value-of select="."/>
	   </xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>

<xsl:template match="title[1][text()]| description[@q='abstract'][text()][1]"  mode="briefMeta">
<div>
	<h2>
	<xsl:value-of select="upper-case(substring(local-name(),1,1))"/>
	<xsl:value-of select="substring(local-name(),2,string-length(local-name()))"/>
	<xsl:text>:</xsl:text>
	</h2>
	<xsl:text> </xsl:text><xsl:value-of select="."/>
</div>
</xsl:template>

<xsl:template match="contributor[1][text()]|creator[1][text()]" mode="briefMeta">
<xsl:choose>
  <xsl:when test="name() = 'contributor'">
        <div>
                <h2>Creator/Contributor:</h2>
                <xsl:text> </xsl:text><xsl:value-of select="../creator[1]"/>
        </div>
	<xsl:if test="not(../creator[1] = .)">
        <div>
        <xsl:text> </xsl:text><xsl:value-of select="."/>
        </div>
	</xsl:if>
  </xsl:when>
  <xsl:when test="name() = 'creator' and ../contributor"/>
  <xsl:otherwise>
        <div>
                <h2>Creator/Contributor:</h2>
                <xsl:text> </xsl:text><xsl:value-of select="."/>
        </div>
  </xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="title" mode="briefMeta">
	<div><xsl:apply-templates mode="magic"/></div>
</xsl:template>

<xsl:template match="contributor" mode="briefMeta">
	<div><xsl:apply-templates mode="magic"/></div>
</xsl:template>

<xsl:template match="date" mode="briefMeta">
</xsl:template>

<xsl:template match="*" mode="briefMeta">
</xsl:template>

<xsl:template match="title[1][text()]| creator[1][text()]| subject[not(@q='series')][1][text()]| description[1][text()]| publisher[1][text()]| contributor[1][text()]| date[1][text()]| type[@q][1][text()]| format[1][not(@q='x')][text()]| identifier[not(starts-with(text(),'http://ark')) and text()][1]| source[1][text()]| language[1][text()]| coverage[1][text()]| rights[1][text()] | relation[not(starts-with(text(),'http://'))][not(starts-with(text(),'ark:/'))]"
	mode="fullDC">
<div>
	<h2>
	<xsl:value-of select="upper-case(substring(local-name(),1,1))"/>
	<xsl:value-of select="substring(local-name(),2,string-length(local-name()))"/>
	<xsl:text>:</xsl:text>
	</h2><xsl:text> </xsl:text>
	<xsl:apply-templates mode="magic"/></div>
</xsl:template>

<xsl:template match="title| creator| description| contributor| date| 
	format| identifier| source| language| coverage| rights| subject | relation[not(starts-with(text(),'http://'))][not(starts-with(text(),'ark:/'))][position() &gt; 1] "
	mode="fullDC">
  <xsl:if test="not(name()='identifier' and starts-with(.,'http://ark')) 
		and 
		not(name()='format' and @q='x')">
	<div><xsl:apply-templates mode="magic"/></div>
  </xsl:if>
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
<div><h2>Collection:</h2><xsl:text> </xsl:text>
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
</div>
</xsl:template>

<xsl:template match="insert-dcq-html">
<xsl:apply-templates select="$page/m:mets/@OBJID" mode="cannonical"/>
<xsl:apply-templates 
	select="$page/m:mets/*[@xtf:meta] | $page/../TEI.2/xtf:meta/* | $page/TEI.2/xtf:meta/*" 
	mode="dcq-html"/>
</xsl:template>

<xsl:template match="@OBJID" mode="cannonical">
  <xsl:variable name="param">
    <xsl:if test="number($order) &gt; 1">
      <xsl:text>?order=</xsl:text>
      <xsl:value-of select="$order"/>
    </xsl:if>
    <xsl:if test="$layout = 'metadata'">
      <xsl:text>?layout=</xsl:text>
      <xsl:value-of select="$layout"/>
    </xsl:if>
  </xsl:variable>
  <link 
    rel="canonical" 
    href="http://content.cdlib.org/{
      replace(concat(.,'/'),'/+$','/') 
    }{
      $param
    }" /><!-- replace regex/ should end in one slash -->
</xsl:template>

<xsl:template match="contributor | coverage | creator | date | description | format[@q!='x'] | identifier | language
| publisher | relation | rights | source | subject | title | type" mode="dcq-html">
	<meta xmlns="http://www.w3.org/1999/xhtml" name="DC.{name()}" content="{normalize-space(.)}"/>
</xsl:template>

<xsl:template match="*" mode="dcq-html">
	<meta xmlns="http://www.w3.org/1999/xhtml" name="XTF.{name()}" content="{normalize-space(.)}"/>
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

<xsl:template match="insert-multi-use">
<xsl:variable name="multi-use" select="$brand.file/brand/@multi-use"/>
<xsl:comment>insert-multi-use: <xsl:value-of select="$multi-use"/></xsl:comment>
  
<!-- referer madness; off-site (not matches...) referers
cause the queryURL to be set to the referer -->

<xsl:if test="session:isEnabled() 
		and 
			(not (matches($http.referer, $theHost))
			 or (matches($http.referer, '/test/qa.html$'))
			)
		and (normalize-space($http.referer) != '')"
	     use-when="function-available('session:setData')">
          <xsl:value-of select="session:setData('queryURL',$http.referer)"/>
<xsl:comment>session queryURL reset</xsl:comment>
</xsl:if>

<!-- offsite queryURLs are cleared if they are from offsite
and the referer is on-site -->

<xsl:choose>
	<xsl:when test="$multi-use='hotdog'">
<a href="{$brand.file/brand/hotdog.img/@href}">
<img src="{$brand.file/brand/hotdog.img/@src}" border="0"/>
</a>
	</xsl:when>
	<xsl:when test="$multi-use='oac-breadcrumb'">
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
 <a href="http://www.oac.cdlib.org/findaid/ark:/{substring-after(($page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD'])[1]/@*[local-name()='href'],'ark:/')}">
<xsl:value-of select="($page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD'])[1]/@LABEL"/></a>
<!-- img src="http://www.oac.cdlib.org/images/text_icon.gif"/ --> 
<!-- crumb 2 -->

</div>
	</xsl:when>
	<xsl:otherwise/>
</xsl:choose>
  
  <!-- Added by KVH, 2/15/06 -->
  <!-- retrieve search -->
  <xsl:if test="session:isEnabled()" use-when="function-available('session:setData')">
    <xsl:variable name="queryURL" select="session:getData('queryURL')"/>
    <xsl:if test="normalize-space($queryURL) != ''">
      <p>
        <a class="highlight" href="{$queryURL}">
          <xsl:text>Back</xsl:text>
        </a>
      </p>
    </xsl:if>
  </xsl:if>
  
  </xsl:template>


</xsl:stylesheet>
