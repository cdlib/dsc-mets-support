<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:cdl2="http://www.cdlib.org/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:mods="http://www.loc.gov/mods/v3"
                xmlns:dcterms="http://purl.org/dc/terms/"
                version="1.0"
		xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="xlink mets mods xsl cdl cdl2 dc dcterms">
<xsl:import href="brandCommon.xsl"/>
<xsl:param name="order"/>
<xsl:param name="size"/>
<xsl:param name="sheet"/>
<xsl:param name="debug"/>
<xsl:param name="brand" select="'oac'"/>
<xsl:key name="absPos" match="m:div[m:div/m:fptr]">
	<xsl:value-of select="count( preceding::m:div[m:div/m:fptr] | ancestor::m:div[m:div/m:fptr])+1"/>
</xsl:key>
<xsl:key name="md" match="*" use="@ID"/>

<xsl:variable name="thisDiv" select="key('absPos',$order)"/>

<!-- insert-metadataPortion in the following included template -->
<xsl:include href="4.insert-md-portion-mods.xslt"/>
	
	<xsl:variable name="lsize">
	<xsl:choose>
		<xsl:when test="$size"><xsl:value-of select="$size"/></xsl:when>
		<xsl:otherwise>1</xsl:otherwise>
	</xsl:choose>
	</xsl:variable>

  <!-- xsl:key name="k" match="/m:mets/m:structMap/m:div/m:div" use="../@ORDER"/ -->
  <xsl:variable name="page" select="/"/>



<!-- xsl:value-of select="$page/m:mets/m:structMap/m:div/m:div[@ORDER=$order]/@LABEL"/ --> <xsl:output method="html"/>

  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <xsl:variable name="frontpage" 
  select="document('GenX.frontpage.xhtml')"/>
  <xsl:variable name="view" 
  select="document('GenX.div.xhtml')"/>
  <xsl:variable name="contact" 
  select="document('GenX.contact.xhtml')"/>


  <xsl:template match="/">
	<xsl:choose>
		<xsl:when test="$order">
    <xsl:apply-templates select="$view/html"/>
		</xsl:when>
		<xsl:when test="$sheet">
    <xsl:apply-templates select="$contact/html"/>
		</xsl:when>
		<xsl:otherwise>
    <xsl:apply-templates select="$frontpage/html"/>
		</xsl:otherwise>
	</xsl:choose>
  </xsl:template>

  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

  <xsl:template match="nbsp"><xsl:text disable-output-escaping='yes'><![CDATA[&nbsp;]]></xsl:text></xsl:template>
    
  <!-- xsl:template match="copy"><![CDATA[&copy;]]></xsl:template -->
  
  <!-- xsl:template match="bullet"><![CDATA[&#8226;]]></xsl:template -->

<xsl:template match="insert-brand-links">
 <xsl:copy-of select="$brand.links"/>
</xsl:template>

<xsl:template match="insert-brand-head">
 <xsl:copy-of select="$brand.header"/>
</xsl:template>

<xsl:template match="insert-brand-footer">
 <xsl:copy-of select="$brand.footer"/>
</xsl:template>



<xsl:template match="insert-nextSheet">
<xsl:if test="count($page/m:mets/m:structMap/m:div/m:div) &gt; number($sheet) * 25">
  <xsl:variable name="link">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/?sheet=</xsl:text>
	<xsl:value-of select="(number($sheet) + 1)"/>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>
  </xsl:variable>
	<a href="{$link}"><img src="http://oac.cdlib.org/images/next.gif" width="51" height="22" border="0" alt="next &gt;&gt;" class="prevNextButton" align="middle"/></a>
</xsl:if>
</xsl:template>

<xsl:template match="insert-prevSheet">
<xsl:choose>
<xsl:when test="number($sheet) &gt; 1">
  <xsl:variable name="link">
	<xsl:text>/</xsl:text>
	<xsl:value-of select="$page/m:mets/@OBJID"/>
	<xsl:text>/?sheet=</xsl:text>
	<xsl:value-of select="(number($sheet) - 1)"/>
	<xsl:if test="$size">
	<xsl:text>&amp;size=</xsl:text>
	<xsl:value-of select="$size"/>
	</xsl:if>
  </xsl:variable>
	<a href="{$link}"><img src="http://oac.cdlib.org/images/previous.gif" width="72" height="22" border="0" alt="&lt;&lt; previous" class="prevNextButton" align="middle"/></a>
</xsl:when>
<xsl:otherwise>
<xsl:text disable-output-escaping='yes'><![CDATA[&nbsp;]]></xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="insert-thisSheet">
<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="sheet"/>
</xsl:template>

<xsl:template match="insert-prevORDER">
 <xsl:if test="$thisDiv/preceding::m:div/@LABEL[position()=last()]"> 
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
	<xsl:value-of select="($thisDiv/preceding::m:div/@LABEL)[position()=last()]"/>
 </a>
 </xsl:if>
</xsl:template>

<xsl:template match="insert-nextORDER">
 <xsl:if test="$thisDiv/following::m:div/@LABEL">
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
 <xsl:value-of select="$thisDiv/following::m:div[1]/@LABEL"/>
 </a>
 </xsl:if>
</xsl:template>

<xsl:template match="insert-thisLABEL">
	<xsl:value-of select="$thisDiv/@LABEL"/>
</xsl:template>
  
<xsl:template match="insert-thisDiv">
	<xsl:apply-templates select="$thisDiv" mode="divPage"/>
</xsl:template>

<xsl:template match="insert-metadataPage">
<p><span class="listing"><xsl:value-of select="$thisDiv/@LABEL"/></span></p>
<p><span class="listingTitle">From:</span><br/>
<span class="listing">
<a href="/{$page/m:mets/@OBJID}">
    <xsl:value-of select="$page/m:mets/@LABEL"/>
 </a>
</span>
</p>
</xsl:template>

  <xsl:template match="insert-head-title">
    <title>OAC: <xsl:value-of select="$page/mets:mets/@LABEL"/></title>
  </xsl:template>

  <xsl:template match="insert-main-title">
 <a href="/{$page/m:mets/@OBJID}">
    <xsl:value-of select="$page/m:mets/@LABEL"/>
 </a>
  </xsl:template>

  <xsl:template match="insert-breadcrumb">

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

<div class="{$class}">
    <a href="{$url}"><xsl:value-of select="$oactype"/></a>
&#160;&#160;&gt;&#160; 

 <a href="http://www.oac.cdlib.org/findaid/ark:/{substring-after($page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@*[local-name()='href'],'ark:/')}">
<xsl:value-of select="$page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@LABEL"/></a>
<!-- img src="http://www.oac.cdlib.org/images/text_icon.gif"/ --> 
  <xsl:choose>
	<xsl:when test="$order or $sheet">
&#160;&#160;&gt;&#160; 
		<a href="/{$page/m:mets/@OBJID}"><xsl:value-of select="$page/mets:mets/@LABEL"/></a>
	&#160;&gt;&#160;
		<xsl:choose>
		 <xsl:when test="$order">
<xsl:value-of select="$thisDiv/@LABEL"/>
		 </xsl:when>
		 <xsl:otherwise>
<xsl:variable name="startsheet">
        <xsl:value-of select="25*(number($sheet) - 1)+1"/>
</xsl:variable>
<xsl:variable name="endsheet">
  <xsl:choose>
    <xsl:when test="(count($page/m:mets/m:structMap/m:div/m:div[m:div]))
			&lt;
		    (25*number($sheet))">
	<xsl:value-of select="count($page/m:mets/m:structMap/m:div/m:div[m:div])"/>
    </xsl:when>
    <xsl:otherwise>
        <xsl:value-of select="25*number($sheet)"/>
    </xsl:otherwise>
  </xsl:choose>
</xsl:variable>
		<xsl:value-of select="$page/m:mets/m:structMap/m:div/m:div[m:div][position()=$startsheet]/@LABEL"/> to  
                <xsl:value-of select="$page/m:mets/m:structMap/m:div/m:div[m:div][position()=$endsheet]/@LABEL"/> 
		 </xsl:otherwise>
		</xsl:choose>
	</xsl:when>
	<xsl:when test="$debug">
&#160;&#160;&gt;&#160;
                <xsl:value-of select="$page/m:mets/@LABEL"/>
        <img src="http://www.oac.cdlib.org/images/image_icon.gif"/> &#160;[
<a href="/?identifier={$page/m:mets/@OBJID}">CMS record</a> |
<a href="/raw/{$page/m:mets/@OBJID}/">CDL METS</a> | 
<a href="/bct-voroBasic/data/{substring($page/m:mets/@OBJID,(string-length($page/m:mets/@OBJID)-1))}/{substring-after($page/m:mets/@OBJID,'ark:/13030/')}/source.mets.xml">DPG METS</a> 
]

	</xsl:when>
	<xsl:otherwise/>
  </xsl:choose>
</div>
  </xsl:template>
 
  <xsl:template match="insert-pagetitle">
     <xsl:choose>
	<xsl:when test="$order or $sheet">
<xsl:value-of select="$thisDiv/@LABEL"/>

	</xsl:when>
	<xsl:otherwise>
    		<xsl:value-of select="$page/mets:mets/@LABEL"/>
	</xsl:otherwise>
     </xsl:choose>
  </xsl:template>
  
      
<xsl:template match="insert-imagePortion|insert-sm1">
	<xsl:if test="$debug">
		<div><img src="/{$page/m:mets/@OBJID}/thumbnail"/></div>
	</xsl:if>
	<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="structMap"/>
</xsl:template>

<xsl:template match="insert-sm2">
	<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="structMap2"/>
</xsl:template>

<xsl:template match="m:structMap" mode="structMap">
	<xsl:apply-templates select="m:div" mode="structMap"/>
</xsl:template>

<xsl:template match="m:structMap" mode="sheet">
	<xsl:apply-templates select="m:div" mode="out-sheet"/>
</xsl:template>

<xsl:template match="m:structMap" mode="structMap2">
	<xsl:apply-templates select="m:div" mode="structMap2"/>
</xsl:template>

<xsl:template match="m:div" mode="out-sheet">

<xsl:variable name="startsheet">
	<xsl:value-of select="25*(number($sheet) - 1) +1"/>
</xsl:variable>

	<table border="0" width="100%">
        <tr>
	<xsl:apply-templates select="key('absPos',( $startsheet))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 1 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 2 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 3 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 4 ))" mode ="sheet"/>
	</tr>
        <tr>
	<xsl:apply-templates select="key('absPos',( $startsheet + 5 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 6 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 7 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 8 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 9 ))" mode ="sheet"/>
	</tr>
        <tr>
	<xsl:apply-templates select="key('absPos',( $startsheet + 10 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 11 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 12 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 13 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 14 ))" mode ="sheet"/>
	</tr>
        <tr>
	<xsl:apply-templates select="key('absPos',( $startsheet + 15 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 16 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 17 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 18 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 19 ))" mode ="sheet"/>
	</tr>
        <tr>
	<xsl:apply-templates select="key('absPos',( $startsheet + 20 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 21 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 22 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 23 ))" mode ="sheet"/>
	<xsl:apply-templates select="key('absPos',( $startsheet + 24 ))" mode ="sheet"/>
	</tr>
	</table>
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
           </xsl:if>
        </xsl:variable>

 	<xsl:variable name="w">
	   <xsl:choose>
<xsl:when test="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X &lt; 150">
<xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X"/>
	     </xsl:when>
	     <xsl:otherwise>150</xsl:otherwise>
	   </xsl:choose>
        </xsl:variable>

 	<xsl:variable name="h">
	   <xsl:choose>
<xsl:when test="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X &lt; 150">
	<xsl:value-of select="m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y"/>
	     </xsl:when>
	     <xsl:otherwise><xsl:value-of select="round(150* ( m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X div m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y) )"/></xsl:otherwise>
	   </xsl:choose>
        </xsl:variable>
	<td>
	<a href="{$nailref}">
	<img border="0" width="{$w}" height="{$h}" src="{$naillink}"/>
	<br/>
	<xsl:value-of select="@LABEL"/>
	</a>
	</td>
</xsl:template>

<xsl:template match="m:div" mode="structMap2">
<div>
<xsl:choose>
 <xsl:when test="not(m:div/m:fptr)">
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
 <xsl:apply-templates
select="($page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods)[1]/mods:location/mods:physicalLocation" mode="mods"/>

</xsl:template>

 
</xsl:stylesheet>
