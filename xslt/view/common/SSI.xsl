<xsl:stylesheet version="2.0"
xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
xmlns:mets="http://www.loc.gov/METS/"
>


<xsl:param name="developer"/>

<xsl:variable name="layoutBase">
	<xsl:choose>
		<xsl:when test="$developer = ''">
        <xsl:text>/findaid/local</xsl:text>
		</xsl:when>
		<xsl:otherwise>
        <xsl:text>/findaid/developers/</xsl:text>
        <xsl:value-of select="$developer"/>
		</xsl:otherwise>
	</xsl:choose>
</xsl:variable>


<!-- quick and dirty SSI hack -->
<xsl:template match="comment()[starts-with(.,'#include virtual=')]">
        <xsl:variable name="ssi-html">
                <xsl:value-of select="$layoutBase"/>
                <xsl:text>/htdocs</xsl:text>
                <xsl:value-of select="replace(normalize-space(.),'.*&quot;(.*)&quot;','$1')"/>
        </xsl:variable>
<xsl:comment><xsl:value-of select="$ssi-html"/></xsl:comment>
        <xsl:apply-templates select="document($ssi-html)" mode="ssi-identity"/>
</xsl:template>

<xsl:template match="*" mode="ssi-identity">
        <xsl:element name="{name()}">
                <xsl:copy-of select="@*"/>
                <xsl:apply-templates mode="ssi-identity"/>
        </xsl:element>
</xsl:template>

<xsl:template match="form[@name='search-form']" mode="ssi-identity">
        <form action="/search" method="GET" class="search-form" name="search-form">
                <input type="hidden" name="style" value="oac4"/>
                <input type="hidden" name="developer" value="{$developer}"/>
                <xsl:apply-templates mode="ssi-identity"/>
        </form>
</xsl:template>

<xsl:template match="input[@name='keyword']" mode="ssi-identity">
	<input>
		<xsl:attribute name="name" select="'query'"/>
		<xsl:for-each select="@*[not(name()='name')]">
			<xsl:copy/>
		</xsl:for-each>
	</input>
</xsl:template>

<xsl:template name="copy-attributes">
        <xsl:param name="element"/>
<xsl:copy-of select="$element/@class | $element/@action | $element/@method | $element/@name"/>
</xsl:template>


<!-- BSD license copyright 2008 -->
</xsl:stylesheet>
