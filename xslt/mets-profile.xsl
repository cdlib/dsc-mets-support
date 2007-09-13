<xsl:stylesheet
   version="2.0"
   xmlns:mets-profiles="http://www.cdlib.org/mets/profiles"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	>

<xsl:function name="mets-profiles:URItoDisplayXslt">
	<xsl:param name="profile"/>
	<xsl:variable name="driver" select="document('../driver.xml')"/>
	<xsl:variable name="file" 
		select="$driver/mets-profiles/mets-profile-driver[PROFILE = $profile]/
					tool[@type='xslt'][@role='toHTML']"/>
	<xsl:if test="$file">
		<!-- xsl:value-of select="base-uri($driver)"/ -->
		<xsl:text>mets-support/</xsl:text>
		<xsl:value-of select="$file"/>
	</xsl:if>
</xsl:function>

<xsl:function name="mets-profiles:URItoJsodXslt">
	<xsl:param name="profile"/>
	<xsl:variable name="driver" select="document('../driver.xml')"/>
	<xsl:variable name="file" 
		select="$driver/mets-profiles/mets-profile-driver[PROFILE = $profile]/
					tool[@type='xslt'][@role='toJsod']"/>
	<xsl:if test="$file">
		<!-- xsl:value-of select="base-uri($driver)"/ -->
		<xsl:text>mets-support/</xsl:text>
		<xsl:value-of select="$file"/>
	</xsl:if>
</xsl:function>

</xsl:stylesheet>
