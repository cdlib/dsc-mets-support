<?xml version="1.0" encoding="utf-8"?>
<!-- profile for profiles display xslt -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                version="1.0">

  <xsl:output method="html"/>

  <xsl:template match="/">

<html>
<head>
<style  type="text/css">div.gx { padding: 5px; border:1px dashed #ccc; } </style>
<link rel="stylesheet" href="http://www.cdlib.org/styles/insidecdl-basic.css" type="text/css" />
<link rel="stylesheet" href="http://www.cdlib.org/styles/insidecdl-print.css" type="text/css" media="print" />

</head>
<body>
<div class="box-wrap">
        <div class="header"><div class="header-column-one"><a href="http://www.cdlib.org/inside/"><img src="http://www.cdlib.org/images/banner.inside.gif" alt="Inside CDL" width="176" height="25" border="0" /></a> </div>
<div class="header-column-two"><img src="/images/spacer.gif" alt="" width="1" height="20" border="0" /><a class="topnav" href="http://www.cdlib.org/inside/"> Inside CDL</a> | <a class="topnav" href="http://www.cdlib.org/">CDL Home</a> | <a class="topnav" href="http://www.cdlib.org/inside/search/">Search</a> | <a class="topnav" href="http://www.cdlib.org/inside/contact/">Contact the CDL</a></div> 
</div>
        <div class="columns-float">
        <div class="column-one">
        <div class="column-one-content">

  </div>
        </div>
        <div class="column-two">
        <div class="column-two-content">         
        
        <div class="doc-body">


<h1><xsl:value-of select="/m:mets/m:dmdSec/m:mdWrap/m:xmlData/METS_Profile/title"/></h1>
<xsl:apply-templates select="/m:mets/m:structMap"/>
<xsl:apply-templates select="/m:mets/m:dmdSec/m:mdWrap/m:xmlData/METS_Profile"/>
<a href="http://ark.cdlib.org/raw/{m:mets/@OBJID}/">raw xml of METS <xsl:value-of select="m:mets/@OBJID"/></a>

 </div>
        </div>
        <div class="footer"><a href="/inside/feedback/">Questions? Comments?</a><br /><br />
Copyright <xsl:text disable-output-escaping="yes"><![CDATA[&copy;]]></xsl:text> 2003 The Regents of the University of California<br /><br />
</div>
        </div>
        </div>
        </div>
        </body>
        </html>

</xsl:template>

<xsl:template match="m:structMap">
<xsl:apply-templates/>
</xsl:template>

<xsl:template match="m:div">
<xsl:choose>
  <xsl:when test="m:fptr">
    <xsl:variable name="link"><xsl:value-of select="substring(/@OBJID,12)"/>/<xsl:value-of select="m:fptr/@FILEID"/></xsl:variable>
    <ul><li>
<b>
     <a href="{m:fptr/@FILEID}"><xsl:value-of select="@LABEL"/></a></b>
    <xsl:apply-templates/>
    </li></ul>
  </xsl:when>
  <xsl:otherwise>
     <ul><li><b><xsl:value-of select="@LABEL"/></b></li>
    <xsl:apply-templates/>
    </ul> 
  </xsl:otherwise>
</xsl:choose>
</xsl:template>

<xsl:template match="Appendix"/>
<xsl:template match="m:fptr"/>

<xsl:template match="*">
<div class="gx">
<a href="http://ark.cdlib.org/mets/profile_schema_documentation/#{name()}"><xsl:value-of select="name()"/>:</a>
<xsl:for-each select="@*">
@<xsl:value-of select="name()"/>=&quot;<xsl:value-of select="."/>&quot;
</xsl:for-each><br/>
<xsl:apply-templates/>
</div>
</xsl:template>

<xsl:template match="p">
<p><xsl:value-of select="."/></p>
</xsl:template>

<xsl:template match="a">
<a><xsl:if test="@href"><xsl:attribute name="href"><xsl:value-of select="@href"/></xsl:attribute></xsl:if><xsl:value-of select="."/>
</a>
</xsl:template>

<xsl:template match="URI">
<xsl:if test="text()"><div>
<a href="{.}"><xsl:value-of select="@LOCTYPE"/>: <xsl:value-of select="."/></a></div>
</xsl:if>
</xsl:template>



</xsl:stylesheet>
