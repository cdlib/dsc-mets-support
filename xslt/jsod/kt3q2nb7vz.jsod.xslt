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
                version="2.0"
		xmlns:exslt="http://exslt.org/common"
                extension-element-prefixes="exslt"
                exclude-result-prefixes="#all">
<xsl:import href="../view/kt3q2nb7vz.xslt"/>
<xsl:output indent="no" method="text" encoding="UTF-8" media-type="text/javascript"/>
<xsl:variable name="page" select="/"/>
<xsl:template match="/">
	 <xsl:call-template name="jsod-printable-metadata"/>
</xsl:template>

</xsl:stylesheet>
