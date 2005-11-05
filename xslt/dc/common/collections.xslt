<?xml version="1.0"?>
<xsl:stylesheet version="2.0" 
xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
xmlns:xlink="http://www.w3.org/TR/xlink" 
xmlns:vc="http://www.cdlib.org/collections/">

<xsl:variable name="collections" select="document('collections.xml')"/>

<xsl:function name="vc:lookParent">
  <xsl:param name="parent"/>
  <xsl:copy-of select="$collections/collections/vc/added[../when=$parent]"/>
  <xsl:copy-of select="$collections/collections/vc/added/when"/>
  <xsl:if test="$collections/collections/vc/added[when=$parent]">
	<xsl:copy-of select="$collections/collections/vc/added[when=$parent]"/>
  </xsl:if>
</xsl:function>



</xsl:stylesheet>
