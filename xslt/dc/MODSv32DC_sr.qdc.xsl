<!-- this stylesheet is a copy of MODSv32DC_pf.qdc.xsl for WAS. Had to correct an error with the description template, the other file is writable only by PF -->
<!-- this version relies on a template in ADMIN-DC xslt -->
<xsl:stylesheet version="1.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
  xmlns:xlink="http://www.w3.org/TR/xlink" 
  xmlns:xsd="http://www.w3.org/2001/XMLSchema"
  xmlns:mets="http://www.loc.gov/METS/"
  xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/" 
  xmlns:dcterms="http://purl.org/dc/terms/" 
  xmlns:dc="http://purl.org/dc/elements/1.1/" 
  xmlns:mods="http://www.loc.gov/mods/v3" 
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">

  <xsl:strip-space elements="*"/>

  <xsl:output method="xml" indent="no"/>

  <xsl:template match="/">
    <xsl:apply-templates select="mets:mets"/>
  </xsl:template>

  <xsl:template match="mets:mets">
    <qdc>
      <xsl:call-template name="title"/>
      <xsl:call-template name="creator"/>
      <xsl:call-template name="subject"/>
      <xsl:call-template name="description"/>
      <xsl:call-template name="publisher"/>
      <xsl:call-template name="contributor"/>
      <xsl:call-template name="date"/>
      <xsl:call-template name="type"/>
      <xsl:call-template name="format"/>
      <xsl:call-template name="identifier"/>
      <xsl:call-template name="source"/>
      <xsl:call-template name="language"/>
      <xsl:call-template name="relation"/>
      <xsl:call-template name="coverage"/>
      <xsl:call-template name="rights"/>
      <xsl:call-template name="dcterms"/>
      <!-- this template is in ADMIN-DC.qdc.xslt -->
      <xsl:call-template name="cdl-qdc" />
    </qdc>
  </xsl:template>
  
  <xsl:template name="title">
<![CDATA[
]]>
    <title>
      <xsl:value-of select="//mods:mods/mods:titleInfo/mods:title"/>
      <xsl:if test="//mods:mods/mods:titleInfo/mods:subTitle">
        <xsl:text>: </xsl:text>
        <xsl:value-of select="//mods:mods/mods:titleInfo/mods:subTitle"/>
      </xsl:if>
    </title>
  </xsl:template>
  
  <xsl:template name="creator">
<![CDATA[
]]>
    <!-- xsl:if test="contains(//mods:mods/mods:name/mods:role/mods:text, 'creator')" -->
      <!-- creator-->
        <!-- xsl:value-of select="//mods:mods/mods:name[1]/mods:namePart"/-->
      <!--/creator-->
    <!--/xsl:if-->
    <xsl:if test="contains(//mods:mods/mods:name/mods:role, 'creator')">
      <creator>
        <xsl:value-of select="//mods:mods/mods:name[1]/mods:namePart"/>
      </creator>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:recordInfo/mods:recordContentSource">
      <creator>
        <xsl:value-of select="//mods:mods/mods:recordInfo/mods:recordContentSource"/>
      </creator>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="subject">
<![CDATA[
]]>
    <xsl:for-each select="//mods:mods/mods:subject/mods:topic">
      <subject>
        <xsl:value-of select="."/>
      </subject>
    </xsl:for-each>
    <xsl:for-each select="//mods:mods/mods:subject/mods:name">
      <subject>
        <xsl:value-of select="."/>
      </subject>
    </xsl:for-each>
    <!--xsl:for-each select="//mods:mods/mods:name"-->
      <!--subject-->
        <!--xsl:for-each select="mods:namePart"-->
          <!--xsl:if test="position()&gt;1"-->
            <!--xsl:text> </xsl:text-->
          <!--/xsl:if-->
          <!--xsl:value-of select="."/-->
        <!--/xsl:for-each-->
      <!--/subject-->
    <!--/xsl:for-each-->
    <xsl:if test="//mods:mods/mods:subject/mods:titleInfo/mods:title">
      <subject>
        <xsl:value-of select="//mods:mods/mods:subject/mods:titleInfo/mods:title"/>
      </subject>
    </xsl:if>
  </xsl:template>

  <xsl:template name="description">
<![CDATA[
]]>
    <xsl:if test="//mods:mods/mods:abstract">
      <description>
        <xsl:value-of select="//mods:mods/mods:abstract"/>
      </description>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:tableOfContents">
      <description>
        <xsl:value-of select="//mods:mods/mods:tableOfContents"/>
      </description>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:physicalDescription/*">
      <xsl:for-each select="//mods:mods/mods:physicalDescription/*">
        <description>
          <!--xsl:value-of select="//mods:mods/mods:physicalDescription/*"/-->
          <xsl:value-of select="."/>
        </description>
      </xsl:for-each>
    </xsl:if>
    <xsl:for-each select="//mods:mods/mods:note">
      <description>
        <xsl:value-of select="."/>
      </description>
    </xsl:for-each>
    <xsl:if test="//mods:mods/mods:subject/mods:name/mods:description">
      <description>
        <xsl:value-of select="//mods:mods/mods:subject/mods:name/mods:description"/>
      </description>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="publisher">
<![CDATA[
]]>

	<!-- xsl:apply-templates select="//mods:mods/mods:location/mods:physicalLocation" mode="publisher"/ -->


    <xsl:if test="//mods:mods/mods:originInfo/mods:publisher">
      <publisher>
        <xsl:value-of select="//mods:mods/mods:originInfo/mods:publisher"/>
      </publisher>
    </xsl:if>
    <!--xsl:if test="//mods:mods/mods:recordInfo/mods:recordContentSource"-->
      <!--publisher-->
        <!--xsl:value-of select="//mods:mods/mods:recordInfo/mods:recordContentSource"/-->
      <!--/publisher-->
    <!--/xsl:if-->
    <xsl:if test="//mods:mods/mods:publicationInfo/mods:publisher">
      <publisher>
        <xsl:value-of select="//mods:mods/mods:publicationInfo/mods:publisher"/>
      </publisher>
    </xsl:if>

  </xsl:template>

<!-- xsl:template match="mods:physicalLocation" mode="publisher" -->
<!-- publisher><xsl:value-of select="."/></publisher -->
<!-- /xsl:template-->
  
  <xsl:template name="contributor">
<![CDATA[
]]>
    <xsl:if test="contains(//mods:mods/mods:name/mods:role/mods:text, 'contributor')">
      <contributor>
        <xsl:value-of select="//mods:mods/mods:name[1]/mods:namePart"/>
      </contributor>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="date">
<![CDATA[
]]>
    <xsl:if test="//mods:mods/mods:originInfo/mods:dateIssued">
      <date>
        <xsl:value-of select="//mods:mods/mods:originInfo/mods:dateIssued"/>
      </date>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:publicationInfo/mods:dateIssued">
      <date>
        <xsl:value-of select="//mods:mods/mods:publicationInfo/mods:dateIssued"/>
      </date>
    </xsl:if>
    <!-- xsl:if test="//mods:mods/mods:originInfo/mods:dateCreated">
      <date>
        <xsl:value-of select="//mods:mods/mods:originInfo/mods:dateCreated"/>
      </date>
    </xsl:if -->
    <xsl:if test="//mods:mods/mods:originInfo/mods:dateCaptured">
      <date>
        <xsl:value-of select="//mods:mods/mods:originInfo/mods:dateCaptured"/>
      </date>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:originInfo/mods:dateOther">
      <date>
        <xsl:value-of select="//mods:mods/mods:originInfo/mods:dateOther"/>
      </date>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="type">
<![CDATA[
]]>
    <xsl:if test="//mods:mods/mods:typeOfResource">
    <type>
        <xsl:value-of select="//mods:mods/mods:typeOfResource"/>
    </type>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:genre">
    <type>
        <xsl:value-of select="//mods:mods/mods:genre"/>
    </type>
    </xsl:if>
  </xsl:template>
  
  <xsl:template name="format">
<![CDATA[
]]>
    <xsl:if test="//mods:mods/mods:physicalDescription/mods:extent">
      <format>
        <xsl:value-of select="//mods:mods/mods:physicalDescription/mods:extent"/>
      </format>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:physicalDescription/mods:form">
      <format>
        <xsl:value-of select="//mods:mods/mods:physicalDescription/mods:form"/>
      </format>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:physicalDescription/mods:internetMediaType">
      <format>
        <xsl:value-of select="//mods:mods/mods:physicalDescription/mods:internetMediaType"/>
      </format>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:physicalDescription/mods:digitalOrigin">
      <format>
        <xsl:value-of select="//mods:mods/mods:physicalDescription/mods:digitalOrigin"/>
      </format>
    </xsl:if>
    <xsl:if test="//mods:mods/mods:physicalDescription/mods:note">
      <format>
        <xsl:value-of select="//mods:mods/mods:physicalDescription/mods:note"/>
      </format>
    </xsl:if>
  </xsl:template>
  
<xsl:template name="identifier">
  <identifier>
    <xsl:value-of select="@OBJID"/>
  </identifier>
    <xsl:for-each select="//mods:mods/mods:identifier">
      <xsl:choose>
        <xsl:when test="@type='isbn'">
          <identifier>
            <xsl:text>isbn: </xsl:text>
            <xsl:value-of select="."/>
          </identifier>
        </xsl:when>
        <xsl:when test="@type='issn'">
          <identifier>
            <xsl:text>issn: </xsl:text>
            <xsl:value-of select="."/>
          </identifier>
        </xsl:when>
        <xsl:when test="@type='doi'">
          <identifier>
            <xsl:text>doi: </xsl:text>
            <xsl:value-of select="."/>
          </identifier>
        </xsl:when>
        <xsl:when test="@type='lccn'">
          <identifier>
            <xsl:text>lccn: </xsl:text>
            <xsl:value-of select="."/>
          </identifier>
        </xsl:when>
        <xsl:when test="@type='uri'">
          <identifier>
            <xsl:text>uri: </xsl:text>
            <xsl:value-of select="."/>
          </identifier>
        </xsl:when>
        <xsl:otherwise>
          <identifier>
            <xsl:value-of select="."/>
          </identifier>
        </xsl:otherwise>
      </xsl:choose>
    </xsl:for-each>

    <xsl:if test="//mods:mods/mods:location/mods:url">
      <identifier>
        <xsl:value-of select="//mods:mods/mods:location/mods:url"/>
      </identifier>
    </xsl:if>
  </xsl:template>
  
 <xsl:template name="source">
<![CDATA[
]]>
     <xsl:if test="//mods:mods/mods:relatedItem[@type='original']">
       <xsl:for-each select="//mods:mods/mods:relatedItem[@type='original']/*">
         <source>
           <xsl:value-of select="."/>
         </source>
       </xsl:for-each>
     </xsl:if>
   </xsl:template>


<xsl:template match="mods:relatedItem" mode="source">
	<source>
		<xsl:value-of select="mods:titleInfo"/>
		<xsl:apply-templates select="mods:relatedItem" mode="rsource" />
	</source>
</xsl:template>

<xsl:template match="mods:relatedItem" mode="rsource">
		; <xsl:value-of select="mods:titleInfo"/>
		<xsl:apply-templates select="mods:relatedItem" mode="rsource" />
</xsl:template>

  <xsl:template name="language">
<![CDATA[
]]>
    <xsl:if test="//mods:mods/mods:language">
    <language>
      <xsl:value-of select="//mods:mods/mods:language"/>
    </language></xsl:if>
  </xsl:template>
  
  <xsl:template name="relation">
<![CDATA[
]]>
    <xsl:apply-templates select="//mods:mods/mods:relatedItem//mods:url" mode="relation"/>
    <xsl:apply-templates select="//mods:mods/mods:relatedItem/mods:identifier" mode="relation"/>
    <xsl:if test="//*[local-name()='relation']">
      <relation>
        <xsl:value-of select="//*[local-name()='relation']"/>
      </relation>
    </xsl:if>
  </xsl:template>

<xsl:template match="mods:url | mods:identifier" mode="relation">
	<relation><xsl:value-of select="."/></relation>
</xsl:template>

<!-- xsl:template match="*" mode="makeRelations">
  <xsl:apply-templates mode="makeRelations"/>
</xsl:template>

<xsl:template match="text()" mode="makeRelations">
  <xsl:if test="normalize-space(.) != ''">
    <relation>
      <xsl:value-of select="normalize-space(.)"/>
    </relation>
  </xsl:if>
</xsl:template -->

<xsl:template name="coverage">
<![CDATA[
]]>
  <xsl:if test="//mods:mods/mods:subject/mods:geographic">
    <coverage>
      <xsl:value-of select="//mods:mods/mods:subject/mods:geographic"/>
    </coverage>
  </xsl:if>
  <xsl:if test="//mods:mods/mods:subject/mods:temporal">
    <coverage>
      <xsl:value-of select="//mods:mods/mods:subject/mods:temporal"/>
    </coverage>
  </xsl:if>
  <xsl:if test="//mods:mods/mods:subject/mods:hierarchicalGeographic">
    <xsl:apply-templates mode="coverage1" select="//mods:mods/mods:subject/mods:hierarchicalGeographic"/>
  </xsl:if>
  <xsl:if test="//mods:mods/mods:subject/mods:cartographic">
    <xsl:apply-templates mode="coverage2" select="//mods:mods/mods:subject/mods:cartographic"/>
  </xsl:if>
  <xsl:for-each select="//mods:mods/mods:classification">
    <coverage>
      <xsl:value-of select="."/>
    </coverage>
  </xsl:for-each>
  <!--xsl:if test="//mods:mods/mods:originInfo/mods:place/mods:text"-->
    <!--coverage-->
      <!--xsl:value-of select="//mods:mods/mods:originInfo/mods:place/mods:text"/-->
    <!--/coverage-->
  <!--/xsl:if-->
</xsl:template>

<xsl:template match="*" mode="coverage1">
  <xsl:apply-templates mode="coverage1"/>
</xsl:template>

<xsl:template match="text()" mode="coverage1">
  <xsl:if test="normalize-space(.) != ''">
    <coverage>
      <xsl:value-of select="normalize-space(.)"/>
    </coverage>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="coverage2">
  <xsl:apply-templates mode="coverage2"/>
</xsl:template>

<xsl:template match="text()" mode="coverage2">
  <xsl:if test="normalize-space(.) != ''">
    <coverage>
      <xsl:value-of select="normalize-space(.)"/>
    </coverage>
  </xsl:if>
</xsl:template>

<xsl:template name="rights">
  <xsl:if test="//mods:mods/mods:accessCondition">
    <rights>
      <xsl:value-of select="//mods:mods/mods:accessCondition"/>
    </rights>
  </xsl:if>
</xsl:template>

<xsl:template name="dcterms">
<![CDATA[
]]>
  <xsl:if test="//mods:mods/mods:abstract">
    <description>
      <xsl:value-of select="//mods:mods/mods:abstract"/>
    </description>
  </xsl:if>
  <xsl:if test="//mods:mods/mods:recordInfo/mods:recordCreationDate">
    <date qualifier="created">
      <xsl:value-of select="//mods:mods/mods:recordInfo/mods:recordCreationDate"/>
    </date>
  </xsl:if>
  <xsl:if test="//mods:mods/mods:originInfo/mods:dateCreated">
    <date qualifier="created">
      <xsl:value-of select="//mods:mods/mods:originInfo/mods:dateCreated"/>
    </date>
  </xsl:if>
  <xsl:if test="//mods:mods/mods:recordInfo/mods:recordChangeDate">
    <date>
      <xsl:value-of select="//mods:mods/mods:recordInfo/mods:recordChangeDate"/>
    </date>
  </xsl:if>
  <xsl:for-each select="//mods:mods/mods:relatedItem">
    <xsl:choose>
      <xsl:when test="@type='series'">
        <xsl:apply-templates mode="makeIsPartOf"/>
      </xsl:when>
    </xsl:choose>
  </xsl:for-each>
</xsl:template>

<xsl:template match="*" mode="makeIsPartOf">
  <xsl:apply-templates mode="makeIsPartOf"/>
</xsl:template>

<xsl:template match="text()" mode="makeIsPartOf">
  <xsl:if test="normalize-space(.) != ''">
    <relation>
      <xsl:value-of select="normalize-space(.)"/>
    </relation>
  </xsl:if>
</xsl:template>

</xsl:stylesheet>
