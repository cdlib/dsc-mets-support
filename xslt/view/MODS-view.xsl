<xsl:stylesheet
   version="2.0"
   xmlns:view="http://www.cdlib.org/view"
   xmlns:view_="http://www.cdlib.org/view_"
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns:mets="http://www.loc.gov/METS/"
   xmlns:m="http://www.loc.gov/METS/"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="#all"	>

<!-- this function takes a mods record and turns it to html -->
<xsl:function name="view:MODS">
<xsl:param name="mods"/>
<xsl:param name="clip"/>
<xsl:comment> clip=<xsl:value-of select="$clip"/>
{http://www.cdlib.org/view}:MODS <xsl:value-of select="static-base-uri()"/>
</xsl:comment>
  <xsl:choose>
   <xsl:when test="not($mods)"/><!-- be silent if no $mods -->
   <xsl:when test="$clip">
	<xsl:apply-templates select="$mods/mods:titleInfo, $mods/mods:name, $mods/mods:originInfo" mode="viewMODS"/>
   </xsl:when>
   <xsl:otherwise>
	<xsl:apply-templates select="$mods" mode="viewMODS"/>
   </xsl:otherwise>
  </xsl:choose>
</xsl:function>

<!-- private function to clean up display lables -->
<xsl:function name="view_:displayLabelClean">
  <xsl:param name="inR"/>
  <xsl:variable name="in" select="normalize-space($inR)"/>
  <xsl:value-of select="upper-case(substring($in,1,1))"/>
  <xsl:value-of select="substring($in,2,string-length($in)-1)"/>
  <xsl:if test="not(matches($in,'.*[.:;,]+$\s*'))">:</xsl:if>
</xsl:function>

<!-- match the root mods -->
<xsl:template match="mods:mods" mode="viewMODS">
<!-- 	
	titleInfo 		note
	name 			subject
	typeOfResource 		classification
	genre 			relatedItem
	originInfo 		identifier
	language 		location
	physicalDescription 	accessCondition
	abstract 		part
	tableOfContents 	extension
	targetAudience 		recordInfo
-->
	<xsl:apply-templates 
		select="mods:titleInfo, 
			mods:name,
			mods:abstract,
			mods:originInfo/mods:dateCreated[1],
			mods:originInfo/mods:dateIssued[1],
			mods:tableOfContents, 
			mods:subject, 
			mods:targetAudience,
			mods:note, 
			mods:genre,
			mods:physicalDescription, 
			mods:language[1],
			mods:identifier,
			mods:classification,
			mods:accessCondition, mods:part"
		mode="viewMODS"
	/>
</xsl:template>

<!-- default -->
<xsl:template match="*" mode="viewMODS">
	<xsl:comment><xsl:value-of select="name()"/></xsl:comment>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<!-- supplied label -->
<xsl:template match="*[@displayLabel]" mode="viewMODS">
	<xsl:comment><xsl:value-of select="name()"/></xsl:comment>
	<h2><xsl:value-of select="view_:displayLabelClean(@displayLabel)"/></h2>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<!-- Title titleInfo heading -->
<xsl:template match="mods:titleInfo[1]" mode="viewMODS">
	<!-- will need to grab mods:part -->
	<h2>Title:</h2>
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<xsl:template match="mods:*[parent::mods:titleInfo]" mode="viewMODS">
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<xsl:template match="mods:genre[1]" mode="viewMODS">
	<!-- will need to grab mods:part -->
	<h2>Type:</h2>
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<!-- Contributor name heading -->
<xsl:template match="mods:name[1][parent::mods:mods]" mode="viewMODS">
	<h2>Contributor:</h2>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<xsl:template match="mods:namePart" mode="viewMODS">
        <xsl:value-of select="."/>
	<xsl:if test="following-sibling::mods:namePart"><xsl:text> </xsl:text></xsl:if>
</xsl:template>

<xsl:template match="mods:role[mods:roleTerm]" mode="viewMODS">
	<xsl:text>, </xsl:text>
        <xsl:value-of select="mods:roleTerm"/>
</xsl:template>

<!-- Type typeOfResource genere heading -->
<xsl:template match="mods:typeOfResource[1]" mode="viewMODS">
	<h2>Type:</h2>
	<p><xsl:apply-templates mode="viewMODS"/></p>
	<xsl:apply-templates select="./following-sibling::mods:typeOfResource" mode="viewMODS"/>
	<xsl:apply-templates select="./following-sibling::mods:genre" mode="viewMODS"/>
</xsl:template>

<!-- originInfo is a headingless child of mods -->
<!-- xsl:template match="mods:originInfo" mode="viewMODS">
	<xsl:apply-templates select="mods:dateCreated[1], mods:dateIssued[1], mods:publisher[1]" mode="viewMODS"/>
</xsl:template -->

<!-- Date orginInfo/date* heading -->
<xsl:template match="mods:dateCreated[1] | mods:dateIssued[1]" mode="viewMODS">
	<h2>Date:</h2>
	<!-- needs work -->
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<!-- Publisher publisher heading -->
<xsl:template match="mods:publisher[1]" mode="viewMODS">
	<h2>Publisher:</h2>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<!-- Language language heading -->
<xsl:template match="mods:language[1]" mode="viewMODS">
	<h2>Language:</h2>
	<xsl:for-each select="mods:languageTerm[1], (./following-sibling::mods:language)/mods:languageTerm[1]"><p>
<xsl:choose>
        <xsl:when test=". = 'eng'">
          <xsl:text>English</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'spa'">
          <xsl:text>Spanish</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'ger'">
          <xsl:text>German</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'fre'">
          <xsl:text>French</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'ita'">
          <xsl:text>Italian</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'rus'">
          <xsl:text>Russian</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'por'">
          <xsl:text>Portuguese</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'gre'">
          <xsl:text>Greek</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'ara'">
          <xsl:text>Arabic</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'chi'">
          <xsl:text>Chinese</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'dut'">
          <xsl:text>Dutch</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'heb'">
          <xsl:text>Hebrew</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'jpn'">
          <xsl:text>Japanese</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'kor'">
          <xsl:text>Korean</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'vie'">
          <xsl:text>Vietnamese</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'lao'">
          <xsl:text>Lao</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'cam'">
          <xsl:text>Khmer</xsl:text>
        </xsl:when>
	<!-- should have all the codes? -->
        <xsl:otherwise>
          <xsl:value-of select="."/>
        </xsl:otherwise>
      </xsl:choose>
	</p></xsl:for-each>
</xsl:template>

<!-- Physical Description physicalDescription heading -->
<xsl:template match="mods:physicalDescription[1]" mode="viewMODS">
	<h2>Physical Description:</h2>
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<xsl:template match="mods:abstract[1]" mode="viewMODS">
	<h2>Abstract:</h2>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<xsl:template match="mods:tableOfContents[1]" mode="viewMODS">
	<h2>Contents:</h2>
	<!-- what would this look like anyway -->
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<xsl:template match="mods:targetAudience[1]" mode="viewMODS">
	<h2>Target Audience:</h2>
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<xsl:template match="mods:note[1][parent::mods:mods]" mode="viewMODS">
	<h2>Note:</h2>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<xsl:template match="mods:subject[1]" mode="viewMODS">
	<h2>Subject:</h2>
	<p><xsl:apply-templates mode="subjectMODS"/></p>
</xsl:template>

<xsl:template match="mods:subject" mode="viewMODS">
	<p><xsl:apply-templates mode="subjectMODS"/></p>
</xsl:template>

<xsl:template match="mods:*" mode="subjectMODS">
	<xsl:apply-templates mode="subjectMODS"/>
	<xsl:if test="following-sibling::*[1]"> -- </xsl:if>
</xsl:template>

<xsl:template match="mods:classification[1]" mode="viewMODS">
	<h2>Classification:</h2>
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<!-- related Items don't share the same heading -->
<xsl:template match="mods:relatedItem" mode="viewMODS">
	<xsl:if test="mods:titleInfo"><h2>Related Item:</h2></xsl:if>
	<xsl:apply-templates mode="relatedLink"/>
</xsl:template>
<xsl:template match="mods:relatedItem[@displayLabel]" mode="viewMODS">
	<h2><xsl:value-of select="view_:displayLabelClean(@displayLabel)"/></h2>
	<xsl:apply-templates mode="relatedLink"/>
</xsl:template>

<xsl:template match="*" mode="relatedLink">
</xsl:template>

<xsl:template match="mods:titleInfo[1]" mode="relatedLink">
	<xsl:choose>
		<xsl:when test="following-sibling::mods:identifier[@type='uri']">
			<a href="{following-sibling::mods:identifier[@type='uri']}"><xsl:value-of select="."/></a>
		</xsl:when>
		<xsl:otherwise>
<xsl:apply-templates mode="viewMODS"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<xsl:template match="mods:identifier[1]" mode="viewMODS">
	<xsl:choose>
	  <xsl:when test="@displayLabel">
	<h2><xsl:value-of select="view_:displayLabelClean(@displayLabel)"/></h2>
	  </xsl:when>
	  <xsl:otherwise>
	<h2>Identifier:</h2>
	  </xsl:otherwise>
	</xsl:choose>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<xsl:template match="mods:location[1]" mode="viewMODS">
	<h2>Location:</h2>
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<xsl:template match="mods:accessCondition[1]" mode="viewMODS">
	<h2>Copyright Note:</h2>
	<p><xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<xsl:template match="mods:accessCondition[@displayLabel][position() &gt; 1]" mode="viewMODS">
	<xsl:comment><xsl:value-of select="name()"/></xsl:comment>
	<p><xsl:value-of select="view_:displayLabelClean(@displayLabel)"/>
	<xsl:text> </xsl:text>
	<xsl:apply-templates mode="viewMODS"/></p>
</xsl:template>

<xsl:template match="mods:part[1]" mode="viewMODS">
	<h2>Part:</h2>
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template>

<xsl:template match="mods:extension | mods:recordInfo" mode="viewMODS">
</xsl:template>

<!-- magic to link things that end in http://a.link -->
<xsl:template priority="-0.25" match="*[substring-after(text(),'http://')]" mode="viewMODS">
	<xsl:comment>magic <xsl:value-of select="name()"/></xsl:comment>
	<xsl:variable name="string">
                <xsl:value-of select="text()"/>
        </xsl:variable>
        <xsl:choose>
                <xsl:when test="substring-after($string,'http://')">
                        <a href="http://{substring-after(normalize-space($string),'http://')}">
                        <xsl:value-of select="substring-before(normalize-space($string),'http://')"/>
                        </a>	
			<!-- to do, clean up trailing semi colons -->
                </xsl:when>
                <xsl:otherwise>
                        <xsl:value-of select="$string"/>
                </xsl:otherwise>
        </xsl:choose>
</xsl:template>

</xsl:stylesheet>
