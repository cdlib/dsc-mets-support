<xsl:stylesheet version="1.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:mets="http://www.loc.gov/METS/"
><!-- copyright 2006 UC Regents; BSD License -->

 <!-- Checking the METS for brand is really just a placeholder -->
 <!-- They haven't been encoded with the appropriate behaviorSec yet -->
 <!-- will allow default brand to be set at item level if uncommented
      and used as @select="$brandName" on xsl:param[@name='brand'] below --> 
 <!-- xsl:variable name="brandMechURL" select="//mets:behavior[@BTYPE='brand']/mets:mechanism/@*[local-name()='href']"/>
  <xsl:variable name="brandMech" select="document($brandMechURL)"/>

  <xsl:variable name="brandName">
    <xsl:choose>
      <xsl:when test="$brandMech//brand">
        <xsl:value-of select="$brandMech//brand/@name"/>
      </xsl:when>
      <xsl:otherwise>
        <xsl:value-of select="'default'"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable -->



 <!-- This is populated by whatever value is used in the URL -->
  <xsl:param name="brand"/>

  <!-- Retrieve Branding Nodes -->
  <xsl:variable name="brand.file">
    <xsl:choose>
      <xsl:when test="$brand != ''">
        <xsl:copy-of select="document('/texts/xtf/brand/oac.xml')"/>
        <!-- xsl:copy-of select="document(concat('/texts/xtf/brand/',$brand,'.xml'))"/ -->
      </xsl:when>
      <xsl:otherwise>
        <xsl:copy-of select="document('../../brand/default.xml')"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <!-- default values pulled from default brand -->
  <xsl:variable name="default.brand.file" select="document('../../brand/default.cui.xml')"/>

  <xsl:variable name="brand.links" select="$brand.file/brand/links/*"/>
  <xsl:variable name="brand.header" select="$brand.file/brand/header/*"/>
  <xsl:variable name="brand.header.dynaxml.header" select="$brand.file/brand/header.dynaxml.header/*"/>
  <xsl:variable name="brand.footer" select="$brand.file/brand/footer/*"/>
  <xsl:variable name="brand.print.footer" select="$brand.file/brand/print.footer/*"/>
  <xsl:variable name="brand.search.box" select="$brand.file/brand/search.box/*"/>

  <xsl:variable name="brand.arrow.up">
    <xsl:choose>
	<xsl:when test="$brand.file/brand/arrow.up/@*">
	   <img>
  		<xsl:for-each select="$brand.file/brand/arrow.up/@*">
        	    <xsl:copy-of select="."/>
  		</xsl:for-each>
	   </img>
	</xsl:when>
	<xsl:otherwise>
	   <img>
  		<xsl:for-each select="$default.brand.file/brand/arrow.up/@*">
        	    <xsl:copy-of select="."/>
  		</xsl:for-each>
	   </img>
	</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="brand.arrow.dn">
    <xsl:choose>
	<xsl:when test="$brand.file/brand/arrow.dn/@*">
	   <img>
  		<xsl:for-each select="$brand.file/brand/arrow.dn/@*">
        	    <xsl:copy-of select="."/>
  		</xsl:for-each>
	   </img>
	</xsl:when>
	<xsl:otherwise>
	   <img>
  		<xsl:for-each select="$default.brand.file/brand/arrow.dn/@*">
        	    <xsl:copy-of select="."/>
  		</xsl:for-each>
	   </img>
	</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

  <xsl:variable name="brand.print.img">
    <xsl:choose>
	<xsl:when test="$brand.file/brand/print.img/@*">
	   <img>
  		<xsl:for-each select="$brand.file/brand/print.img/@*">
        	    <xsl:copy-of select="."/>
  		</xsl:for-each>
	   </img>
	</xsl:when>
	<xsl:otherwise>
	   <img>
  		<xsl:for-each select="$default.brand.file/brand/print.img/@*">
        	    <xsl:copy-of select="."/>
  		</xsl:for-each>
	   </img>
	</xsl:otherwise>
    </xsl:choose>
  </xsl:variable>

</xsl:stylesheet>
