<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xlink="http://www.w3.org/TR/xlink" 
xmlns:n1="http://www.loc.gov/METS/"
xmlns:n2="http://www.icpsr.umich.edu/DDI"
xmlns:n3="http://countingcalifornia.cdlib.org/mudd.service"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"> 

<xsl:output method="html"/>

<xsl:template match="/">
<html>
<head>
<title>Counting California</title>
<link type="text/css" rel="stylesheet"
    href="http://countingcalifornia.cdlib.org/styles/web.css"/>
</head>
<body>	
<div align="center">
<img src="http://countingcalifornia.cdlib.org/images/2ndlevel.gif" width="640" height="89" border="0" alt="Counting California Navigation Bar" usemap="#2ndlevel"/>

<map name="2ndlevel">
<area shape="rect" coords="0,5,276,58" href="http://countingcalifornia.cdlib.org" title="Counting California" alt="Counting California"/>
<area shape="rect" coords="581,43,623,59" href="http://countingcalifornia.cdlib.org/cms.search.html" title="Search" alt="Search"/>
<area shape="rect" coords="522,42,565,59" href="http://countingcalifornia.cdlib.org/provider/" title="Agency" alt="Agency"/>
<area shape="rect" coords="471,43,506,60" href="http://countingcalifornia.cdlib.org/title/" title="Titles" alt="Titles"/>
<area shape="rect" coords="396,43,458,60" href="http://countingcalifornia.cdlib.org/geography/" title="Geography" alt="Geography"/>
<area shape="rect" coords="341,43,382,59" href="http://countingcalifornia.cdlib.org/topics.html" title="Topics" alt="Topics"/>
<area shape="rect" coords="262,65,302,80" href="http://countingcalifornia.cdlib.org/help.html" title="Help" alt="Help"/>
<area shape="rect" coords="206,63,250,82" href="http://countingcalifornia.cdlib.org/news.html" title="News" alt="News"/>
<area shape="rect" coords="137,64,193,82" href="http://countingcalifornia.cdlib.org/feedback.html" title="Feedback" alt="Feedback"/>
<area shape="rect" coords="66,64,123,80" href="http://countingcalifornia.cdlib.org/about.html" title="About Us" alt="About Us"/>
<area shape="rect" coords="11,64,53,80" href="http://countingcalifornia.cdlib.org" title="Home" alt="Home"/>
</map>

</div>

<xsl:apply-templates select="n1:mets"/>
</body>
</html>
</xsl:template>

<xsl:template match="n1:mets">

	<xsl:variable name="golink">
		<xsl:text>http://ark.cdlib.org/</xsl:text><xsl:value-of select="/n1:mets/@OBJID"/><xsl:text>/fptr1</xsl:text>
	</xsl:variable>

	<xsl:variable name="source">
		<xsl:value-of select="n1:dmdSec[@ID='DDI1-2']/n1:mdWrap/n1:xmlData/n2:codeBook/n2:stdyDscr/n2:citation/n2:titlStmt/n2:titl"/>
	</xsl:variable>

	<xsl:variable name="studylink">
		<xsl:text>http://countingcalifornia.cdlib.org/title/</xsl:text><xsl:value-of select="/n1:mets/n1:metsHdr/n1:altRecordID[@TYPE='CDLstudy']"/><xsl:text>.html</xsl:text>
	</xsl:variable>

	<xsl:if test="n1:dmdSec[@ID='datadictionary-tbl']">
		<div align="center">
		<p>
		<table cellspacing="10">
		<tr>
		<td>Table Title:</td>
		<td><a href="{$golink}"><xsl:value-of select="/n1:mets/@LABEL"/></a></td></tr>
		<tr><td>Source:</td>
		<td><a href="{$studylink}"><xsl:value-of select="$source"/></a></td></tr>
		<tr><td colspan="2">
		<xsl:value-of select="/n1:mets/n1:dmdSec[@ID='datadictionary-tbl']/n1:mdWrap/n1:xmlData/n3:tbl/n3:universe[@source='producer']"/></td></tr>
		<tr><td>Table ID:</td>
		<td><xsl:value-of select="/n1:mets/n1:dmdSec[@ID='datadictionary-tbl']/n1:mdWrap/n1:xmlData/n3:tbl/@id"/>
		</td></tr>
		<tr><td valign="top">Topic(s):</td>
		<td><xsl:for-each select="/n1:mets/n1:dmdSec[@ID='datadictionary-tbl']/n1:mdWrap/n1:xmlData/n3:tbl/n3:concept"><xsl:value-of select="."/><br/></xsl:for-each>
		</td></tr>
		</table>
		</p>
		</div>

	</xsl:if>

</xsl:template>


</xsl:stylesheet>
