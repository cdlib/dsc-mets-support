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
		xmlns:xs="http://www.w3.org/2001/XMLSchema"
		xmlns:fn="http://www.w3.org/2004/07/xpath-functions"
                version="2.0"
		xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="#all">

 <xsl:variable name="mrsid-hack">
   <xsl:choose>
     <xsl:when test="$page/m:mets/m:fileSec//m:file[contains(@MIMETYPE,'mrsid')]
">2</xsl:when>
     <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>

<xsl:template match="insert-structMap">
<xsl:comment>insert-structMap <xsl:apply-templates select="@*" mode="attrComments"/></xsl:comment>
	<xsl:apply-templates select="$page/m:mets/m:structMap[1]" mode="divNavAlt2"/>
</xsl:template>

<xsl:template match="@*" mode="attrComments">
@<xsl:value-of select="name()"/> <xsl:value-of select="."/>
</xsl:template>

<xsl:template match="insert-structMap-pagination">
</xsl:template>

<xsl:template match="m:structMap" mode="structMap">
	<xsl:apply-templates select="m:div" mode="structMap"/>
</xsl:template>

<!-- this is the div structure for DaylightSavings2006 release -->
<xsl:template match="m:structMap" mode="divNavAlt2">
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-div"/>
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table"/>
</xsl:template>

<!-- creates the inner table (AJAXify the paging here somehow?) -->
<xsl:template match="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table">
<xsl:variable name="focusDivIsPreggers">
	<xsl:if test="$focusDiv/m:div/m:div/m:fptr">true</xsl:if> 
</xsl:variable>
<xsl:variable name="focusDivIsImage">
	<xsl:if test="$focusDiv/m:div/m:fptr">true</xsl:if> 
</xsl:variable>
<xsl:variable name="selfAction">
   <xsl:choose>
	<!-- I am the parent of the focus div, and -->
	<xsl:when test="(. is $focusDiv/..) 
		and not ($focusDivIsPreggers = 'true')
		and ($focusDivIsImage = 'true')">AtableIsNext</xsl:when>
	<!-- I am the focus div, and I have kids with pictures -->
	<xsl:when test="(. is $focusDiv)
		and ($focusDivIsPreggers = 'true')">BtableIsNext</xsl:when>
	<!-- one of my kids has the focus and content -->
	<xsl:when test="m:div[. is $focusDiv]
		and $focusDiv/m:div/m:fptr
		and not ($focusDivIsPreggers = 'true')">CtableIsNext</xsl:when>
	<!-- follow the focus with recursion -->
	<xsl:when test=".//m:div[. is $focusDiv]">Drecurse</xsl:when>
	<!-- I am the focus div -->
	<xsl:when test=". is $focusDiv">Erecurse</xsl:when>
	<!-- one of my kids has teh focus -->
	<xsl:when test="not ($focusDivIsImage ='true')
		and not ($focusDivIsPreggers = 'true')">Fheadings</xsl:when>
	<xsl:otherwise></xsl:otherwise>
 </xsl:choose>
</xsl:variable>

<xsl:variable name="focusDivSiblingCount" select="count(m:div[@ORDER or @LABEL][m:div/m:fptr])"/>
<xsl:variable name="focusDivOrderInSiblingCount" select="count($focusDiv/preceding-sibling::m:div[m:div/m:fptr]) + 1"/>
<xsl:variable name="focusDivOrderInSiblingCountMinus1" select="$focusDivOrderInSiblingCount - 1"/>
<xsl:variable name="pagesCount" select="ceiling(  $focusDivSiblingCount div 15 )"/>
<xsl:variable name="thisPageOrder" select="1 + ($focusDivOrderInSiblingCountMinus1 - ($focusDivOrderInSiblingCountMinus1 mod 15)) div 15"/>
<xsl:variable name="startOfPage" select="number(($thisPageOrder -1)*15 + 1 ) cast as xs:integer"/>
<xsl:variable name="endOfPage" select="number($startOfPage + 14) cast as xs:integer"/>
<xsl:variable name="itemsOnNextPage">
    <xsl:choose>
	<xsl:when test="$thisPageOrder + 1 = $pagesCount">
		<xsl:value-of select="$focusDivSiblingCount mod 15"/>
	</xsl:when>
	<xsl:otherwise>
		<xsl:text>15</xsl:text>
	</xsl:otherwise>
    </xsl:choose>
</xsl:variable>
<xsl:variable name="pagesAhead">
  <xsl:choose>
    <xsl:when test="$pagesCount &gt; $thisPageOrder">
      <xsl:text>true</xsl:text>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:variable>
<xsl:variable name="pagesBehind">
  <xsl:choose>
    <xsl:when test="$thisPageOrder &gt; 1">
      <xsl:text>true</xsl:text>
    </xsl:when>
    <xsl:otherwise/>
  </xsl:choose>
</xsl:variable>


	<xsl:choose>
           <xsl:when test="ends-with($selfAction , 'tableIsNext')">
		<table border="0">
		  <xsl:apply-templates 
			select="for $x in $startOfPage to $endOfPage return(m:div[@ORDER or @LABEL][m:div][position()=$x])" 
			mode="image-table"/>
		</table>
		
		<div class="image-nav">Click image for larger view</div>

		<xsl:if test="$focusDivSiblingCount &gt; 15">
		  <div class="pagination">
		    <xsl:if test="$pagesBehind = 'true'">
		  	<a>
			  <xsl:attribute name="href">
		           <xsl:text>/</xsl:text>
			   <xsl:value-of select="$page/m:mets/@OBJID"/>
		           <xsl:text>/?order=</xsl:text>
			   <xsl:for-each select="m:div[@ORDER or @LABEL][m:div][position()=$startOfPage -15]">
				<xsl:value-of select="(count(preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div]) + 1)"/>
			   </xsl:for-each>
			   <xsl:value-of select="$brandCgi"/>
			  </xsl:attribute>
			  <xsl:text>previous</xsl:text>
			</a>
		    </xsl:if>
		    <xsl:text> </xsl:text>
		    <xsl:value-of select="$startOfPage"/>
		    <xsl:text> - </xsl:text>
		    <xsl:value-of select="min(($endOfPage, $focusDivSiblingCount))"/>
		    <xsl:text> of </xsl:text>
		    <xsl:value-of select="$focusDivSiblingCount"/>
		    <xsl:text> </xsl:text>
		    <xsl:if test="$pagesAhead = 'true'">
		  	<a>
			  <xsl:attribute name="href">
		           <xsl:text>/</xsl:text>
			   <xsl:value-of select="$page/m:mets/@OBJID"/>
		             <xsl:text>/?order=</xsl:text>
			   <xsl:for-each select="m:div[@ORDER or @LABEL][m:div][position()=$endOfPage +1]">
				<xsl:value-of select="(count(preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div]) + 1)"/>
			   </xsl:for-each>
			   <xsl:value-of select="$brandCgi"/>
			  </xsl:attribute>
			  <xsl:text>next</xsl:text>
			  <!-- xsl:value-of select="$itemsOnNextPage"/ -->
			</a>
		    </xsl:if>
		  </div>
		</xsl:if>

	  </xsl:when>
	  <xsl:when test="ends-with($selfAction , 'recurse')">
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table"/>
	  </xsl:when>
	  <xsl:otherwise>
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table"/>
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="m:div[@ORDER or @LABEL][m:div]" mode="alt2-div">
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
		and ($focusDivIsImage = 'true')">AtableIsNext</xsl:when>
	<!-- I am the focus div, and I have kids with pictures -->
	<xsl:when test="(. is $focusDiv)
		and ($focusDivIsPreggers = 'true')">BtableIsNext</xsl:when>
	<!-- one of my kids has the focus and content -->
	<xsl:when test="m:div[. is $focusDiv]
		and $focusDiv/m:div/m:fptr
		and not ($focusDivIsPreggers = 'true')">CtableIsNext</xsl:when>
	<!-- follow the focus with recursion -->
	<xsl:when test=".//m:div[. is $focusDiv]">Drecurse</xsl:when>
	<!-- I am the focus div -->
	<xsl:when test=". is $focusDiv">Erecurse</xsl:when>
	<!-- one of my kids has teh focus -->
	<xsl:when test="not ($focusDivIsImage ='true')
		and not ($focusDivIsPreggers = 'true')">Fheadings</xsl:when>
	<xsl:otherwise></xsl:otherwise>
 </xsl:choose>
</xsl:variable>


<xsl:choose>
  <xsl:when test=". is $focusDiv or .//m:div[. is $focusDiv] or ends-with($selfAction , 'headings')">

<div class="structMap">

<xsl:choose>
    	<xsl:when test=". is $focusDiv">
		<xsl:copy-of select="$brand.arrow.up"/>
		<xsl:value-of select="@LABEL"/>
    	</xsl:when>
	<xsl:when test=".//m:div[. is $focusDiv]">
<a href="/{$this.base}/?order={count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1}{$brandCgi}">
<xsl:copy-of select="$brand.arrow.dn"/>
<xsl:value-of select="@LABEL"/>
</a>
	<xsl:choose>
           <xsl:when test="ends-with($selfAction , 'tableIsNext')">
	  </xsl:when>
	  <xsl:when test="ends-with($selfAction , 'headings')">
<a href="/{$this.base}/?order={count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1}{$brandCgi}"><xsl:value-of select="@LABEL"/></a>
	  </xsl:when>
	  <xsl:otherwise><!-- (<xsl:value-of select="$selfAction"/>) --></xsl:otherwise>
	</xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
</xsl:choose>

	<xsl:choose>
           <xsl:when test="ends-with($selfAction , 'tableIsNext')">
		<xsl:if test="not(. is $focusDiv)">
			<div class="structMap">
<xsl:copy-of select="$brand.arrow.up"/>
			<xsl:value-of select="$focusDiv/@LABEL"/>
			</div>
		</xsl:if>
	  </xsl:when>
	  <xsl:when test="ends-with($selfAction , 'recurse')">
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-div"/>
	  </xsl:when>
	  <xsl:when test="ends-with($selfAction , 'headings')">
<a href="/{$this.base}/?order={count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1}{$brandCgi}"><xsl:value-of select="@LABEL"/></a>
	  </xsl:when>
	  <xsl:otherwise><!-- (<xsl:value-of select="$selfAction"/>) --></xsl:otherwise>
	</xsl:choose>


</div>
 </xsl:when>
 <xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>


<xsl:template match="m:div[@ORDER or @LABEL][m:div]" mode="image-table">
<xsl:variable name="thisInCount" select="count( preceding-sibling::m:div[@ORDER or @LABEL][m:div])"/>
<xsl:variable name="node2" 
	select="following-sibling::m:div[@ORDER or @LABEL][m:div][1]"/>
<xsl:variable name="node3" 
	select="following-sibling::m:div[@ORDER or @LABEL][m:div][2]"/>

<xsl:choose>
 <xsl:when test="(($thisInCount) mod 3 = 0)">
  <tr>
	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="."/>
		<xsl:with-param name="number" 
			select="(count(preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div]) + 1)"/>
	  	<xsl:with-param name="pos" select="'left'"/>
	   </xsl:call-template>

	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="$node2"/>
		<xsl:with-param name="number" select="(count($node2/preceding::m:div[@ORDER or @LABEL][m:div] | $node2/ancestor::m:div[@ORDER or @LABEL][m:div]) + 1)"/>
	   </xsl:call-template>
	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="$node3"/>
		<xsl:with-param name="number" select="(count($node3/preceding::m:div[@ORDER or @LABEL][m:div] | $node3/ancestor::m:div[@ORDER or @LABEL][m:div]) + 1)"/>
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

<xsl:template name="navThumb">
   <xsl:param name="node"/><!-- div from structMap -->
   <xsl:param name="number"/><!-- order= source oroder of div -->
   <xsl:param name="pos"/><!-- left or right or blank -->
   <xsl:variable name="imagePos" select="(count( $node/preceding-sibling::m:div[m:div/m:fptr]))"/>
	<!-- need class="on" on td if this cell has an image in it -->
		<!-- pos=left will always have content -->
		<!-- $imagePos &gt; 0 will be true when other divs have content -->
   <td>
	<xsl:choose>
	   <xsl:when test=" ( number($order) = number($number) and
				(  ($pos ='left') 
				   or ( $imagePos &gt; 0  and $pos != 'right')  
				) 
			    )">
		<xsl:attribute name="class" select="'on'"/>
	   </xsl:when>
	   <xsl:when test=" ( number($order) = number($number) and
				(  $pos='right' ) and
				( number($order) &gt; 1 )
		)
		">
		<xsl:attribute name="class" select="'right on'"/>
	   </xsl:when>
	   <xsl:when test="$pos = 'right'">
		<xsl:attribute name="class" select="'right'"/>
	   </xsl:when>
	</xsl:choose>
<!-- xsl:value-of select="$pos"/>|
<xsl:value-of select="$order"/>|
<xsl:value-of select="$number"/>|
<xsl:value-of select="$imagePos"/>*
<xsl:value-of select=" ( number($order) = number($number) and
				(  ($pos='left') or ( $imagePos &gt; 0 )  ) )
"/ -->
   <xsl:choose>
     <xsl:when test="$node/m:div/m:fptr and ( ($imagePos &gt; 0) or ($pos = 'left') )">
 	<xsl:variable name="naillink">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$node/m:div[contains(@TYPE,'thumbnail')][1]/m:fptr/@FILEID"/>
        </xsl:variable>

 	<xsl:variable name="nailref">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/?order=</xsl:text>
           <xsl:value-of select="$number"/>
           <xsl:if test="$size">
           <xsl:text>&amp;size=</xsl:text>
           <xsl:value-of select="$size"/>
           </xsl:if>
           <xsl:value-of select="$brandCgi"/>
        </xsl:variable>

	<xsl:variable name="xy">
           <xsl:call-template name="scale-max">
           	<xsl:with-param name="max" select="number(65)"/>
           	<xsl:with-param name="x" select="$node/m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X"/>
           	<xsl:with-param name="y" select="$node/m:div[starts-with(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y"/>
           </xsl:call-template>
   	</xsl:variable>


	<a href="{$nailref}" title="{$node/@LABEL}">
	<img border="0" width="{$xy/xy/@width}" height="{$xy/xy/@height}" src="{$naillink}"
		alt="{$node/@LABEL}"/>
	<br/>
	<xsl:variable name="kidcount" select="count($node/m:div[m:div/m:fptr])"/>
	<xsl:if test="$kidcount = 1">1 item</xsl:if>
	<xsl:if test="$kidcount &gt; 1">
		<xsl:value-of select="$kidcount"/> items
	</xsl:if>
	</a>
     </xsl:when>
     <xsl:otherwise/>
   </xsl:choose>
   </td>
</xsl:template>

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

<xsl:template match="insert-inner-content">
<xsl:comment>insert-inner-content @css-id:<xsl:value-of select="@css-id"/></xsl:comment>
<xsl:variable name="thisImage" select="$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=1]"/>
<xsl:choose>
 <xsl:when test="$thisImage">
<div id="{@css-id}" xmlns="http://www.w3.org/1999/xhtml">
     <div class="nifty7a">
	<div class="box7a">
  <xsl:variable name="xy">
    <xsl:call-template name="scale-maxXY">
      <xsl:with-param name="maxX" select="'512'"/>
      <xsl:with-param name="maxY" select="'800'"/>
      <xsl:with-param name="x" select="number($thisImage/m:fptr/@cdl2:X)"/>
      <xsl:with-param name="y" select="number($thisImage/m:fptr/@cdl2:Y)"/>
    </xsl:call-template>
  </xsl:variable>
<a href="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=(last() - number($mrsid-hack))]/m:fptr/@FILEID}" title="Larger Image">

  <img
        src="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=1]/m:fptr/@FILEID}"
        width="{$xy/xy/@width}"
        height="{$xy/xy/@height}"
	border="0"
  /></a>
	</div>
     </div>
     <xsl:apply-templates select="*"/>
</div>
 </xsl:when>
 <xsl:otherwise/>
</xsl:choose>
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

<!-- generic navigation from structMap div's -->
<xsl:template name="divNav">
   <xsl:param name="node"/>
   <xsl:param name="number"/>
   <xsl:variable name="imagePos" select="(count( $node/preceding-sibling::m:div[@ORDER or @LABEL][m:div]))"/>
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


 
</xsl:stylesheet>
