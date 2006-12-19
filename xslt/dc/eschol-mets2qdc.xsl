<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:dc="http://purl.org/dc/elements/1.1/" 
    xmlns:dcterms="http://purl.org/dc/terms/" 
    xmlns:mets="http://www.loc.gov/METS/" 
    xmlns:mods="http://www.loc.gov/mods/"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    version="2.0">
    
    <xsl:strip-space elements="*"/>

    <xsl:output encoding="UTF-8" indent="yes" method="xml" exclude-result-prefixes="#all"/>

    <xsl:template match="/">
        <qdc xmlns="http://ark.cdlib.org/schemas/appqualifieddc/"
            xmlns:dc="http://purl.org/dc/elements/1.1/" 
            xmlns:dcterms="http://purl.org/dc/terms/"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://ark.cdlib.org/schemas/appqualifieddc/ http://ark.cdlib.org/schemas/appqualifieddc/appqualifieddc.xsd">
            <xsl:apply-templates/>
        </qdc>
    </xsl:template>

    <xsl:template match="mets:mets">
        <xsl:call-template name="title"/>
        <xsl:call-template name="creator"/>
        <xsl:call-template name="subject"/>
        <xsl:call-template name="description"/>
        <publisher>
            <xsl:text>University of California Press</xsl:text>
        </publisher>
        <!-- dc:contributor -->
        <xsl:call-template name="date"/>
        <type xsi:type="dcterms:DCMIType">
            <xsl:text>Text</xsl:text>
        </type>
        <format xsi:type="dcterms:IMT">
            <xsl:text>application/xml</xsl:text>
        </format>
        <xsl:call-template name="identifier"/>
        <!-- dc:source -->
        <language xsi:type="dcterms:ISO639-2">
            <xsl:text>eng</xsl:text>
        </language>
        <!-- dc:relation -->
        <relation.ispartof xsi:type="dcterms:URI">
            <xsl:text>http://www.ucpress.edu/</xsl:text>
        </relation.ispartof>
        <relation.ispartof xsi:type="dcterms:URI">
            <xsl:text>http://escholarship.cdlib.org</xsl:text>
        </relation.ispartof>
        <xsl:call-template name="coverage"/>
        <xsl:call-template name="rights"/>
    </xsl:template>

   <xsl:template name="title">
      <xsl:for-each select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='titleInfo']">
         <title>
            <xsl:value-of select="*"/>
         </title>
      </xsl:for-each>
   </xsl:template>

   <xsl:template name="creator">
      <xsl:for-each select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='name']">
         <creator>
            <xsl:apply-templates select="*"/>
         </creator>
      </xsl:for-each>
   </xsl:template>
   
   <xsl:template match="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='name']/*">
      <xsl:apply-templates/>
      <xsl:text> </xsl:text>
   </xsl:template>
   
    <xsl:template name="subject">
        <xsl:apply-templates select="mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs1'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs2'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs3'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs4'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs5'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs6'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs7'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs8'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs9'] | 
            mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='SubDescs10']"/>
        <xsl:apply-templates mode="subject" select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='subject']"/>
    </xsl:template>

    <xsl:template match="*[local-name()='subject'][@authority='lcsh'][parent::*[local-name()='mods']]" mode="subject">
        <xsl:if test="normalize-space(.)!=''">
           <subject xsi:type="dcterms:LCSH">
                <xsl:apply-templates mode="subject"/>
            </subject>
        </xsl:if>
    </xsl:template>
   
   <xsl:template match="*[local-name()='subject'][@authority='mesh'][parent::*[local-name()='mods']]" mode="subject">
      <xsl:if test="normalize-space(.)!=''">
         <subject xsi:type="dcterms:MESH">
            <xsl:apply-templates mode="subject"/>
         </subject>
      </xsl:if>
   </xsl:template>
   
    <xsl:template match="*[parent::*[local-name()='subject']]/*[parent::*[local-name()='mods']]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*" mode="subject">
        <xsl:if test="position() &gt; 1">--</xsl:if>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*[matches(local-name(), 'SubDescs1|SubDescs2|SubDescs3|SubDescs4|SubDescs5|SubDescs6|SubDescs7|SubDescs8|SubDescs9|SubDescs10')]">
        <xsl:if test="normalize-space(.)!=''">
            <subject>
                <xsl:apply-templates/>
            </subject>
        </xsl:if>
    </xsl:template>

    <xsl:template name="description">
        <xsl:if test="mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='UCPnum.Copy']">
            <description>
                <xsl:apply-templates select="mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='UCPnum.Copy']"/>
            </description>
        </xsl:if>
    </xsl:template>

    <xsl:template name="date">
       <xsl:if test="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']//*[local-name()='dateIssued'][@encoding='marc']">
            <date>
               <xsl:value-of select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']//*[local-name()='dateIssued'][@encoding='marc']"/>
            </date>
        </xsl:if>
    </xsl:template>

    <xsl:template name="identifier">
        <identifier xsi:type="dcterms:URI">
            <xsl:text>http://ark.cdlib.org/</xsl:text><xsl:value-of select="//mets:mets/@OBJID"/>
        </identifier>
       <xsl:for-each select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='identifier'][@type='isbn']">
          <identifier>
             <xsl:text>ISBN: </xsl:text>
             <xsl:value-of select="."/>
          </identifier>
       </xsl:for-each>
       <xsl:for-each select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='identifier'][@type='lccn']">
          <identifier>
             <xsl:text>LCCN: </xsl:text>
             <xsl:value-of select="."/>
          </identifier>
       </xsl:for-each>
    </xsl:template>

    <!-- for-each? -->
    <xsl:template name="coverage">
        <xsl:if test="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='subject']/*[local-name()='geographic']">
            <coverage>
                <xsl:apply-templates select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='subject']/*[local-name()='geographic'][not(.=following::*[local-name()='geographic'])]"/>
            </coverage>
        </xsl:if>
        <xsl:if test="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='subject']/*[local-name()='temporal']">
            <coverage>
                <xsl:apply-templates select="mets:dmdSec[@ID='mods']/mets:mdWrap/mets:xmlData/*[local-name()='mods']/*[local-name()='subject']/*[local-name()='temporal'][not(.=following::*[local-name()='temporal'])]"/>
            </coverage>
        </xsl:if>
    </xsl:template>

    <xsl:template name="rights">
        <xsl:if test="mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='public_nonPublic']">
            <rights>
                <xsl:value-of select="mets:dmdSec[@ID='ucpress']/mets:mdWrap/mets:xmlData/*[local-name()='ROW']/*[local-name()='public_nonPublic']"/>
            </rights>
        </xsl:if>
    </xsl:template>
    
    <xsl:template match="*[local-name()='DATA']">
        <xsl:if test="normalize-space(.)!=''">
            <xsl:apply-templates/>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
