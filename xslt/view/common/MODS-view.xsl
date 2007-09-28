<xsl:stylesheet
   version="2.0"
   xmlns:view="http://www.cdlib.org/view"
   xmlns:view_="http://www.cdlib.org/view_"
   xmlns:mods="http://www.loc.gov/mods/v3"
   xmlns:mets="http://www.loc.gov/METS/"
   xmlns:m="http://www.loc.gov/METS/"
	 xmlns:xtf="http://cdlib.org/xtf"
   xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	exclude-result-prefixes="#all"	>

<xsl:variable name="page" select="if (/TEI.2) then /TEI.2 else /"/>


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
			mods:originInfo/mods:copyrightDate[1],
			mods:tableOfContents, 
			mods:subject, 
			mods:targetAudience,
			mods:note, 
			mods:genre,
			mods:physicalDescription, 
			mods:language[1],
			mods:identifier" 
		mode="viewMODS"
	/>
	<xsl:apply-templates 
		select="mods:originInfo[mods:publisher[text()]]"
		mode="publisher"
	/>
	<xsl:apply-templates 
		select="mods:originInfo[mods:place][not(mods:publisher)]"
		mode="origin"
	/>
	<xsl:apply-templates 
		select="mods:classification,
			mods:accessCondition, mods:part"
		mode="viewMODS"
	/>
	<xsl:if test="mods:relatedItem[not(@displayLabel='Collection')]">
<div class="relatedItem">
	<h2>Related Item:</h2>
	<xsl:apply-templates select="mods:relatedItem[not(@displayLabel='Collection')]" mode="viewMODS"/>
</div>
	</xsl:if>
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
	<div>
	<h2>Title:</h2>
	<xsl:choose>
	<!-- should factor this out, making a copy for now -->
	  <xsl:when test="@type='alternative'">
		<span class="subLabel">Alternative Title:</span><xsl:text> </xsl:text>
	  </xsl:when>
	  <xsl:when test="@type='abbreviated'">
		<span class="subLabel">Abbreviated Title:</span><xsl:text> </xsl:text>
	  </xsl:when>
	  <xsl:when test="@type='translated'">
		<span class="subLabel">Translated Title:</span><xsl:text> </xsl:text>
	  </xsl:when>
	  <xsl:when test="@type='uniform'">
		<xsl:text>[</xsl:text>
	  </xsl:when>
	</xsl:choose>
	<xsl:apply-templates select="
		mods:nonSort, 
		mods:title, 
		mods:subTitle, 
		mods:partNumber, 
		mods:partName, 
		../mods:originInfo/mods:edition, 
		../mods:part" 
	mode="viewMODS"/>
	<xsl:if test="@type='uniform'">
		<xsl:text>]</xsl:text>
	</xsl:if>
	</div>
</xsl:template>

<xsl:template priority="0.25" match="mods:titleInfo" mode="viewMODS">
	<!-- will need to grab mods:part -->
	<p>
	<xsl:choose>
	        <!-- should factor this out, making a copy for now -->
          <xsl:when test="@type='alternative'">
                <span class="subLabel">Alternative Title:</span><xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test="@type='abbreviated'">
                <span class="subLabel">Abbreviated Title:</span><xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test="@type='translated'">
                <span class="subLabel">Translated Title:</span><xsl:text> </xsl:text>
          </xsl:when>
          <xsl:when test="@type='uniform'">
		<xsl:text>[</xsl:text>
          </xsl:when>
        </xsl:choose>

	<xsl:apply-templates select="
		mods:nonSort, 
		mods:title, 
		mods:subTitle, 
		mods:partNumber, 
		mods:partName, 
		../mods:originInfo/mods:edition, 
		../mods:part" 
	mode="viewMODS"/>
	<xsl:if test="@type='uniform'">
		<xsl:text>]</xsl:text>
	</xsl:if>
	</p>
</xsl:template>

<!-- xsl:template match="mods:*[parent::mods:titleInfo]" mode="viewMODS">
	<xsl:apply-templates mode="viewMODS"/>
</xsl:template -->

<xsl:template match="mods:title" mode="viewMODS">
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="mods:nonSort" mode="viewMODS">
	<xsl:value-of select="."/>
	<xsl:text> </xsl:text>
</xsl:template>

<xsl:template match="mods:subTitle | mods:partName | mods:part" mode="viewMODS">
	<xsl:text>: </xsl:text>
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="mods:partNumber" mode="viewMODS">
	<xsl:text>; </xsl:text>
	<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="mods:edition" mode="viewMODS">
	<xsl:text> (</xsl:text>
	<xsl:value-of select="."/>
	<xsl:text>)</xsl:text>
</xsl:template>
<!-- end titleInfo -->

<xsl:template match="mods:genre[1]" mode="viewMODS">
	<!-- will need to grab mods:part -->
	<div><h2>Type:</h2>
	<xsl:apply-templates mode="viewMODS"/>
	</div>
</xsl:template>

<!-- Contributor name heading -->
<xsl:template match="mods:name[1][parent::mods:mods]" mode="viewMODS">
	<div><h2>Creator/Contributor:</h2>
	<xsl:apply-templates mode="viewMODS"/>
	</div>
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

<!-- Date originInfo/date* heading -->
<xsl:template match="mods:dateCreated[1] | mods:dateIssued[1] | mods:copyrightDate[1]" mode="viewMODS">
	<div><h2>Date:</h2>
	<!-- needs work -->
	<xsl:apply-templates mode="viewMODS"/>
	  <xsl:choose>
	   <xsl:when test="local-name()='dateIssued'">
		<xsl:text> (issued)</xsl:text>
	   </xsl:when>
	   <xsl:when test="local-name()='copyrightDate'">
		<xsl:text> (copyright)</xsl:text>
	   </xsl:when>
	  </xsl:choose>
	</div>
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
        <xsl:when test=". = 'tai'">
          <xsl:text>Tai (Other)</xsl:text>
        </xsl:when>
        <xsl:when test=". = 'pal'">
          <xsl:text>Pahlavi</xsl:text>
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
	<div><h2>Subject:</h2>
	<xsl:apply-templates mode="subjectMODS"/>
	</div>
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

<xsl:template match="mods:relatedItem[@displayLabel='Collection']" mode="viewMODS">
</xsl:template>

<xsl:template match="mods:relatedItem" mode="viewMODS">
	<!-- h2>Related Item:</h2 -->
	<p><xsl:apply-templates mode="relatedLink"/></p>
</xsl:template>

<xsl:template match="mods:relatedItem[@type='series']" mode="viewMODS">
  <xsl:variable name="myString"><xsl:value-of select="normalize-space(.)"/></xsl:variable>
  <xsl:variable name="rfString"><xsl:value-of select="normalize-space(substring-after($page/m:mets/relation-from[@xtf:meta] | $page/TEI.2/xtf:meta/relation-from,'|'))"/></xsl:variable>
   <xsl:if test="not(string($myString) = string($rfString))">
<p><span class="subLabel">Series:</span>
	<xsl:text> </xsl:text>
<xsl:apply-templates mode="relatedLink"/></p>
   </xsl:if>
</xsl:template>

<xsl:template match="mods:relatedItem[@displayLabel]" mode="viewMODS">
  <xsl:if test="not(starts-with(lower-case(@displayLabel), 'collection'))">
	<p><span class="subLabel"><xsl:value-of select="view_:displayLabelClean(@displayLabel)"/></span>
	<xsl:text> </xsl:text>
	<xsl:apply-templates mode="relatedLink"/></p>
  </xsl:if>
</xsl:template>

<xsl:template match="*" mode="relatedLink">
<xsl:text> : </xsl:text>
<xsl:apply-templates mode="relatedLink"/>
</xsl:template>

<xsl:template match="mods:identifier[@type='uri'] | mods:identifier[@type='local search'] | mods:url " mode="relatedLink">
</xsl:template>

<xsl:template match="*[1]" mode="relatedLink">
<xsl:value-of select="."/>
</xsl:template>

<xsl:template match="mods:titleInfo[1]" mode="relatedLink">
	<xsl:choose>
		<xsl:when test="following-sibling::mods:identifier[@type='uri']">
			<a target="_top" href="{following-sibling::mods:identifier[@type='uri']}"><xsl:value-of select="."/></a>
		</xsl:when>
		<xsl:when test="../mods:location/mods:url">
			<a target="_top" href="{../mods:location/mods:url}"><xsl:value-of select="."/></a>
		</xsl:when>
		<xsl:otherwise>
<xsl:apply-templates mode="viewMODS"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:template>

<!-- end related item stuff -->

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
	<p>
	<span class="subLabel"><xsl:value-of select="view_:displayLabelClean(@displayLabel)"/></span>
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
<xsl:template priority="-0.25" match="*[substring-after(text(),'http://')][parent::mods:location]" mode="viewMODS">
	<xsl:comment>magic <xsl:value-of select="name()"/></xsl:comment>
	<xsl:variable name="string">
                <xsl:value-of select="text()"/>
        </xsl:variable>
        <xsl:choose>
                <xsl:when test="substring-after($string,'http://')">
                        <a target="_top" href="http://{substring-after(normalize-space($string),'http://')}">
                        <xsl:value-of select="substring-before(normalize-space($string),'http://')"/>
                        </a>	
                </xsl:when>
			<!-- to do, clean up trailing semi colons -->
                <xsl:otherwise>
                        <xsl:value-of select="$string"/>
                </xsl:otherwise>
        </xsl:choose>
</xsl:template>

<xsl:template match="mods:originInfo[1]" mode="publisher">
	<div>
<h2>Publisher:</h2>
	<xsl:call-template name="publisher">
	  <xsl:with-param name="origin" select="."/>
	</xsl:call-template>
</div>
</xsl:template>

<xsl:template match="mods:originInfo" mode="publisher">
<p>
	<xsl:call-template name="publisher">
	  <xsl:with-param name="origin" select="."/>
	</xsl:call-template>
</p>
</xsl:template>

<xsl:template match="mods:originInfo[1]" mode="origin">
	<div>
<h2>Origin:</h2>
	<xsl:call-template name="publisher">
	  <xsl:with-param name="origin" select="."/>
	</xsl:call-template>
</div>
</xsl:template>

<xsl:template match="mods:originInfo" mode="origin">
<p>
	<xsl:call-template name="publisher">
	  <xsl:with-param name="origin" select="."/>
	</xsl:call-template>
</p>
</xsl:template>

<xsl:template name="publisher">
  <xsl:param name="origin"/>
  <xsl:choose>
	<xsl:when test="$origin/mods:place/mods:placeTerm and $origin/mods:publisher">
		<xsl:apply-templates select="$origin/mods:place/mods:placeTerm[1]" mode="marc-place-code"/>
		<xsl:text> : </xsl:text>
		<xsl:value-of select="$origin/mods:publisher"/>
	</xsl:when>
	<xsl:when test="$origin/mods:publisher">
		<xsl:value-of select="$origin/mods:publisher"/>
	</xsl:when>
	<xsl:when test="not($origin/mods:publisher) and $origin/mods:place/mods:placeTerm">
		<xsl:apply-templates select="$origin/mods:place/mods:placeTerm[1]" mode="marc-place-code"/>
	</xsl:when>
	<xsl:otherwise/>
  </xsl:choose>
</xsl:template>

<xsl:template match="mods:placeTerm" mode="marc-place-code">
<xsl:choose>
  <xsl:when test="@type='text'">
	<xsl:value-of select="."/>
  </xsl:when>
  <xsl:otherwise>
	<xsl:choose>
<xsl:when test=" . = 'aa'"><xsl:text>Albania</xsl:text></xsl:when>
<xsl:when test=" . = 'abc'"><xsl:text>Alberta</xsl:text></xsl:when>
<xsl:when test=" . = 'ac'"><xsl:text>Ashmore and Cartier Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'ae'"><xsl:text>Algeria</xsl:text></xsl:when>
<xsl:when test=" . = 'af'"><xsl:text>Afghanistan</xsl:text></xsl:when>
<xsl:when test=" . = 'ag'"><xsl:text>Argentina</xsl:text></xsl:when>
<xsl:when test=" . = 'ai'"><xsl:text>Anguilla</xsl:text></xsl:when>
<xsl:when test=" . = 'ai'"><xsl:text>Armenia (Republic)</xsl:text></xsl:when>
<xsl:when test=" . = 'air'"><xsl:text>Armenian S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'aj'"><xsl:text>Azerbaijan</xsl:text></xsl:when>
<xsl:when test=" . = 'ajr'"><xsl:text>Azerbaijan S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'aku'"><xsl:text>Alaska</xsl:text></xsl:when>
<xsl:when test=" . = 'alu'"><xsl:text>Alabama</xsl:text></xsl:when>
<xsl:when test=" . = 'am'"><xsl:text>Anguilla</xsl:text></xsl:when>
<xsl:when test=" . = 'an'"><xsl:text>Andorra</xsl:text></xsl:when>
<xsl:when test=" . = 'ao'"><xsl:text>Angola</xsl:text></xsl:when>
<xsl:when test=" . = 'aq'"><xsl:text>Antigua and Barbuda</xsl:text></xsl:when>
<xsl:when test=" . = 'aru'"><xsl:text>Arkansas</xsl:text></xsl:when>
<xsl:when test=" . = 'as'"><xsl:text>American Samoa</xsl:text></xsl:when>
<xsl:when test=" . = 'at'"><xsl:text>Australia</xsl:text></xsl:when>
<xsl:when test=" . = 'au'"><xsl:text>Austria</xsl:text></xsl:when>
<xsl:when test=" . = 'aw'"><xsl:text>Aruba</xsl:text></xsl:when>
<xsl:when test=" . = 'ay'"><xsl:text>Antarctica</xsl:text></xsl:when>
<xsl:when test=" . = 'azu'"><xsl:text>Arizona</xsl:text></xsl:when>
<xsl:when test=" . = 'ba'"><xsl:text>Bahrain</xsl:text></xsl:when>
<xsl:when test=" . = 'bb'"><xsl:text>Barbados</xsl:text></xsl:when>
<xsl:when test=" . = 'bcc'"><xsl:text>British Columbia</xsl:text></xsl:when>
<xsl:when test=" . = 'bd'"><xsl:text>Burundi</xsl:text></xsl:when>
<xsl:when test=" . = 'be'"><xsl:text>Belgium</xsl:text></xsl:when>
<xsl:when test=" . = 'bf'"><xsl:text>Bahamas</xsl:text></xsl:when>
<xsl:when test=" . = 'bg'"><xsl:text>Bangladesh</xsl:text></xsl:when>
<xsl:when test=" . = 'bh'"><xsl:text>Belize</xsl:text></xsl:when>
<xsl:when test=" . = 'bi'"><xsl:text>British Indian Ocean Territory</xsl:text></xsl:when>
<xsl:when test=" . = 'bl'"><xsl:text>Brazil</xsl:text></xsl:when>
<xsl:when test=" . = 'bm'"><xsl:text>Bermuda Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'bn'"><xsl:text>Bosnia and Hercegovina</xsl:text></xsl:when>
<xsl:when test=" . = 'bo'"><xsl:text>Bolivia </xsl:text></xsl:when>
<xsl:when test=" . = 'bp'"><xsl:text>Solomon Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'br'"><xsl:text>Burma</xsl:text></xsl:when>
<xsl:when test=" . = 'bs'"><xsl:text>Botswana</xsl:text></xsl:when>
<xsl:when test=" . = 'bt'"><xsl:text>Bhutan</xsl:text></xsl:when>
<xsl:when test=" . = 'bu'"><xsl:text>Bulgaria</xsl:text></xsl:when>
<xsl:when test=" . = 'bv'"><xsl:text>Bouvet Island</xsl:text></xsl:when>
<xsl:when test=" . = 'bw'"><xsl:text>Belarus</xsl:text></xsl:when>
<xsl:when test=" . = 'bwr'"><xsl:text>Byelorussian S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'bx'"><xsl:text>Brunei</xsl:text></xsl:when>
<xsl:when test=" . = 'cau'"><xsl:text>California</xsl:text></xsl:when>
<xsl:when test=" . = 'cb'"><xsl:text>Cambodia</xsl:text></xsl:when>
<xsl:when test=" . = 'cc'"><xsl:text>China</xsl:text></xsl:when>
<xsl:when test=" . = 'cd'"><xsl:text>Chad</xsl:text></xsl:when>
<xsl:when test=" . = 'ce'"><xsl:text>Sri Lanka</xsl:text></xsl:when>
<xsl:when test=" . = 'cf'"><xsl:text>Congo (Brazzaville)</xsl:text></xsl:when>
<xsl:when test=" . = 'cg'"><xsl:text>Congo (Democratic Republic)</xsl:text></xsl:when>
<xsl:when test=" . = 'ch'"><xsl:text>China (Republic : 1949- )</xsl:text></xsl:when>
<xsl:when test=" . = 'ci'"><xsl:text>Croatia</xsl:text></xsl:when>
<xsl:when test=" . = 'cj'"><xsl:text>Cayman Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'ck'"><xsl:text>Colombia</xsl:text></xsl:when>
<xsl:when test=" . = 'cl'"><xsl:text>Chile</xsl:text></xsl:when>
<xsl:when test=" . = 'cm'"><xsl:text>Cameroon</xsl:text></xsl:when>
<xsl:when test=" . = 'cn'"><xsl:text>Canada</xsl:text></xsl:when>
<xsl:when test=" . = 'cou'"><xsl:text>Colorado</xsl:text></xsl:when>
<xsl:when test=" . = 'cp'"><xsl:text>Canton and Enderbury Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'cq'"><xsl:text>Comoros</xsl:text></xsl:when>
<xsl:when test=" . = 'cr'"><xsl:text>Costa Rica</xsl:text></xsl:when>
<xsl:when test=" . = 'cs'"><xsl:text>Czechoslovakia</xsl:text></xsl:when>
<xsl:when test=" . = 'ctu'"><xsl:text>Connecticut</xsl:text></xsl:when>
<xsl:when test=" . = 'cu'"><xsl:text>Cuba</xsl:text></xsl:when>
<xsl:when test=" . = 'cv'"><xsl:text>Cape Verde</xsl:text></xsl:when>
<xsl:when test=" . = 'cw'"><xsl:text>Cook Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'cx'"><xsl:text>Central African Republic</xsl:text></xsl:when>
<xsl:when test=" . = 'cy'"><xsl:text>Cyprus</xsl:text></xsl:when>
<xsl:when test=" . = 'cz'"><xsl:text>Canal Zone</xsl:text></xsl:when>
<xsl:when test=" . = 'dcu'"><xsl:text>District of Columbia</xsl:text></xsl:when>
<xsl:when test=" . = 'deu'"><xsl:text>Delaware</xsl:text></xsl:when>
<xsl:when test=" . = 'dk'"><xsl:text>Denmark</xsl:text></xsl:when>
<xsl:when test=" . = 'dm'"><xsl:text>Benin</xsl:text></xsl:when>
<xsl:when test=" . = 'dq'"><xsl:text>Dominica</xsl:text></xsl:when>
<xsl:when test=" . = 'dr'"><xsl:text>Dominican Republic</xsl:text></xsl:when>
<xsl:when test=" . = 'ea'"><xsl:text>Eritrea</xsl:text></xsl:when>
<xsl:when test=" . = 'ec'"><xsl:text>Ecuador</xsl:text></xsl:when>
<xsl:when test=" . = 'eg'"><xsl:text>Equatorial Guinea</xsl:text></xsl:when>
<xsl:when test=" . = 'em'"><xsl:text>East Timor</xsl:text></xsl:when>
<xsl:when test=" . = 'enk'"><xsl:text>England</xsl:text></xsl:when>
<xsl:when test=" . = 'er'"><xsl:text>Estonia</xsl:text></xsl:when>
<xsl:when test=" . = 'err'"><xsl:text>Estonia</xsl:text></xsl:when>
<xsl:when test=" . = 'es'"><xsl:text>El Salvador</xsl:text></xsl:when>
<xsl:when test=" . = 'et'"><xsl:text>Ethiopia</xsl:text></xsl:when>
<xsl:when test=" . = 'fa'"><xsl:text>Faroe Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'fg'"><xsl:text>French Guiana</xsl:text></xsl:when>
<xsl:when test=" . = 'fi'"><xsl:text>Finland</xsl:text></xsl:when>
<xsl:when test=" . = 'fj'"><xsl:text>Fiji</xsl:text></xsl:when>
<xsl:when test=" . = 'fk'"><xsl:text>Falkland Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'flu'"><xsl:text>Florida</xsl:text></xsl:when>
<xsl:when test=" . = 'fm'"><xsl:text>Micronesia (Federated States)</xsl:text></xsl:when>
<xsl:when test=" . = 'fp'"><xsl:text>French Polynesia</xsl:text></xsl:when>
<xsl:when test=" . = 'fr'"><xsl:text>France</xsl:text></xsl:when>
<xsl:when test=" . = 'fs'"><xsl:text>Terres australes et antarctiques fran&#231;aises</xsl:text></xsl:when>
<xsl:when test=" . = 'ft'"><xsl:text>Djibouti</xsl:text></xsl:when>
<xsl:when test=" . = 'gau'"><xsl:text>Georgia</xsl:text></xsl:when>
<xsl:when test=" . = 'gb'"><xsl:text>Kiribati</xsl:text></xsl:when>
<xsl:when test=" . = 'gd'"><xsl:text>Grenada</xsl:text></xsl:when>
<xsl:when test=" . = 'ge'"><xsl:text>Germany (East)</xsl:text></xsl:when>
<xsl:when test=" . = 'gh'"><xsl:text>Ghana</xsl:text></xsl:when>
<xsl:when test=" . = 'gi'"><xsl:text>Gibraltar</xsl:text></xsl:when>
<xsl:when test=" . = 'gl'"><xsl:text>Greenland</xsl:text></xsl:when>
<xsl:when test=" . = 'gm'"><xsl:text>Gambia</xsl:text></xsl:when>
<xsl:when test=" . = 'gn'"><xsl:text>Gilbert and Ellice Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'go'"><xsl:text>Gabon</xsl:text></xsl:when>
<xsl:when test=" . = 'gp'"><xsl:text>Guadeloupe</xsl:text></xsl:when>
<xsl:when test=" . = 'gr'"><xsl:text>Greece</xsl:text></xsl:when>
<xsl:when test=" . = 'gs'"><xsl:text>Georgia (Republic)</xsl:text></xsl:when>
<xsl:when test=" . = 'gsr'"><xsl:text>Georgian S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'gt'"><xsl:text>Guatemala</xsl:text></xsl:when>
<xsl:when test=" . = 'gu'"><xsl:text>Guam</xsl:text></xsl:when>
<xsl:when test=" . = 'gv'"><xsl:text>Guinea</xsl:text></xsl:when>
<xsl:when test=" . = 'gw'"><xsl:text>Germany</xsl:text></xsl:when>
<xsl:when test=" . = 'gy'"><xsl:text>Guyana</xsl:text></xsl:when>
<xsl:when test=" . = 'gz'"><xsl:text>Gaza Strip</xsl:text></xsl:when>
<xsl:when test=" . = 'hiu'"><xsl:text>Hawaii</xsl:text></xsl:when>
<xsl:when test=" . = 'hk'"><xsl:text>Hong Kong</xsl:text></xsl:when>
<xsl:when test=" . = 'hm'"><xsl:text>Heard and McDonald Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'ho'"><xsl:text>Honduras</xsl:text></xsl:when>
<xsl:when test=" . = 'ht'"><xsl:text>Haiti</xsl:text></xsl:when>
<xsl:when test=" . = 'hu'"><xsl:text>Hungary</xsl:text></xsl:when>
<xsl:when test=" . = 'iau'"><xsl:text>Iowa</xsl:text></xsl:when>
<xsl:when test=" . = 'ic'"><xsl:text>Iceland</xsl:text></xsl:when>
<xsl:when test=" . = 'idu'"><xsl:text>Idaho</xsl:text></xsl:when>
<xsl:when test=" . = 'ie'"><xsl:text>Ireland</xsl:text></xsl:when>
<xsl:when test=" . = 'ii'"><xsl:text>India</xsl:text></xsl:when>
<xsl:when test=" . = 'ilu'"><xsl:text>Illinois</xsl:text></xsl:when>
<xsl:when test=" . = 'inu'"><xsl:text>Indiana</xsl:text></xsl:when>
<xsl:when test=" . = 'io'"><xsl:text>Indonesia</xsl:text></xsl:when>
<xsl:when test=" . = 'iq'"><xsl:text>Iraq</xsl:text></xsl:when>
<xsl:when test=" . = 'ir'"><xsl:text>Iran</xsl:text></xsl:when>
<xsl:when test=" . = 'is'"><xsl:text>Israel</xsl:text></xsl:when>
<xsl:when test=" . = 'it'"><xsl:text>Italy</xsl:text></xsl:when>
<xsl:when test=" . = 'iu'"><xsl:text>Israel-Syria Demilitarized Zones</xsl:text></xsl:when>
<xsl:when test=" . = 'iv'"><xsl:text>C&#244;te d'Ivoire</xsl:text></xsl:when>
<xsl:when test=" . = 'iw'"><xsl:text>Israel-Jordan Demilitarized Zones</xsl:text></xsl:when>
<xsl:when test=" . = 'iy'"><xsl:text>Iraq-Saudi Arabia Neutral Zone</xsl:text></xsl:when>
<xsl:when test=" . = 'ja'"><xsl:text>Japan</xsl:text></xsl:when>
<xsl:when test=" . = 'ji'"><xsl:text>Johnston Atoll</xsl:text></xsl:when>
<xsl:when test=" . = 'jm'"><xsl:text>Jamaica</xsl:text></xsl:when>
<xsl:when test=" . = 'jn'"><xsl:text>Jan Mayen</xsl:text></xsl:when>
<xsl:when test=" . = 'jo'"><xsl:text>Jordan</xsl:text></xsl:when>
<xsl:when test=" . = 'ke'"><xsl:text>Kenya</xsl:text></xsl:when>
<xsl:when test=" . = 'kg'"><xsl:text>Kyrgyzstan</xsl:text></xsl:when>
<xsl:when test=" . = 'kgr'"><xsl:text>Kirghiz S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'kn'"><xsl:text>Korea (North)</xsl:text></xsl:when>
<xsl:when test=" . = 'ko'"><xsl:text>Korea (South)</xsl:text></xsl:when>
<xsl:when test=" . = 'ksu'"><xsl:text>Kansas</xsl:text></xsl:when>
<xsl:when test=" . = 'ku'"><xsl:text>Kuwait</xsl:text></xsl:when>
<xsl:when test=" . = 'kyu'"><xsl:text>Kentucky</xsl:text></xsl:when>
<xsl:when test=" . = 'kz'"><xsl:text>Kazakhstan</xsl:text></xsl:when>
<xsl:when test=" . = 'kzr'"><xsl:text>Kazakh S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'lau'"><xsl:text>Louisiana</xsl:text></xsl:when>
<xsl:when test=" . = 'lb'"><xsl:text>Liberia</xsl:text></xsl:when>
<xsl:when test=" . = 'le'"><xsl:text>Lebanon</xsl:text></xsl:when>
<xsl:when test=" . = 'lh'"><xsl:text>Liechtenstein</xsl:text></xsl:when>
<xsl:when test=" . = 'li'"><xsl:text>Lithuania</xsl:text></xsl:when>
<xsl:when test=" . = 'lir'"><xsl:text>Lithuania</xsl:text></xsl:when>
<xsl:when test=" . = 'ln'"><xsl:text>Central and Southern Line Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'lo'"><xsl:text>Lesotho</xsl:text></xsl:when>
<xsl:when test=" . = 'ls'"><xsl:text>Laos</xsl:text></xsl:when>
<xsl:when test=" . = 'lu'"><xsl:text>Luxembourg</xsl:text></xsl:when>
<xsl:when test=" . = 'lv'"><xsl:text>Latvia</xsl:text></xsl:when>
<xsl:when test=" . = 'lvr'"><xsl:text>Latvia</xsl:text></xsl:when>
<xsl:when test=" . = 'ly'"><xsl:text>Libya</xsl:text></xsl:when>
<xsl:when test=" . = 'mau'"><xsl:text>Massachusetts</xsl:text></xsl:when>
<xsl:when test=" . = 'mbc'"><xsl:text>Manitoba</xsl:text></xsl:when>
<xsl:when test=" . = 'mc'"><xsl:text>Monaco</xsl:text></xsl:when>
<xsl:when test=" . = 'mdu'"><xsl:text>Maryland</xsl:text></xsl:when>
<xsl:when test=" . = 'meu'"><xsl:text>Maine</xsl:text></xsl:when>
<xsl:when test=" . = 'mf'"><xsl:text>Mauritius</xsl:text></xsl:when>
<xsl:when test=" . = 'mg'"><xsl:text>Madagascar</xsl:text></xsl:when>
<xsl:when test=" . = 'mh'"><xsl:text>Macao</xsl:text></xsl:when>
<xsl:when test=" . = 'miu'"><xsl:text>Michigan</xsl:text></xsl:when>
<xsl:when test=" . = 'mj'"><xsl:text>Montserrat</xsl:text></xsl:when>
<xsl:when test=" . = 'mk'"><xsl:text>Oman</xsl:text></xsl:when>
<xsl:when test=" . = 'ml'"><xsl:text>Mali</xsl:text></xsl:when>
<xsl:when test=" . = 'mm'"><xsl:text>Malta</xsl:text></xsl:when>
<xsl:when test=" . = 'mnu'"><xsl:text>Minnesota</xsl:text></xsl:when>
<xsl:when test=" . = 'mou'"><xsl:text>Missouri</xsl:text></xsl:when>
<xsl:when test=" . = 'mp'"><xsl:text>Mongolia</xsl:text></xsl:when>
<xsl:when test=" . = 'mq'"><xsl:text>Martinique</xsl:text></xsl:when>
<xsl:when test=" . = 'mr'"><xsl:text>Morocco</xsl:text></xsl:when>
<xsl:when test=" . = 'msu'"><xsl:text>Mississippi</xsl:text></xsl:when>
<xsl:when test=" . = 'mtu'"><xsl:text>Montana</xsl:text></xsl:when>
<xsl:when test=" . = 'mu'"><xsl:text>Mauritania</xsl:text></xsl:when>
<xsl:when test=" . = 'mv'"><xsl:text>Moldova</xsl:text></xsl:when>
<xsl:when test=" . = 'mvr'"><xsl:text>Moldavian S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'mw'"><xsl:text>Malawi</xsl:text></xsl:when>
<xsl:when test=" . = 'mx'"><xsl:text>Mexico</xsl:text></xsl:when>
<xsl:when test=" . = 'my'"><xsl:text>Malaysia</xsl:text></xsl:when>
<xsl:when test=" . = 'mz'"><xsl:text>Mozambique</xsl:text></xsl:when>
<xsl:when test=" . = 'na'"><xsl:text>Netherlands Antilles</xsl:text></xsl:when>
<xsl:when test=" . = 'nbu'"><xsl:text>Nebraska</xsl:text></xsl:when>
<xsl:when test=" . = 'ncu'"><xsl:text>North Carolina</xsl:text></xsl:when>
<xsl:when test=" . = 'ndu'"><xsl:text>North Dakota</xsl:text></xsl:when>
<xsl:when test=" . = 'ne'"><xsl:text>Netherlands</xsl:text></xsl:when>
<xsl:when test=" . = 'nfc'"><xsl:text>Newfoundland and Labrador</xsl:text></xsl:when>
<xsl:when test=" . = 'ng'"><xsl:text>Niger</xsl:text></xsl:when>
<xsl:when test=" . = 'nhu'"><xsl:text>New Hampshire</xsl:text></xsl:when>
<xsl:when test=" . = 'nik'"><xsl:text>Northern Ireland</xsl:text></xsl:when>
<xsl:when test=" . = 'nju'"><xsl:text>New Jersey</xsl:text></xsl:when>
<xsl:when test=" . = 'nkc'"><xsl:text>New Brunswick</xsl:text></xsl:when>
<xsl:when test=" . = 'nl'"><xsl:text>New Caledonia</xsl:text></xsl:when>
<xsl:when test=" . = 'nm'"><xsl:text>Northern Mariana Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'nmu'"><xsl:text>New Mexico</xsl:text></xsl:when>
<xsl:when test=" . = 'nn'"><xsl:text>Vanuatu</xsl:text></xsl:when>
<xsl:when test=" . = 'no'"><xsl:text>Norway</xsl:text></xsl:when>
<xsl:when test=" . = 'np'"><xsl:text>Nepal</xsl:text></xsl:when>
<xsl:when test=" . = 'nq'"><xsl:text>Nicaragua</xsl:text></xsl:when>
<xsl:when test=" . = 'nr'"><xsl:text>Nigeria</xsl:text></xsl:when>
<xsl:when test=" . = 'nsc'"><xsl:text>Nova Scotia</xsl:text></xsl:when>
<xsl:when test=" . = 'ntc'"><xsl:text>Northwest Territories</xsl:text></xsl:when>
<xsl:when test=" . = 'nu'"><xsl:text>Nauru</xsl:text></xsl:when>
<xsl:when test=" . = 'nuc'"><xsl:text>Nunavut</xsl:text></xsl:when>
<xsl:when test=" . = 'nvu'"><xsl:text>Nevada</xsl:text></xsl:when>
<xsl:when test=" . = 'nw'"><xsl:text>Northern Mariana Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'nx'"><xsl:text>Norfolk Island</xsl:text></xsl:when>
<xsl:when test=" . = 'nyu'"><xsl:text>New York (State)</xsl:text></xsl:when>
<xsl:when test=" . = 'nz'"><xsl:text>New Zealand</xsl:text></xsl:when>
<xsl:when test=" . = 'ohu'"><xsl:text>Ohio</xsl:text></xsl:when>
<xsl:when test=" . = 'oku'"><xsl:text>Oklahoma</xsl:text></xsl:when>
<xsl:when test=" . = 'onc'"><xsl:text>Ontario</xsl:text></xsl:when>
<xsl:when test=" . = 'oru'"><xsl:text>Oregon</xsl:text></xsl:when>
<xsl:when test=" . = 'ot'"><xsl:text>Mayotte</xsl:text></xsl:when>
<xsl:when test=" . = 'pau'"><xsl:text>Pennsylvania</xsl:text></xsl:when>
<xsl:when test=" . = 'pc'"><xsl:text>Pitcairn Island</xsl:text></xsl:when>
<xsl:when test=" . = 'pe'"><xsl:text>Peru</xsl:text></xsl:when>
<xsl:when test=" . = 'pf'"><xsl:text>Paracel Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'pg'"><xsl:text>Guinea-Bissau</xsl:text></xsl:when>
<xsl:when test=" . = 'ph'"><xsl:text>Philippines</xsl:text></xsl:when>
<xsl:when test=" . = 'pic'"><xsl:text>Prince Edward Island</xsl:text></xsl:when>
<xsl:when test=" . = 'pk'"><xsl:text>Pakistan</xsl:text></xsl:when>
<xsl:when test=" . = 'pl'"><xsl:text>Poland</xsl:text></xsl:when>
<xsl:when test=" . = 'pn'"><xsl:text>Panama</xsl:text></xsl:when>
<xsl:when test=" . = 'po'"><xsl:text>Portugal</xsl:text></xsl:when>
<xsl:when test=" . = 'pp'"><xsl:text>Papua New Guinea</xsl:text></xsl:when>
<xsl:when test=" . = 'pr'"><xsl:text>Puerto Rico</xsl:text></xsl:when>
<xsl:when test=" . = 'pt'"><xsl:text>Portuguese Timor</xsl:text></xsl:when>
<xsl:when test=" . = 'pw'"><xsl:text>Palau</xsl:text></xsl:when>
<xsl:when test=" . = 'py'"><xsl:text>Paraguay</xsl:text></xsl:when>
<xsl:when test=" . = 'qa'"><xsl:text>Qatar</xsl:text></xsl:when>
<xsl:when test=" . = 'quc'"><xsl:text>Qu&#233;bec (Province)</xsl:text></xsl:when>
<xsl:when test=" . = 're'"><xsl:text>R&#233;union</xsl:text></xsl:when>
<xsl:when test=" . = 'rh'"><xsl:text>Zimbabwe</xsl:text></xsl:when>
<xsl:when test=" . = 'riu'"><xsl:text>Rhode Island</xsl:text></xsl:when>
<xsl:when test=" . = 'rm'"><xsl:text>Romania</xsl:text></xsl:when>
<xsl:when test=" . = 'ru'"><xsl:text>Russia (Federation)</xsl:text></xsl:when>
<xsl:when test=" . = 'rur'"><xsl:text>Russian S.F.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'rw'"><xsl:text>Rwanda</xsl:text></xsl:when>
<xsl:when test=" . = 'ry'"><xsl:text>Ryukyu Islands, Southern</xsl:text></xsl:when>
<xsl:when test=" . = 'sa'"><xsl:text>South Africa</xsl:text></xsl:when>
<xsl:when test=" . = 'sb'"><xsl:text>Svalbard</xsl:text></xsl:when>
<xsl:when test=" . = 'scu'"><xsl:text>South Carolina</xsl:text></xsl:when>
<xsl:when test=" . = 'sdu'"><xsl:text>South Dakota</xsl:text></xsl:when>
<xsl:when test=" . = 'se'"><xsl:text>Seychelles</xsl:text></xsl:when>
<xsl:when test=" . = 'sf'"><xsl:text>Sao Tome and Principe</xsl:text></xsl:when>
<xsl:when test=" . = 'sg'"><xsl:text>Senegal</xsl:text></xsl:when>
<xsl:when test=" . = 'sh'"><xsl:text>Spanish North Africa</xsl:text></xsl:when>
<xsl:when test=" . = 'si'"><xsl:text>Singapore</xsl:text></xsl:when>
<xsl:when test=" . = 'sj'"><xsl:text>Sudan</xsl:text></xsl:when>
<xsl:when test=" . = 'sk'"><xsl:text>Sikkim</xsl:text></xsl:when>
<xsl:when test=" . = 'sl'"><xsl:text>Sierra Leone</xsl:text></xsl:when>
<xsl:when test=" . = 'sm'"><xsl:text>San Marino</xsl:text></xsl:when>
<xsl:when test=" . = 'snc'"><xsl:text>Saskatchewan</xsl:text></xsl:when>
<xsl:when test=" . = 'so'"><xsl:text>Somalia</xsl:text></xsl:when>
<xsl:when test=" . = 'sp'"><xsl:text>Spain</xsl:text></xsl:when>
<xsl:when test=" . = 'sq'"><xsl:text>Swaziland</xsl:text></xsl:when>
<xsl:when test=" . = 'sr'"><xsl:text>Surinam</xsl:text></xsl:when>
<xsl:when test=" . = 'ss'"><xsl:text>Western Sahara</xsl:text></xsl:when>
<xsl:when test=" . = 'stk'"><xsl:text>Scotland</xsl:text></xsl:when>
<xsl:when test=" . = 'su'"><xsl:text>Saudi Arabia</xsl:text></xsl:when>
<xsl:when test=" . = 'sv'"><xsl:text>Swan Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'sw'"><xsl:text>Sweden</xsl:text></xsl:when>
<xsl:when test=" . = 'sx'"><xsl:text>Namibia</xsl:text></xsl:when>
<xsl:when test=" . = 'sy'"><xsl:text>Syria</xsl:text></xsl:when>
<xsl:when test=" . = 'sz'"><xsl:text>Switzerland</xsl:text></xsl:when>
<xsl:when test=" . = 'ta'"><xsl:text>Tajikistan</xsl:text></xsl:when>
<xsl:when test=" . = 'tar'"><xsl:text>Tajik S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'tc'"><xsl:text>Turks and Caicos Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'tg'"><xsl:text>Togo</xsl:text></xsl:when>
<xsl:when test=" . = 'th'"><xsl:text>Thailand</xsl:text></xsl:when>
<xsl:when test=" . = 'ti'"><xsl:text>Tunisia</xsl:text></xsl:when>
<xsl:when test=" . = 'tk'"><xsl:text>Turkmenistan</xsl:text></xsl:when>
<xsl:when test=" . = 'tkr'"><xsl:text>Turkmen S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'tl'"><xsl:text>Tokelau</xsl:text></xsl:when>
<xsl:when test=" . = 'tnu'"><xsl:text>Tennessee</xsl:text></xsl:when>
<xsl:when test=" . = 'to'"><xsl:text>Tonga</xsl:text></xsl:when>
<xsl:when test=" . = 'tr'"><xsl:text>Trinidad and Tobago</xsl:text></xsl:when>
<xsl:when test=" . = 'ts'"><xsl:text>United Arab Emirates</xsl:text></xsl:when>
<xsl:when test=" . = 'tt'"><xsl:text>Trust Territory of the Pacific Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'tu'"><xsl:text>Turkey</xsl:text></xsl:when>
<xsl:when test=" . = 'tv'"><xsl:text>Tuvalu</xsl:text></xsl:when>
<xsl:when test=" . = 'txu'"><xsl:text>Texas</xsl:text></xsl:when>
<xsl:when test=" . = 'tz'"><xsl:text>Tanzania</xsl:text></xsl:when>
<xsl:when test=" . = 'ua'"><xsl:text>Egypt</xsl:text></xsl:when>
<xsl:when test=" . = 'uc'"><xsl:text>United States Misc. Caribbean Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'ug'"><xsl:text>Uganda</xsl:text></xsl:when>
<xsl:when test=" . = 'ui'"><xsl:text>United Kingdom Misc. Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'uik'"><xsl:text>United Kingdom Misc. Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'uk'"><xsl:text>United Kingdom</xsl:text></xsl:when>
<xsl:when test=" . = 'un'"><xsl:text>Ukraine</xsl:text></xsl:when>
<xsl:when test=" . = 'unr'"><xsl:text>Ukraine</xsl:text></xsl:when>
<xsl:when test=" . = 'up'"><xsl:text>United States Misc. Pacific Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'ur'"><xsl:text>Soviet Union</xsl:text></xsl:when>
<xsl:when test=" . = 'us'"><xsl:text>United States</xsl:text></xsl:when>
<xsl:when test=" . = 'utu'"><xsl:text>Utah</xsl:text></xsl:when>
<xsl:when test=" . = 'uv'"><xsl:text>Burkina Faso</xsl:text></xsl:when>
<xsl:when test=" . = 'uy'"><xsl:text>Uruguay</xsl:text></xsl:when>
<xsl:when test=" . = 'uz'"><xsl:text>Uzbekistan</xsl:text></xsl:when>
<xsl:when test=" . = 'uzr'"><xsl:text>Uzbek S.S.R.</xsl:text></xsl:when>
<xsl:when test=" . = 'vau'"><xsl:text>Virginia</xsl:text></xsl:when>
<xsl:when test=" . = 'vb'"><xsl:text>British Virgin Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'vc'"><xsl:text>Vatican City</xsl:text></xsl:when>
<xsl:when test=" . = 've'"><xsl:text>Venezuela</xsl:text></xsl:when>
<xsl:when test=" . = 'vi'"><xsl:text>Virgin Islands of the United States</xsl:text></xsl:when>
<xsl:when test=" . = 'vm'"><xsl:text>Vietnam</xsl:text></xsl:when>
<xsl:when test=" . = 'vn'"><xsl:text>Vietnam, North</xsl:text></xsl:when>
<xsl:when test=" . = 'vp'"><xsl:text>Various places</xsl:text></xsl:when>
<xsl:when test=" . = 'vs'"><xsl:text>Vietnam, South</xsl:text></xsl:when>
<xsl:when test=" . = 'vtu'"><xsl:text>Vermont</xsl:text></xsl:when>
<xsl:when test=" . = 'wau'"><xsl:text>Washington (State)</xsl:text></xsl:when>
<xsl:when test=" . = 'wb'"><xsl:text>West Berlin</xsl:text></xsl:when>
<xsl:when test=" . = 'wf'"><xsl:text>Wallis and Futuna</xsl:text></xsl:when>
<xsl:when test=" . = 'wiu'"><xsl:text>Wisconsin</xsl:text></xsl:when>
<xsl:when test=" . = 'wj'"><xsl:text>West Bank of the Jordan River</xsl:text></xsl:when>
<xsl:when test=" . = 'wk'"><xsl:text>Wake Island</xsl:text></xsl:when>
<xsl:when test=" . = 'wlk'"><xsl:text>Wales</xsl:text></xsl:when>
<xsl:when test=" . = 'ws'"><xsl:text>Samoa</xsl:text></xsl:when>
<xsl:when test=" . = 'wvu'"><xsl:text>West Virginia</xsl:text></xsl:when>
<xsl:when test=" . = 'wyu'"><xsl:text>Wyoming</xsl:text></xsl:when>
<xsl:when test=" . = 'xa'"><xsl:text>Christmas Island (Indian Ocean)</xsl:text></xsl:when>
<xsl:when test=" . = 'xb'"><xsl:text>Cocos (Keeling) Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'xc'"><xsl:text>Maldives</xsl:text></xsl:when>
<xsl:when test=" . = 'xd'"><xsl:text>Saint Kitts-Nevis</xsl:text></xsl:when>
<xsl:when test=" . = 'xe'"><xsl:text>Marshall Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'xf'"><xsl:text>Midway Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'xh'"><xsl:text>Niue</xsl:text></xsl:when>
<xsl:when test=" . = 'xi'"><xsl:text>Saint Kitts-Nevis-Anguilla</xsl:text></xsl:when>
<xsl:when test=" . = 'xj'"><xsl:text>Saint Helena</xsl:text></xsl:when>
<xsl:when test=" . = 'xk'"><xsl:text>Saint Lucia</xsl:text></xsl:when>
<xsl:when test=" . = 'xl'"><xsl:text>Saint Pierre and Miquelon</xsl:text></xsl:when>
<xsl:when test=" . = 'xm'"><xsl:text>Saint Vincent and the Grenadines</xsl:text></xsl:when>
<xsl:when test=" . = 'xn'"><xsl:text>Macedonia</xsl:text></xsl:when>
<xsl:when test=" . = 'xo'"><xsl:text>Slovakia</xsl:text></xsl:when>
<xsl:when test=" . = 'xp'"><xsl:text>Spratly Island</xsl:text></xsl:when>
<xsl:when test=" . = 'xr'"><xsl:text>Czech Republic</xsl:text></xsl:when>
<xsl:when test=" . = 'xs'"><xsl:text>South Georgia and the South Sandwich Islands</xsl:text></xsl:when>
<xsl:when test=" . = 'xv'"><xsl:text>Slovenia</xsl:text></xsl:when>
<xsl:when test=" . = 'xx'"><xsl:text>No place, unknown, or undetermined</xsl:text></xsl:when>
<xsl:when test=" . = 'xxc'"><xsl:text>Canada</xsl:text></xsl:when>
<xsl:when test=" . = 'xxk'"><xsl:text>United Kingdom</xsl:text></xsl:when>
<xsl:when test=" . = 'xxr'"><xsl:text>Soviet Union</xsl:text></xsl:when>
<xsl:when test=" . = 'xxu'"><xsl:text>United States</xsl:text></xsl:when>
<xsl:when test=" . = 'ye'"><xsl:text>Yemen</xsl:text></xsl:when>
<xsl:when test=" . = 'ykc'"><xsl:text>Yukon Territory</xsl:text></xsl:when>
<xsl:when test=" . = 'ys'"><xsl:text>Yemen (People's Democratic Republic)</xsl:text></xsl:when>
<xsl:when test=" . = 'yu'"><xsl:text>Serbia and Montenegro</xsl:text></xsl:when>
<xsl:when test=" . = 'za'"><xsl:text>Zambia</xsl:text></xsl:when>
<xsl:otherwise>
	<xsl:text>unknown place</xsl:text>
	<xsl:value-of select="@type"/>
	<xsl:text> </xsl:text>
	<xsl:value-of select="."/>
</xsl:otherwise>
	</xsl:choose>
<xsl:text> </xsl:text>
  </xsl:otherwise>
  </xsl:choose>
</xsl:template>

</xsl:stylesheet>
