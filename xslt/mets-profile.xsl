<xsl:stylesheet
   version="2.0"
   xmlns:mets-profiles="http://www.cdlib.org/mets/profiles"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>

<xsl:function name="mets-profiles:URItoDisplayXslt">
 <xsl:param name="profile"/>

<xsl:variable name="file" select="document('../driver.xml')/mets-profiles/mets-profile-driver[PROFILE = $profile]/
					tool[@type='xslt'][@role='toHTML']"/>
<xsl:if test="$file">

<xsl:analyze-string 
	select="$file"
	regex=".*/(.*)$">

  <xsl:matching-substring>
	<xsl:text>style/dynaXML/docFormatter/mets/</xsl:text><xsl:value-of select="regex-group(1)"/>
  </xsl:matching-substring>

</xsl:analyze-string>

</xsl:if>

</xsl:function>

</xsl:stylesheet>
