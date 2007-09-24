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
 <xsl:key name="divByOrder" match="m:div[@ORDER]" use="@ORDER"/> 
 <xsl:key name="divShowsChild" match="m:div[m:div/m:div/m:fptr]">
    <xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
  </xsl:key>
 <xsl:key name="divShowsChildStrict" match="m:div[m:div[@ORDER or @LABEL][1]/m:div[1]/m:fptr]">
    <xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
  </xsl:key>
  <xsl:key name="divChildShowsChild"  match="m:div[m:div/m:div/m:div/m:fptr]">
    <xsl:value-of select="count( preceding::m:div[@ORDER or @LABEL][m:div] | ancestor::m:div[@ORDER or @LABEL][m:div])+1"/>
  </xsl:key>
<!-- xsl:key name="mrSidHack" match="m:file[contains(@MIMETYPE,'mrsid')]" use="name()"></xsl:key -->

 <xsl:variable name="mrsid-hack">
   <xsl:choose>
     <!-- xsl:when test="key('mrSidHack','file')">2</xsl:when -->
<xsl:when test="$page/m:mets/@mrSidHack or $page/../TEI.2/m:mets/m:fileSec//@MIMETYPE='image/x-mrsid-image'">2</xsl:when>
     <!-- xsl:when test="1 = 1">2</xsl:when -->
     <xsl:otherwise>0</xsl:otherwise>
   </xsl:choose>
  </xsl:variable>
  <xsl:variable name="focusDivShowsChild" select="key('divShowsChild',$order)"/>
  <xsl:variable name="focusDivShowsChildStrict" select="key('divShowsChildStrict',$order)"/>
  <xsl:variable name="focusDivIsImage" select="key('absPosItem', $order)"/>
  
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
<!-- 
  <xsl:value-of select="boolean(key('divShowsChild',$order))"/>
  <xsl:value-of select="boolean(key('divChildShowsChild',$order))"/>
  <xsl:value-of select="$order"></xsl:value-of>
-->
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-div"/>
<!-- hr/ -->
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table">
		<xsl:with-param name="depth" select="number(0)"/>
	</xsl:apply-templates>
	<!-- xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="detail-div">
		<xsl:with-param name="depth" select="number(0)"/>
	</xsl:apply-templates -->
</xsl:template>

<xsl:template match="m:div[@ORDER or @LABEL][m:div]" mode="detail-div">
<xsl:param name="depth"/>
<xsl:variable name="A" select="count(../m:div[@ORDER or @LABEL][m:div/m:fptr])"/>
<xsl:variable name="focusDivOrderInSiblingCount" select="count(./preceding-sibling::m:div[m:div//m:fptr]) + 1"/>
<div class="structMap">
<xsl:if test="$order = @ORDER"><b>*</b></xsl:if>
<xsl:value-of select="$depth"/><xsl:text> </xsl:text>
<xsl:value-of select="@ORDER"/><xsl:text>.  </xsl:text>
{<xsl:value-of select="$focusDivOrderInSiblingCount"/>/<xsl:value-of select="$A"/>} 
<xsl:value-of select="boolean(m:div/m:fptr)"/>
<xsl:value-of select="@LABEL"/>
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="detail-div">
		<xsl:with-param name="depth" select="$depth+1"/>
	</xsl:apply-templates>
</div>
</xsl:template>

<!-- creates the inner table (AJAXify the paging here somehow?) -->
<xsl:template match="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table">
<xsl:param name="depth"/>
<!-- xsl:value-of select="$focusDiv/@ORDER"/>=
<xsl:value-of select="$order"/>=
<xsl:value-of select="@ORDER"/ -->
<!-- xsl:message>atl2-table</xsl:message -->
  <xsl:variable name="iAmFocusDiv" select="boolean(. is $focusDiv)"/>
  <xsl:variable name="iAmParentOfFocusDiv" select="boolean(. is $focusDiv/..)"/>  
  <xsl:variable name="focusDecendsFromMe" select="
    if ($iAmFocusDiv or $iAmParentOfFocusDiv)
      then
        if ($iAmFocusDiv) then boolean(0) else boolean(1)
      else .//m:div[. is $focusDiv]"
  />
<!-- xsl:value-of select="$iAmParentOfFocusDiv"/>
/<xsl:value-of select="$focusDiv/preceding-sibling::m:div/@ORDER"/>/
/<xsl:value-of select="key('divChildShowsChild',$focusDiv/preceding-sibling::m:div/@ORDER)"/>/ -->
  <xsl:variable name="selfAction">
   <xsl:choose>
	<!-- I am the parent of the focus div, and -->
	<xsl:when test="($iAmParentOfFocusDiv) 
		and not ($focusDivShowsChild)
		and ($focusDivIsImage)
">AAtableIsNext</xsl:when>
	<!-- I am the focus div, and I have kids with pictures -->
	<xsl:when test="($iAmFocusDiv)
		and ($focusDivShowsChild)">bBtableIsNext</xsl:when>
	<!-- one of my kids has the focus and content -->
	<xsl:when test="m:div[. is $focusDiv]
		and $focusDiv/m:div/m:fptr
		and not ($focusDivShowsChild)">CtableIsNext</xsl:when>
	<!-- follow the focus with recursion -->
	<xsl:when test="$focusDecendsFromMe">Drecurse</xsl:when>
	<!-- I am the focus div -->
	<xsl:when test="$iAmFocusDiv">ErecurseXXX</xsl:when>
     <!-- one of my kids has teh focus -->
     <xsl:when test="not ($focusDivIsImage)
       and not ($focusDivShowsChild)">Fheadings</xsl:when>
	<xsl:otherwise></xsl:otherwise>
 </xsl:choose>
</xsl:variable>
<xsl:variable name="orderPlusOne" select="number($order) + 1"/>
<xsl:variable name="focusPocus" select="
		if ($iAmFocusDiv and $focusDivShowsChild) then key('absPos',$orderPlusOne) else $focusDiv"/>
<xsl:variable name="focusDivSiblingCount" select="count($focusPocus/../m:div[@ORDER or @LABEL][m:div//m:fptr])"/>
<xsl:variable name="focusDivOrderInSiblingCount" select="count($focusPocus/preceding-sibling::m:div[m:div//m:fptr]) + 1"/>
<xsl:variable name="focusDivOrderInSiblingCountMinus1" select="$focusDivOrderInSiblingCount - 1"/>
<xsl:variable name="pagesCount" select="ceiling(  $focusDivSiblingCount div 15 )"/>
<xsl:variable name="thisPageOrder" select="1 + ($focusDivOrderInSiblingCountMinus1 - ($focusDivOrderInSiblingCountMinus1 mod 15)) div 15"/>
<xsl:variable name="startOfPage" select="number(($thisPageOrder -1)*15 + 1 ) cast as xs:integer"/>	
<xsl:variable name="endOfPage" select="number($startOfPage + 14) cast as xs:integer"/>

<!-- xsl:value-of select="$selfAction"/ -->

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

<!-- xsl:variable name="countImg" select="count(m:div[@ORDER or @LABEL][m:div//m:fptr])"/>
<xsl:variable name="countKid" select="count(m:div[@ORDER or @LABEL][m:div])"/ -->

	<xsl:choose>
    <xsl:when test="ends-with($selfAction , 'tableIsNext')">
		<!-- and ($countKid = $countImg)"> -->
		<table border="0">
		  <xsl:apply-templates 
			select="for $x in $startOfPage to $endOfPage return(m:div[@ORDER or @LABEL][m:div][position()=$x])" 
			mode="image-table"/>
		  <!-- xsl:apply-templates 
			select="for $x in 1 to 15 return(m:div[@ORDER or @LABEL][m:div][position()=$x])" 
			mode="image-table"/ -->
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
				<xsl:value-of select="@ORDER"/>
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
				<xsl:value-of select="@ORDER"/>
			   </xsl:for-each>
			   <xsl:value-of select="$brandCgi"/>
			  </xsl:attribute>
			  <xsl:text>next</xsl:text>
			  <!-- xsl:value-of select="$itemsOnNextPage"/ -->
			</a>
		    </xsl:if>
		  </div>
		</xsl:if>
<!-- xsl:call-template name="nextSib"/ -->

	  </xsl:when>
	  <xsl:when test="ends-with($selfAction , 'recurse')">
	<xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table">
		<xsl:with-param name="depth" select="$depth+1"/>
	</xsl:apply-templates>
	  </xsl:when>
	  <xsl:otherwise>
	<!-- xsl:apply-templates select="m:div[@ORDER or @LABEL][m:div]" mode="alt2-table"/ -->
	  </xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="m:div[@ORDER or @LABEL][m:div]" mode="alt2-div">
<!-- xsl:message>atl2-div</xsl:message -->
  <xsl:variable name="iAmFocusDiv" select="boolean(. is $focusDiv)"/>
  <xsl:variable name="iAmParentOfFocusDiv" select="boolean(. is $focusDiv/..)"/>
  <xsl:variable name="focusDecendsFromMe" select="
    if ($iAmFocusDiv or $iAmParentOfFocusDiv)
      then
        if ($iAmFocusDiv) then boolean(0) else boolean(1)
      else .//m:div[. is $focusDiv]"
  />
  
  <xsl:variable name="selfAction">
   <xsl:choose>
	<!-- xsl:when test="$order = '1'">tableIsNext</xsl:when -->
	<!-- I am the parent of the focus div, and -->
	<xsl:when test="($iAmParentOfFocusDiv) 
		and not ($focusDivShowsChild)
		and ($focusDivIsImage)">AtableIsNext</xsl:when>
	<!-- I am the focus div, and I have kids with pictures -->
	<xsl:when test="($iAmFocusDiv)
		and ($focusDivShowsChild)
		and not($focusDiv/parent::m:structMap)">BBtableIsNext</xsl:when>
	<!-- one of my kids has the focus and content -->
	<xsl:when test="m:div[. is $focusDiv]
		and $focusDiv/m:div/m:fptr
		and not ($focusDivShowsChild)">CtableIsNext</xsl:when>
	<!-- I am the focus div -->
	<xsl:when test="$iAmFocusDiv">Erecurse</xsl:when>
	<!-- follow the focus with recursion -->
	<!-- xsl:when test=".//m:div[. is $focusDiv]">Drecurse</xsl:when -->
	<xsl:when test="$focusDecendsFromMe">Drecurse</xsl:when>
	<!-- one of my kids has teh focus -->
	<xsl:when test="not ($focusDivIsImage)
		and not ($focusDivShowsChild)">FFheadings</xsl:when>
	<xsl:when test="
		not ($focusDivIsImage)
		and not ($focusDivShowsChildStrict)
		and ($focusDiv/parent::m:structMap)">GtableIsNext</xsl:when>
	<xsl:otherwise></xsl:otherwise>
 </xsl:choose>
  </xsl:variable>
<!-- 
  [[
scs:<xsl:value-of select="$focusDivShowsChildStrict"/>|
<xsl:value-of select="boolean($focusDiv/parent::m:structMap)"/>
sa<xsl:value-of select="$selfAction"/>]]
-->
<xsl:choose>
  <xsl:when test="($iAmFocusDiv) or ($focusDecendsFromMe) or ends-with($selfAction , 'headings')">

<div class="structMap">
<xsl:message>hot</xsl:message>
<xsl:choose>
    	<xsl:when test="$iAmFocusDiv">
		<xsl:copy-of select="$brand.arrow.up"/>
		<xsl:value-of select="@LABEL"/>
<xsl:call-template name="breadThumb"/>
<xsl:call-template name="nextSib"/>
    	</xsl:when>
	<xsl:when test="$focusDecendsFromMe">
	<xsl:variable name="linkOrder" select="@ORDER"/>
<a href="/{$this.base}/?order={$linkOrder}{$brandCgi}">
<xsl:copy-of select="$brand.arrow.dn"/>
<xsl:value-of select="@LABEL"/>
</a>
	<xsl:choose>
           <xsl:when test="ends-with($selfAction , 'tableIsNext')">
<xsl:call-template name="breadThumb"/>
<xsl:call-template name="nextSib"/>
	  </xsl:when>
	  <xsl:when test="ends-with($selfAction , 'headings')">
<a href="/{$this.base}/?order={@ORDER}{$brandCgi}"><xsl:value-of select="@LABEL"/></a>
	  </xsl:when>
	  <xsl:otherwise><!-- (<xsl:value-of select="$selfAction"/>) --></xsl:otherwise>
	</xsl:choose>
	</xsl:when>
	<xsl:otherwise>
	</xsl:otherwise>
</xsl:choose>


	<xsl:choose>
           <xsl:when test="ends-with($selfAction , 'tableIsNext')">
		<xsl:if test="not($iAmFocusDiv)">
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
<a href="/{$this.base}/?order={@ORDER}{$brandCgi}"><xsl:value-of select="@LABEL"/></a>
	  </xsl:when>
	  <xsl:otherwise></xsl:otherwise>
	</xsl:choose>


</div>
 </xsl:when>
 <xsl:otherwise></xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template name="nextSib">
<xsl:variable name="focusDivSiblingCount" select="count(../m:div[@ORDER or @LABEL][m:div//m:fptr])"/>
<xsl:variable name="focusDivOrderInSiblingCount" select="count(./preceding-sibling::m:div[m:div//m:fptr]) + 1"/>
  <xsl:if test="not(parent::m:structMap) and $focusDivSiblingCount &gt; 15">
	<div class="pagination">
	<xsl:text> </xsl:text>
		<xsl:if test="1 &lt; $focusDivOrderInSiblingCount">
			<a href="/{$page/m:mets/@OBJID}/?order={number(preceding-sibling::m:div[m:div//m:fptr][1]/@ORDER) }{$brandCgi}" title="{preceding-sibling::m:div[m:div//m:fptr][1]/@LABEL}">back</a>
			<xsl:text> </xsl:text>
		</xsl:if>
	 | <!-- xsl:value-of select="$focusDivOrderInSiblingCount"/> of <xsl:value-of select="$focusDivSiblingCount"/ --> 
		<xsl:if test="$focusDivSiblingCount &gt; $focusDivOrderInSiblingCount">
			<xsl:text> </xsl:text>
			<a href="/{$page/m:mets/@OBJID}/?order={number(following-sibling::m:div[m:div//m:fptr][1]/@ORDER) }{$brandCgi}" title="{following-sibling::m:div[m:div//m:fptr][1]/@LABEL}">forward</a>
		</xsl:if>
	</div>
  </xsl:if>
</xsl:template>

<xsl:template name="breadThumb">

<xsl:if test="not(parent::m:structMap)">
<!-- xsl:value-of select="$order, @ORDER"/ -->
	<table border="0">
   	<tr>
	<xsl:choose>
	  <xsl:when test="m:div/m:fptr">
		<xsl:call-template name="navThumb">
	  	<xsl:with-param name="node" select="."/>
		<xsl:with-param name="number" select="@ORDER"/>
		<xsl:with-param name="pos" select="if (@ORDER = $order) then 'breadThumbOn' else 'breadThumb'"/>
		</xsl:call-template>
	  </xsl:when>
	  <xsl:when test="../m:div[m:div/m:fptr]">
		<td class="on">	

       <xsl:variable name="nailref">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/?order=</xsl:text>
           <xsl:value-of select="@ORDER"/>
           <xsl:if test="$size">
           <xsl:text>&amp;size=</xsl:text>
           <xsl:value-of select="$size"/>
           </xsl:if>
           <xsl:value-of select="$brandCgi"/>
        </xsl:variable>


                <xsl:variable name="kidcount" select="count(m:div[m:div/m:fptr])"/>
        <xsl:choose>
          <xsl:when test="not(@ORDER = $order)">
                <a href="{$nailref}" title="{@LABEL}">
                <xsl:call-template name="navThumbKidCount">
                        <xsl:with-param name="kidcount" select="$kidcount"/>
                </xsl:call-template>
                </a>
          </xsl:when>
          <xsl:otherwise>
                <xsl:call-template name="navThumbKidCount">
                        <xsl:with-param name="kidcount" select="$kidcount"/>
                </xsl:call-template>
          </xsl:otherwise>
        </xsl:choose>
		</td>
	  </xsl:when>
	  <xsl:otherwise/>
	</xsl:choose>
   	</tr>
	</table>
</xsl:if>
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
		<xsl:with-param name="number" select="@ORDER"/>
	  	<xsl:with-param name="pos" select="'left'"/>
	   </xsl:call-template>

	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="$node2"/>
		<xsl:with-param name="number" select="$node2/@ORDER"/>
	   </xsl:call-template>

	   <xsl:call-template name="navThumb">
		<xsl:with-param name="node" select="$node3"/>
		<xsl:with-param name="number" select="$node3/@ORDER"/>
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
   <xsl:variable name="imagePos" select="(count( $node/preceding-sibling::m:div[m:div//m:fptr]))"/>
	<!-- need class="on" on td if this cell has an image in it -->
		<!-- pos=left will always have content -->
		<!-- $imagePos &gt; 0 will be true when other divs have content -->
   <td>
<!-- xsl:value-of select="$order, $number, $imagePos"/ -->
	<xsl:choose>
	   <xsl:when test=" ( number($order) = number($number) and
				(  ($pos ='left') 
				   or ( $imagePos &gt; 0  and $pos != 'right')  
				) 
			    ) or $pos = 'breadThumbOn'">
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
<xsl:value-of select="$order"/>=
<xsl:value-of select="$number"/>|
<xsl:value-of select="$imagePos"/>*
<xsl:value-of select=" ( number($order) = number($number) and
				(  ($pos='left') or ( $imagePos &gt; 0 )  ) )
"/ -->
   <!-- xsl:choose>
     <xsl:when test="$node/m:div//m:fptr and ( ($imagePos &gt; 0) or ($pos = 'left') ) " -->
<xsl:if test="boolean($node)">
	<!-- do the // from a key?  would have to count this div's order;
		but we must already know that here -->
 	<xsl:variable name="naillink">
           <xsl:text>/</xsl:text>
           <xsl:value-of select="$page/m:mets/@OBJID"/>
           <xsl:text>/</xsl:text>
           <xsl:value-of select="
		if ($node/m:div[contains(@TYPE,'thumbnail')])
		then $node/m:div[contains(@TYPE,'thumbnail')][1]/m:fptr/@FILEID
		else (($node//m:div[contains(@TYPE,'thumbnail')][1]/m:fptr)[1])/@FILEID
	   "/>
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
           	<xsl:with-param name="x" select="
		if ($node/m:div[contains(@TYPE,'thumbnail')])
		then $node/m:div[contains(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:X
		else (($node//m:div[contains(@TYPE,'thumbnail')][1]/m:fptr)[1])/@cdl2:X"/>
           	<xsl:with-param name="y" select="
		if ($node/m:div[contains(@TYPE,'thumbnail')])
		then $node/m:div[contains(@TYPE,'thumbnail')][1]/m:fptr/@cdl2:Y
		else (($node//m:div[contains(@TYPE,'thumbnail')][1]/m:fptr)[1])/@cdl2:Y"/>
           </xsl:call-template>
   	</xsl:variable>



		<a href="{$nailref}" title="{$node/@LABEL}">
		<img border="0" width="{$xy/xy/@width}" height="{$xy/xy/@height}" src="{$naillink}"
			alt="{$node/@LABEL}"/>
		</a>
		<br/>
		<xsl:variable name="kidcount" select="count($node/m:div[m:div/m:fptr])"/>
	<xsl:choose>
	  <xsl:when test="not($node/@ORDER = $order)">
		<a href="{$nailref}" title="{$node/@LABEL}">
		<xsl:call-template name="navThumbKidCount">
			<xsl:with-param name="kidcount" select="$kidcount"/>
		</xsl:call-template>
		</a>
	  </xsl:when>
	  <xsl:otherwise>
		<xsl:call-template name="navThumbKidCount">
			<xsl:with-param name="kidcount" select="$kidcount"/>
		</xsl:call-template>
	  </xsl:otherwise>
	</xsl:choose>






</xsl:if>
   </td>
</xsl:template>

<xsl:template name="navThumbKidCount">
 <xsl:param name="kidcount"/>
		<xsl:if test="$kidcount = 1">1 item</xsl:if>
		<xsl:if test="$kidcount &gt; 1">
			<xsl:value-of select="$kidcount"/> items
		</xsl:if>
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
	<a href="/{$page/m:mets/@OBJID}/?order={number($order) - 1}{$brandCgi}"
	  title="{$page/key('absPos', number($order) - 1 )/@LABEL}">previous</a>
</xsl:if>
<xsl:if test="$imageIsBefore = 'true' and $imageIsNext = 'true'">
	<span class="bullet">|</span>
</xsl:if>
<xsl:if test="$imageIsNext = 'true'">
	<a href="/{$page/m:mets/@OBJID}/?order={number($order) + 1}{$brandCgi}"
	  title="{$page/key('absPos', number($order) + 1 )/@LABEL}">next</a>
</xsl:if>
</xsl:template>

<xsl:template match="insert-inner-content">
<xsl:comment>insert-inner-content @css-id:<xsl:value-of select="@css-id"/></xsl:comment>

<!-- xsl:copy-of select="$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference']"/ -->



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
  <xsl:variable name="largerImageLink">
<xsl:text>/</xsl:text>
<xsl:value-of select="$page/m:mets/@OBJID"/>
<xsl:text>/</xsl:text>
<xsl:value-of select="$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=(last() - number($mrsid-hack))]/m:fptr/@FILEID"/>
  </xsl:variable>
<a id="zoomMe" href="{$largerImageLink}" title="Larger Image">
  <img
        src="/{$page/m:mets/@OBJID}/{$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=1]/m:fptr/@FILEID}"
        width="{$xy/xy/@width}"
        height="{$xy/xy/@height}"
	border="0"
  /></a>
<xsl:call-template name="complex-image-zoom"/>
	</div>
     </div>
     <xsl:apply-templates select="*"/>
</div>
 </xsl:when>
 <xsl:otherwise/>
</xsl:choose>
</xsl:template>

<xsl:template name="complex-image-zoom">
<xsl:if test="($page/mets:mets/format[@q='jp2'] = 'jp2') or ($page/TEI.2/format[@q='jp2'] = 'jp2')">
<xsl:variable name="fileId" select="$focusDiv/m:div[starts-with(@TYPE,'reference') or @TYPE='image/reference'][position()=1]/m:fptr/@FILEID"/>
<xsl:variable name="seq" select="$page/m:mets/m:fileSec/m:fileGrp/m:file[@ID=$fileId]/@SEQ"/>
<xsl:variable name="zID">
	<xsl:text>z</xsl:text>
	<xsl:choose>
		<xsl:when test="$seq">
			<xsl:value-of select="$seq"/>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$focusDiv/@ORDER - 1"/>
		</xsl:otherwise>
	</xsl:choose>

</xsl:variable>

<script type="text/javascript">
<xsl:comment><xsl:text>
		document.getElementById('zoomMe').href =
    "http://192.35.209.153/Fullscreen.ics?ark=</xsl:text>
		<xsl:value-of select="$page/mets:mets/@OBJID"/>
		<xsl:text>/</xsl:text>
		<xsl:value-of select="$zID"/>
		<xsl:text>&amp;order=</xsl:text>
		<xsl:value-of select="$order"/>
		<xsl:text>";
</xsl:text>
</xsl:comment>
</script>
</xsl:if>

</xsl:template>

<xsl:template match="insert-inner-metadata">
<xsl:comment>insert-inner-metadata</xsl:comment>
<xsl:variable name="thisMODS">
	<xsl:choose>
	   <xsl:when test="number($order) = 1">
		<xsl:copy-of select="cdlview:MODS(($page/m:mets/m:dmdSec/m:mdWrap/m:xmlData/mods:mods)[1],'')"/>
	   </xsl:when>
	   <xsl:otherwise>
		<xsl:for-each select="tokenize($focusDiv/@DMDID, '\s')">
			<xsl:variable name="why" select="."/>
			<xsl:copy-of select="cdlview:MODS($page/key('md', $why )//mods:mods, '')"/>
		</xsl:for-each>
	   </xsl:otherwise>
	</xsl:choose>
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
		<xsl:apply-templates select="$page/m:mets/relation-from[@xtf:meta] | $page/../TEI.2/xtf:meta/relation-from" mode="fullDC"/>
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

