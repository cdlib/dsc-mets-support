<!-- created 8/3/06 by SR for WAS as a wrapper
     for MODS plus admin-dc extraction -->
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xlink="http://www.w3.org/TR/xlink" 
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:mets="http://www.loc.gov/METS/"
  xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/" 
  xmlns:dcterms="http://purl.org/dc/terms/" 
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:mods="http://www.loc.gov/mods/v3" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:import href="ADMIN-DC.qdc.xslt"/> 
  <xsl:import href="MODSv32DC_sr.qdc.xsl"/> 
</xsl:stylesheet>
