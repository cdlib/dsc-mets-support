<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  version="2.0"
>
  <xsl:output indent="no" method="text" encoding="UTF-8" media-type="application/json"/>

  <xsl:variable name="page" select="/"/>

  <xsl:template match="/">
    <xsl:text>{"qdc":{</xsl:text>
      <!-- arbitrarily qualified dublin core 
           based on http://purl.org/dc/elements/1.1/, but designed before dcterms -->
      <xsl:for-each select="
        'title', 'creator', 'subject', 'description', 'publisher', 'contributor', 'date', 
        'type', 'format', 'identifier', 'source', 'language', 'relation', 'coverage', 'rights'">
        <xsl:call-template name="dc-json-element">
          <xsl:with-param name="element-name" select="."/>
        </xsl:call-template>
      </xsl:for-each>
    <xsl:text>}}</xsl:text>
  </xsl:template>

  <xsl:template name="dc-json-element">
    <xsl:param name="element-name"/>
    <xsl:variable name="element-count" select="count($page/qdc/*[name()=$element-name][text()])"/>
    <xsl:if test="$element-count &gt; 0">
      <xsl:text>"</xsl:text>
      <xsl:value-of select="$element-name"/>
      <xsl:text>":</xsl:text>
      <xsl:choose>
        <xsl:when test="$element-count = 1">
          <xsl:apply-templates select="$page/qdc/*[name()=$element-name]"/>
        </xsl:when>
        <xsl:otherwise>
          <xsl:text>[</xsl:text>
          <xsl:apply-templates select="$page/qdc/*[name()=$element-name]"/>
          <xsl:text>],</xsl:text>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:if>
  </xsl:template>

  <xsl:template match="*[text()][not(@q)]">
    <xsl:text>"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>",</xsl:text>
  </xsl:template>

  <xsl:template match="*[text()][@q]">
    <xsl:text>{"q":"</xsl:text>
    <xsl:value-of select="@q"/>
    <xsl:text>","v":"</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"},</xsl:text>
  </xsl:template>

</xsl:stylesheet>
