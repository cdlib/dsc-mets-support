<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:mods="http://www.loc.gov/mods/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:xlink="http://www.w3.org/TR/xlink" xmlns:cdl="http://www.cdlib.org/schemas/xmldata" xmlns:dcterms="http://purl.org/dc/terms/" version="1.0" mets:dummy-for-xmlns=""
    dc:dummy-for-xmlns="" rdf:dummy-for-xmlns="" xlink:dummy-for-xmlns="" exclude-result-prefixes="rdf sch xlink mets mods xsl cdl dc dcterms">
    <axsl:output method="xml"/>
    <xsl:template match="/">
        <xsl:call-template name="errors"/>
    </xsl:template>
    <axsl:template name="errors">
        <MetsBestPracticeErrors xsl:exclude-result-prefixes="mets xsl axsl sch mods dc rdf xlink">
            <axsl:apply-templates select="/" mode="M5"/>
            <axsl:apply-templates select="/" mode="M6"/>
        </MetsBestPracticeErrors>
    </axsl:template>
    <axsl:template match="mets:mets" priority="4000" mode="M5">
        <axsl:choose>
	    <axsl:when test="@OBJID or mets:metsHdr/mets:altRecordID"/>
            <axsl:otherwise>
                <xsl:element name="mets-001"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="@PROFILE"/>
            <axsl:otherwise>
                <xsl:element name="mets-030"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates mode="M5"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M5"/>
    <axsl:template match="mets:file" priority="4000" mode="M6">
        <axsl:choose>
            <axsl:when test="@ID"/>
            <axsl:otherwise>
                <xsl:element name="file-010"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:if test="@ID=''">
            <xsl:element name="file-011"/>
        </axsl:if>
        <axsl:apply-templates mode="M6"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M6"/>
    <axsl:template match="text()" priority="-1"/>
    <axsl:template match="*|@*" mode="schematron-get-full-path">
        <axsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
        <axsl:text>/</axsl:text>
        <axsl:if test="count(. | ../@*) = count(../@*)">@</axsl:if>
        <axsl:value-of select="name()"/>
        <axsl:text>[</axsl:text>
        <axsl:value-of select="1+count(preceding-sibling::*[name()=name(current())])"/>
        <axsl:text>]</axsl:text>
    </axsl:template>
</axsl:stylesheet>
