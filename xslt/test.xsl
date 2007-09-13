<xsl:stylesheet
   version="2.0"
   xmlns:mp="http://www.cdlib.org/mets/profiles"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>

<xsl:include href="mets-profile.xsl"/>

<xsl:template match="/">
<xsl:copy-of select="mp:URItoDisplayXslt('http://ark.cdlib.org/ark:/13030/kt8s20152f')"/>
---------
<xsl:copy-of select="mp:URItoDisplayXslt('http://www.loc.gov/standards/mets/profiles/00000002.xml')"/>
---------
<xsl:copy-of select="mp:URItoDisplayXslt('http://www.loc.gov/standards/mets/profiles/00000003.xml')"/>
---------
<xsl:copy-of select="mp:URItoDisplayXslt('http://www.loc.gov/standards/mets/profiles/00000004.xml')"/>
---------
<xsl:copy-of select="mp:URItoDisplayXslt('http://www.loc.gov/mets/profiles/00000010.xml')"/>
---------
<xsl:copy-of select="mp:URItoDisplayXslt('http://www.loc.gov/mets/profiles/00000013.xml')"/>
---------

</xsl:template>

</xsl:stylesheet>
