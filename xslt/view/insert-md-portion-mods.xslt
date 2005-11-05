<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:m="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:cdl2="http://www.cdlib.org/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:mods="http://www.loc.gov/mods/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                version="1.0"
                exclude-result-prefixes="xlink mets mods xsl cdl cdl2 dc dcterms">
  
      
      <xsl:template match="insert-metadataPortion">

        <!-- Creator Metadata -->
        <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:name">
          <p><span class="listingTitle">Creator:</span><br/>
          <span class="listing">
<xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:name/mods:namePart"/></span></p>
        </xsl:if>
        <!-- Date Metadata -->
        <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateIssued | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateCreated | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateCaptured | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateOther">
          <p><span class="listingTitle">Date:</span><br/>
          <xsl:for-each select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateIssued | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateCreated | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateCaptured | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:dateOther">
            <span class="listing"><xsl:value-of select="."/></span><br/>
          </xsl:for-each></p>
        </xsl:if>
        <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:publicationInfo/mods:dateIssued">
          <p><span class="listingTitle">Date:</span><br/>
          <span class="listing"><xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:publicationInfo/mods:dateIssued"/></span></p>
        </xsl:if>
        <!-- Physical Description Metadata -->
        <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:physicalDescription">
          <p><span class="listingTitle">Physical Description:</span><br/>
          <xsl:for-each select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:physicalDescription/mods:extent | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:physicalDescription/mods:form | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:physicalDescription/mods:internetMediaType | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:physicalDescription/mods:digitalOrigin | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:physicalDescription/mods:note">
            <span class="listing"><xsl:value-of select="."/></span><br/>
          </xsl:for-each>
        </p>
      </xsl:if>
      <!-- Notes Metadata -->
      <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:note">
        <p><span class="listingTitle">Notes:</span><br/>
        <xsl:for-each select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:note">
          <span class="listing"><xsl:value-of select="."/></span><br/>
        </xsl:for-each>
      </p>
    </xsl:if>
    <!-- Subjects Metadata -->
    <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:subject">
      <p><span class="listingTitle">Subjects:</span><br/>
      <xsl:for-each select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:subject/mods:*">
        <span class="listing"><xsl:value-of select="."/></span><br/>
      </xsl:for-each>
    </p>
  </xsl:if>
  <!-- Credit Line/Provenance Metadata -->
  <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:note[@type='provenance'] | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:note[@TYPE='provenance']">
    <p><span class="listingTitle">Credit Line/Provenance:</span><br/>
    <span class="listing"><xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:note[@type='provenance'] | $page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:note[@TYPE='provenance']"/></span></p>
  </xsl:if>
  <!-- Place of Origin Metadata -->
  <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:publicationInfo/mods:place">
    <p><span class="listingTitle">Place of Origin:</span><br/>
    <span class="listing"><xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:publicationInfo/mods:place"/></span></p>
  </xsl:if>
  <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:place">
    <p><span class="listingTitle">Place of Origin:</span><br/>
    <span class="listing">
      <xsl:for-each select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:originInfo/mods:place/*">
        <xsl:value-of select="."/><br/>
      </xsl:for-each>
    </span></p>
  </xsl:if>
  <!-- Language Metadata -->
  <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language">
    <p><span class="listingTitle">Language:</span><br/>
    <span class="listing">
      <xsl:choose>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'eng'">
          <xsl:text>English</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'spa'">
          <xsl:text>Spanish</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'ger'">
          <xsl:text>German</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'fre'">
          <xsl:text>French</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'ita'">
          <xsl:text>Italian</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'rus'">
          <xsl:text>Russian</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'por'">
          <xsl:text>Portuguese</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'gre'">
          <xsl:text>Greek</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'ara'">
          <xsl:text>Arabic</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'chi'">
          <xsl:text>Chinese</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'dut'">
          <xsl:text>Dutch</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'heb'">
          <xsl:text>Hebrew</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'jpn'">
          <xsl:text>Japanese</xsl:text>
        </xsl:when>
        <xsl:when test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language = 'kor'">
          <xsl:text>Korean</xsl:text>
        </xsl:when>
        <xsl:otherwise>
          <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:language"/>
        </xsl:otherwise>
      </xsl:choose></span></p>
    </xsl:if>
    <!-- Identifier Metadata -->
    <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier">
      <p><span class="listingTitle">Identifier:</span><br/>
      <span class="listing"><xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:identifier"/></span></p>
    </xsl:if>
    <!-- From Metadata -->
    <p><span class="listingTitle">From:</span><br/>
    <span class="listing">
      <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdRef[@MDTYPE='EAD']">
        <a href="{$page/m:mets/m:dmdSec/m:mdRef[@MDTYPE='EAD']/@*[local-name(.)='href']}">
<xsl:value-of select="$page/m:mets/m:dmdSec[@ID='DMR2']/m:mdRef/@LABEL"/></a>
<xsl:apply-templates select="$page/m:mets/m:dmdSec/m:mdWrap/m:xmlData/mods:mods/mods:relatedItem[@type='host']" mode="recursive"/>
      </xsl:if>
    </span></p>
    <!-- Repository Metadata -->
    <p><span class="listingTitle">Repository:</span><br/>
<span class="listing">
	<xsl:apply-templates 
select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:location/mods:physicalLocation" mode="mods"/>

    </span></p>

    <!-- Suggested Citation Metadata -->
    <p><span class="listingTitle">Suggested Citation:</span><br/>
    <span class="listing">[Identification of Item]. Available from the Online Archive of California; 
    <xsl:text>http://ark.cdlib.org/</xsl:text>
    <xsl:value-of select="$page/mets:mets/@OBJID"/>
    <xsl:text>.</xsl:text>
  </span></p>
  <!-- Terms and Conditions of Use Metadata -->
  <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:accessCondition">
    <p><span class="listingTitle">Terms and Conditions of Use:</span><br/>
    <span class="listing"><xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:accessCondition"/></span></p>
  </xsl:if>
</xsl:template>

<xsl:template match="mods:relatedItem" mode="recursive">; <xsl:value-of select="mods:titleInfo/mods:title"/>
	<xsl:apply-templates select="mods:relatedItem" mode="recursive"/>
</xsl:template>

<xsl:template match="mods:physicalLocation" mode="mods">
	<xsl:variable name="string">
		<xsl:value-of select="text()"/>
	</xsl:variable>
   	<xsl:choose>
		<xsl:when test="substring-after($string,'http://')">
			<a href="http://{substring-after($string,'http://')}">
			<xsl:value-of select="$string"/>
			</a>
		</xsl:when>
		<xsl:otherwise>
			<xsl:value-of select="$string"/>
		</xsl:otherwise>
   	</xsl:choose>
</xsl:template>


</xsl:stylesheet>
