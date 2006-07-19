<?xml version="1.0"?>
<!--
change old MODS namespace to new MODS namespace
-->

<xsl:stylesheet version="2.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns="http://www.loc.gov/mods/v3"
	xmlns:Omods="http://www.loc.gov/mods/"
	xmlns:mods3="http://www.loc.gov/mods/v3"
	xmlns:xlink="http://www.w3.org/1999/xlink"
	xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
	exclude-result-prefixes="Omods mods3 xlink"
>

<xsl:template match="/">
	<xsl:apply-templates mode="upMods"/>
</xsl:template>

<!-- focus only on elements in the old mods namespace -->

<xsl:template match="Omods:*" mode="upMods">
<xsl:element name="{name()}" namespace="http://www.loc.gov/mods/v3">
<xsl:for-each select="@*">
<xsl:apply-templates select="." mode="upMods"/>
<!-- xsl:attribute name="{name()}"><xsl:value-of select="."/></xsl:attribute -->
</xsl:for-each>
<xsl:apply-templates mode="upMods"/>
</xsl:element>
</xsl:template>

<!-- change the xlink namespace everywhere -->

<xsl:template match="@*[namespace-uri(.)='http://www.w3.org/TR/xlink']" mode="upMods">
	<xsl:attribute name="{name()}" namespace="http://www.w3.org/1999/xlink">
		<xsl:value-of select="."/>
	</xsl:attribute>
</xsl:template>

<!-- change the mods schema location business -->

<xsl:template match="@*[local-name()='schemaLocation'][namespace-uri()='http://www.w3.org/2001/XMLSchema-instance']" mode="upMods">
<!-- xsl:template match="xsi:schemaLocation" mode="upMods" -->

<!-- xsl:message><xsl:value-of select="name()"/><xsl:value-of select="namespace-uri()"/></xsl:message -->

<xsl:attribute 
	name="schemaLocation" 
	namespace="http://www.w3.org/2001/XMLSchema-instance">
		<xsl:value-of select="replace(.,
      'http://www.loc.gov/mods/ http://www.loc.gov/standards/mods/mods.xsd',
      'http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-0.xsd'
				      )"/>
	</xsl:attribute>
</xsl:template>

<!-- identity transform -->

<xsl:template match='*|@*' mode="upMods">
        <xsl:copy>
                <xsl:apply-templates select='@*|node()' mode="upMods"/>
        </xsl:copy>
</xsl:template>



<!-- the rest if from LOC's XSTL -->

	<xsl:template match="Omods:title" mode="upMods"><!--moves parts outsiede title -->		
		<title>
			<xsl:value-of select="."/>
		</title>
		<xsl:apply-templates select="partName|partNumber" mode="upMods"/>
	</xsl:template>

	<xsl:template match="Omods:role" mode="upMods">
		<xsl:choose>
			<xsl:when test="(text='creator' or text='Creator') and (preceding-sibling::role/text='Creator' or preceding-sibling::role/text='creator')"/>
			<xsl:otherwise>
				<role>
					<roleTerm>
						<xsl:attribute name="type">
							<xsl:value-of select="local-name(*)"/>
						</xsl:attribute>
						<xsl:value-of select="*"/>
					</roleTerm>
				</role>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsl:template match="Omods:place" mode="upMods">
		<xsl:for-each select="*">
			<place>	
				<placeTerm>
					<xsl:choose>
						<xsl:when test="@authority='marc'">
							<xsl:attribute name="authority">marccountry</xsl:attribute>
						</xsl:when>
						<xsl:when test="not(@authority)"/>
						<xsl:otherwise><xsl:copy-of select="@authority"/></xsl:otherwise>
					</xsl:choose>								
					<xsl:attribute name="type">
						<xsl:value-of select="local-name()"/>
					</xsl:attribute>
					<xsl:value-of select="."/>
				</placeTerm>
			</place>
		</xsl:for-each>
	</xsl:template>

	<xsl:template match="Omods:form" mode="upMods">		
		<form>			
			<xsl:copy-of select="@*"/>
			<xsl:choose>
				<xsl:when test="unControlled">
					<xsl:value-of select="unControlled"/>
				</xsl:when>
				<xsl:otherwise><xsl:value-of select="."/></xsl:otherwise>
			</xsl:choose>
		</form>
	</xsl:template>

	<xsl:template match="Omods:identifier" mode="upMods">
<!--1. Convert all <identifier type="uri"> to <location><url>
This would make an assumption that any URIs previously used are really
locations. That is probably a likely assumption.

2. Convert <identifier type="uri"> to both <location><url> and retain the
previously coded <identifier type="uri">. This might be safest but causes
redundancy. A human being generally would have to determine whether it is
really an identifier or location, although in many cases it isn't obvious.

3. Analyze <identifier type="uri"> and if it begins with doi* or hdl* or purl* put it in
both places. The rest go in location.

4. Leave it as is in <identifier> and let the user decide whether to
convert it.
************ option 3 selected ************
-->
		<xsl:choose>
			<xsl:when test="@type='uri'">			
				<xsl:choose>
					<xsl:when test="starts-with(.,'hdl') or starts-with(.,'doi') or starts-with(.,'purl')or starts-with(.,'http://hdl') or starts-with(.,'http://purl')">
						<location>
							<url><xsl:value-of select="."/></url>
						</location>
	
						<identifier>
							<xsl:attribute name="type">
							<xsl:choose>
								<xsl:when test="starts-with(.,'hdl') or starts-with(.,'http://hdl')">
									<xsl:text>hdl</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(.,'doi')">
									<xsl:text>doi</xsl:text>
								</xsl:when>
								<xsl:when test="starts-with(.,'purl') or starts-with(.,'http://purl')">
									<xsl:text>purl</xsl:text>
								</xsl:when>
								<xsl:otherwise><xsl:text>uri</xsl:text></xsl:otherwise>
							</xsl:choose>
			<!--				<xsl:copy-of select="."/> 	-->
							</xsl:attribute>
							<xsl:value-of select="."/> 
						</identifier>
				
					</xsl:when>
					<xsl:otherwise>
						<location>
							<url><xsl:value-of select="."/></url>
						</location>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:when>
			<xsl:otherwise>
				<identifier>
				<xsl:copy-of select="@*"/>				
				<xsl:value-of select="."/>		
				</identifier>
			</xsl:otherwise>
		</xsl:choose>		
	</xsl:template>

	<xsl:template match="Omods:location" mode="upMods">		
		<location>
			<physicalLocation>
				<xsl:copy-of select="@*"/>				
				<xsl:value-of select="."/>		
			</physicalLocation>
		</location>		
	</xsl:template>
	
	<xsl:template match="Omods:language" mode="upMods">
		<language>
			<languageTerm>				
				<xsl:if test="@authority">
					<xsl:copy-of select="@authority"/>
						<xsl:attribute name="type">code</xsl:attribute>
				</xsl:if>
				<xsl:if test="not(@authority)">
					<xsl:attribute name="type">text</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>			
			</languageTerm>
		</language>
	</xsl:template>

	<xsl:template match="Omods:relatedItem" mode="upMods">
		<relatedItem>
			<xsl:if test="not(@type='related')">
				<xsl:attribute name="type">
					<xsl:value-of select="@type"/>
				</xsl:attribute>
			</xsl:if>
			<xsl:apply-templates mode="upMods"/>
		</relatedItem>
	</xsl:template>

	<xsl:template match="Omods:languageOfCataloging" mode="upMods">
		<languageOfCataloging>
			<languageTerm>				
				<xsl:if test="@authority">
					<xsl:copy-of select="@authority"/>
					<xsl:attribute name="type">
						<xsl:text>code</xsl:text>
					</xsl:attribute>
				</xsl:if>
				<xsl:value-of select="."/>			
			</languageTerm>
		</languageOfCataloging>
	</xsl:template>


</xsl:stylesheet>
