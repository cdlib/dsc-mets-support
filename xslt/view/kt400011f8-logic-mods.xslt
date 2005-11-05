<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xlink="http://www.w3.org/TR/xlink"
                xmlns:mets="http://www.loc.gov/METS/"
                xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:mods="http://www.loc.gov/mods/"
                xmlns:dcterms="http://purl.org/dc/terms/"
                version="1.0"
                exclude-result-prefixes="xlink mets mods xsl cdl dc dcterms">
<xsl:import href="brandCommon.xsl"/>

  <xsl:output method="html"/>

  <xsl:output doctype-public="-//W3C//DTD XHTML 1.0 Transitional//EN" doctype-system="http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd"/>

  <!-- xsl:include href="imagePortion.xslt"/ -->
  <!-- xsl:include href="metadataPortion-DC.xslt"/ -->
  <!-- xsl:include href="metadataPortion-Mods.xslt"/ -->

  <xsl:variable name="page" select="/"/>
  <xsl:variable name="layout" select="document('imageDisplayStructure.xml')"/>
<xsl:param name="brand" select="'oac'"/>

  <xsl:template match="/">
    <xsl:apply-templates select="$layout/html"/>
  </xsl:template>

  <xsl:template match="@*|*">
    <xsl:copy>
      <xsl:apply-templates select="@*|node()"/>
    </xsl:copy>
  </xsl:template>

<xsl:template match="insert-brand-links">
 <xsl:copy-of select="$brand.links"/>
</xsl:template>

<xsl:template match="insert-brand-head">
 <xsl:copy-of select="$brand.header"/>
</xsl:template>

<xsl:template match="insert-brand-footer">
 <xsl:copy-of select="$brand.footer"/>
</xsl:template>



  <!-- xsl:template match="nbsp"><![CDATA[&nbsp;]]></xsl:template -->
    
  <!-- xsl:template match="copy"><![CDATA[&copy;]]></xsl:template -->
  
  <!-- xsl:template match="bullet"><![CDATA[&#8226;]]></xsl:template -->
  
  <xsl:template match="insert-head-title">
    <title>OAC: <xsl:value-of select="$page/mets:mets/@LABEL"/></title>
  </xsl:template>

  <xsl:template match="insert-breadcrumb">
    <a href="http://findaid.oac.cdlib.org/search.image.html">Images</a>&#160;&#160;&gt;&#160; 
    <a>
      <xsl:attribute name="href">
        <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='ead']/mets:mdRef/@xlink:href"/>
      </xsl:attribute>
      <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='ead']/mets:mdRef/@LABEL"/>
    </a>
  </xsl:template>
  
  <xsl:template match="insert-pagetitle">
    <xsl:value-of select="$page/mets:mets/@LABEL"/>
  </xsl:template>
  
  <xsl:template match="insert-imagePortion">
    <xsl:choose>
      <xsl:when test="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE]">
        <xsl:for-each select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file/mets:FLocat[@xlink:role='thumbnail']">
          <xsl:variable name="imageGroup">
            <xsl:value-of select="parent::mets:file/@GROUPID"/>
          </xsl:variable>
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
              <xsl:when test="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
              </xsl:when>
              <xsl:otherwise>
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='hi-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
              </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
          <img>
            <xsl:attribute name="src">
              <xsl:text>http://ark.cdlib.org/</xsl:text>
              <xsl:value-of select="$page/mets:mets/@OBJID"/>
              <xsl:text>/</xsl:text>
              <xsl:value-of select="parent::mets:file/@ID"/>
            </xsl:attribute>
            <xsl:attribute name="alt">
              <xsl:text>Thumbnail Image: </xsl:text>
              <xsl:value-of select="$page/mets:mets/@LABEL"/>
            </xsl:attribute>
            <xsl:attribute name="border">
              <xsl:text>0</xsl:text>
            </xsl:attribute>
          </img>
          </a>
          <p>
            <span class="listingTitle">View Options:</span><br/>
            <xsl:if test="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']">
              <a class="listing">
                <xsl:attribute name="href">
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='med-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
                </xsl:attribute>
                <xsl:text>Medium Image</xsl:text>
              </a>
              <br/>
            </xsl:if>
            <a class="listing">
              <xsl:attribute name="href">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp[@USE='hi-res']/mets:file[@GROUPID=$imageGroup]/@ID"/>
              </xsl:attribute>
              <xsl:text>Large Image</xsl:text>
            </a></p>
          </xsl:for-each>
        </xsl:when>
        <xsl:otherwise>
          <a>
            <xsl:attribute name="href">
              <xsl:choose>
                <xsl:when test="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']">
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']/@ID"/>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='hi-res']/@ID"/>
                </xsl:otherwise>
              </xsl:choose>
            </xsl:attribute>
            <img>
              <xsl:attribute name="src">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='thumbnail']/@ID"/>
              </xsl:attribute>
              <xsl:attribute name="border">
                <xsl:text>0</xsl:text>
              </xsl:attribute>
            </img>
          </a>
          <p>
            <span class="listingTitle">View Options:</span><br/>
            <xsl:if test="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']">
              <a class="listing">
                <xsl:attribute name="href">
                  <xsl:text>http://ark.cdlib.org/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/@OBJID"/>
                  <xsl:text>/</xsl:text>
                  <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='med-res']/@ID"/>
                </xsl:attribute>
                <xsl:text>Medium Image</xsl:text>
              </a>
              <br/>
            </xsl:if>
            <a class="listing">
              <xsl:attribute name="href">
                <xsl:text>http://ark.cdlib.org/</xsl:text>
                <xsl:value-of select="$page/mets:mets/@OBJID"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$page/mets:mets/mets:fileSec/mets:fileGrp/mets:file[@ID='hi-res']/@ID"/>
              </xsl:attribute>
              <xsl:text>Large Image</xsl:text>
            </a></p>
          </xsl:otherwise>
        </xsl:choose>
      </xsl:template>
      
      <xsl:template match="insert-metadataPortion">
        <!-- Creator Metadata -->
        <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:name/mods:role='creator'">
          <p><span class="listingTitle">Creator:</span><br/>
          <span class="listing"><xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:name/mods:namePart"/></span></p>
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
      <xsl:if test="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:relatedItem[@type='series']">
        <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/mods:mods/mods:relatedItem[@type='series']/mods:titleInfo/mods:title"/><br/>
      </xsl:if>
      <xsl:for-each select="$page/mets:mets/mets:dmdSec[@ID='ead']">
        <a>
          <xsl:attribute name="href">
            <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='ead']/mets:mdRef/@xlink:href"/>
          </xsl:attribute>
          <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='ead']/mets:mdRef/@LABEL"/>
        </a>
      </xsl:for-each>
    </span></p>
    <!-- Repository Metadata -->
    <p><span class="listingTitle">Repository:</span><br/>
    <span class="listing">
      <a>
        <xsl:attribute name="href">
          <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:identifier[2]"/>
        </xsl:attribute>
        <xsl:value-of select="$page/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
      </a>      
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

<xsl:template match="insert-institution-url">
  <a>
    <xsl:attribute name="href">
      <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:identifier[2]"/>
    </xsl:attribute>
    <xsl:value-of select="$page/mets:mets/mets:dmdSec/mets:mdWrap/mets:xmlData/cdl:qualifieddc/dc:title"/>
  </a>
</xsl:template>

</xsl:stylesheet>
