<?xml version="1.0"?>
<xsl:stylesheet version="1.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xlink="http://www.w3.org/TR/xlink" 
xmlns:n1="http://www.loc.gov/METS/"
xmlns:n2="http://countingcalifornia.cdlib.org/mets/profiles/2003"
xmlns:xsd="http://www.w3.org/2001/XMLSchema"> 

<xsl:output method="html"/>

<xsl:template match="/">
	<html>
		<head>
			<title>Congressional Research Service, Library of Congress</title>
			<link type="text/css" rel="stylesheet" href="http://countingcalifornia.cdlib.org/styles/web.css"/>
		</head>
		<body>	
			<div align="center"> <a
			href="http://countingcalifornia.cdlib.org/crs/"><img
			border="0" alt="Counting California"
			src="http://countingcalifornia.cdlib.org/images/countingcalifornia.gif"/>
			</a>
			</div>

			<xsl:apply-templates select="n1:mets"/>

<div class="publicdl-bottom-bar"></div>
<div class="footerLeft">
<img class="publicdl-footer" src="/images/cdlogo.gif" width="38" height="36" alt=""/>
</div>
<div class="footerRight">
Brought to you by the <a href="http://www.universityofcalifornia.edu/cultural/libraries.html">University of California Libraries</a>. Powered by the <a href="http://www.cdlib.org/about/">CDL</a>.<br />

</div>
		</body>
	</html>
</xsl:template>

<xsl:template match="n1:mets">

	<xsl:variable name="goascii">
		<xsl:text>http://ark.cdlib.org/</xsl:text><xsl:value-of select="/n1:mets/@OBJID"/><xsl:text>/fptr1</xsl:text>
	</xsl:variable>

	<xsl:variable name="gopdf">
		<xsl:text>http://ark.cdlib.org/</xsl:text><xsl:value-of select="/n1:mets/@OBJID"/><xsl:text>/fptr2</xsl:text>
	</xsl:variable>


	<xsl:variable name="source">
		<xsl:value-of select="n1:dmdSec/n1:mdWrap/n1:xmlData/n2:dcFlds/n2:digObj/n2:creator"/>
	</xsl:variable>

	<xsl:if test="n1:dmdSec[@ID='CDLXML']">
		<p>
		<xsl:value-of select="normalize-space(n1:dmdSec/n1:mdWrap/n1:xmlData/n2:dcFlds/n2:digObj/n2:title/text())"/>
		<ul>
		<li><a href="{$goascii}">ascii</a></li>
		<li><a href="{$gopdf}">pdf</a></li>
		</ul>
		</p>
		<p>Source: <xsl:value-of select="$source"/></p>

		Report ID:  <xsl:value-of select="n1:dmdSec/n1:mdWrap/n1:xmlData/n2:dcFlds/n2:digObj/@id"/>

	</xsl:if>

</xsl:template>


</xsl:stylesheet>
