<?xml version="1.0" encoding="utf-8" standalone="yes"?>
<axsl:stylesheet xmlns:axsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:sch="http://www.ascc.net/xml/schematron"
    xmlns:mets="http://www.loc.gov/METS/" xmlns:mods="http://www.loc.gov/mods/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:xlink1="http://www.w3.org/TR/xlink" 
    xmlns:xlink2="http://www.w3.org/1999/xlink"
    version="1.0" mets:dummy-for-xmlns="" mods:dummy-for-xmlns="" rdf:dummy-for-xmlns=""
    xlink1:dummy-for-xmlns="" xlink2:dummy-for-xmlns="" exclude-result-prefixes="rdf sch xlink1 xlink2 mets mods xsl">
    <axsl:output method="xml"/>
    <xsl:template match="/">
        <xsl:call-template name="errors"/>
    </xsl:template>
    <axsl:template name="errors">
        <MetsBestPracticeErrors xsl:exclude-result-prefixes="mets xsl axsl sch mods rdf xlink1 xlink2">
            <axsl:apply-templates select="/" mode="M5"/>
            <axsl:apply-templates select="/" mode="M6"/>
        </MetsBestPracticeErrors>
    </axsl:template>
    <axsl:template match="mets:mets" priority="4000" mode="M5">
        <axsl:if test="@OBJID=''">
            <xsl:element name="mets-002"/>
        </axsl:if>
        <axsl:choose>
            <axsl:when test="contains(@OBJID, 'ark:/13030/')"/>
            <axsl:otherwise>
            <xsl:element name="mets-003"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="@LABEL"/>
            <axsl:otherwise>
            <xsl:element name="mets-010"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:if test="@LABEL=''">
            <xsl:element name="mets-011"/>
        </axsl:if>
        <axsl:choose>
            <axsl:when test="@TYPE"/>
            <axsl:otherwise>
            <xsl:element name="mets-020"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:if test="@TYPE=''">
            <xsl:element name="mets-021"/>
        </axsl:if>
        <axsl:if test="@PROFILE=''">
            <xsl:element name="mets-031"/>
        </axsl:if>
        <axsl:choose>
            <axsl:when test="contains(@PROFILE, 'ark:/13030/')"/>
            <axsl:otherwise>
            <xsl:element name="mets-032"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="contains(@PROFILE, 'http://ark.cdlib.org/ark:/13030/kt400011f8')"/>
            <axsl:otherwise>
                <xsl:element name="profile-001"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates mode="M5"/>
    </axsl:template>
    <axsl:template match="text()" priority="-1" mode="M5"/>
    <axsl:template match="mets:dmdSec[1]" priority="4000" mode="M6">
        <axsl:choose>
            <axsl:when test="/mets:mets/mets:dmdSec[1]/@ID='mods'"/>
            <axsl:otherwise>
                <xsl:element name="dmd-005"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="(/mets:mets/mets:dmdSec[@ID='mods']/mets:mdWrap[@OTHERMDTYPE='MODS']) and (/mets:mets/mets:dmdSec[@ID='mods']/mets:mdWrap[@MDTYPE='OTHER'])"/>
            <axsl:otherwise>
                <xsl:element name="dmd-006"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates mode="M6"/>
    </axsl:template>
    <axsl:template match="mets:file" priority="4000" mode="M6">
        <axsl:choose>
            <axsl:when test="mets:FLocat"/>
            <axsl:otherwise>
            <xsl:element name="file-020"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="mets:FLocat/@xlink1:href"/>
            <axsl:otherwise>
                <axsl:choose>
                    <axsl:when test="mets:FLocat/@xlink2:href"/>
                    <axsl:otherwise>
                        <xsl:element name="file-021"/>
                    </axsl:otherwise>
                </axsl:choose>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="mets:FLocat/@xlink1:href=''">
                <xsl:element name="file-022"/>
            </axsl:when>
            <axsl:when test="mets:FLocat/@xlink2:href=''">
                <xsl:element name="file-022"/>
            </axsl:when>
            <axsl:otherwise/>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="@USE">
                <axsl:choose>
                    <axsl:when test="@USE = ''">
                        <xsl:element name="file-002"/>
                    </axsl:when>
                </axsl:choose>
            </axsl:when>
            <axsl:otherwise>
                <axsl:choose>
                    <axsl:when test="ancestor::mets:fileGrp/@USE">
                        <axsl:choose>
                            <axsl:when test="ancestor::mets:fileGrp/@USE = ''">
                                <xsl:element name="file-002"/>
                            </axsl:when>
                        </axsl:choose>
                    </axsl:when>
                    <axsl:otherwise>
                        <xsl:element name="file-001"/>
                    </axsl:otherwise>
                </axsl:choose>
            </axsl:otherwise>
        </axsl:choose>
    </axsl:template>
    <axsl:template match="mets:dmdSec[2]" priority="3999" mode="M6">
        <axsl:choose>
            <axsl:when test="/mets:mets/mets:dmdSec[2]/@ID='ead'"/>
            <axsl:otherwise>
                <xsl:element name="dmd-010"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="/mets:mets/mets:dmdSec[@ID='ead']/mets:mdRef[@MDTYPE='EAD']"/>
            <axsl:otherwise>
                <xsl:element name="dmd-011"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:apply-templates mode="M6"/>
    </axsl:template>
    <axsl:template match="mets:dmdSec[3]" priority="3998" mode="M6">
        <axsl:choose>
            <axsl:when test="/mets:mets/mets:dmdSec[3]/@ID='repo'"/>
            <axsl:otherwise>
                <xsl:element name="dmd-020"/>
            </axsl:otherwise>
        </axsl:choose>
        <axsl:choose>
            <axsl:when test="/mets:mets/mets:dmdSec[@ID='repo']/mets:mdWrap[@MDTYPE='DC']"/>
            <axsl:otherwise>
                <xsl:element name="dmd-021"/>
            </axsl:otherwise>
        </axsl:choose>
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
