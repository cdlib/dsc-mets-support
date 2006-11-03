<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xlink="http://www.w3.org/TR/xlink" xmlns:xsd="http://www.w3.org/2001/XMLSchema"
	xmlns:m="http://www.loc.gov/METS/" xmlns:cdl="http://ark.cdlib.org/schemas/appqualifieddc/"
	xmlns:dcterms="http://purl.org/dc/terms/" xmlns:dc="http://purl.org/dc/elements/1.1/">
	<xsl:strip-space elements="*"/>
	<xsl:output method="xml" indent="no"/>
	<xsl:template match="/">
		<xsl:apply-templates select="m:mets"/>
	</xsl:template>
	<xsl:template match="m:mets">
		<qdc2>
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
			<xsl:call-template name="audience"/>
			<xsl:call-template name="harvestFile"/>
			<xsl:call-template name="accessGroupID"/>
			<!-- xsl:call-template name="accessURL"/ -->
			<xsl:call-template name="collectionID"/>
			<xsl:apply-templates
				select="m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/*[contains(name(),'.')]"
				mode="topel"/>
		</qdc2>
	</xsl:template>
	<xsl:template match="*|node()">
		<v>
			<xsl:value-of select="."/>
		</v>
	</xsl:template>
	<xsl:template match="*" mode="topel">
		<xsl:element name="{local-name()}">
			<xsl:apply-templates/>
		</xsl:element>
	</xsl:template>
	<xsl:template name="title">
		<title>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:title"/>
		</title>
		<title.alternate>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.alternate"/>
		</title.alternate>
	</xsl:template>
	<xsl:template name="creator">
		<creator>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:creator"/>
		</creator>
	</xsl:template>
	<xsl:template name="subject">
		<subject>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:subject"/>
		</subject>
	</xsl:template>
	<xsl:template name="description">
		<description>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:description"/>
		</description>
		<description.abstract>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.abstract"/>
		</description.abstract>
		<description.tableOfContents>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.tableOfContents"
			/>
		</description.tableOfContents>
	</xsl:template>
	<xsl:template name="publisher">
		<publisher>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:publisher"/>
		</publisher>
	</xsl:template>
	<xsl:template name="contributor">
		<contributor>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:contributor"/>
		</contributor>
	</xsl:template>
	<xsl:template name="date">
		<date>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:date"/>
		</date>
		<date.created>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.created"/>
		</date.created>
		<date.dateSubmitted>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.dateSubmitted"
			/>
		</date.dateSubmitted>
		<date.issued>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.issued"/>
		</date.issued>
		<date.modified>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.modified"/>
		</date.modified>
		<date.available>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.available"/>
		</date.available>
		<date.dateAccepted>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.dateAccepted"/>
		</date.dateAccepted>
		<date.dateCopyrighted>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.dateCopyrighted"
			/>
		</date.dateCopyrighted>
		<date.valid>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.valid"/>
		</date.valid>
	</xsl:template>
	<xsl:template name="type">
		<type>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:type"/>
		</type>
	</xsl:template>
	<xsl:template name="format">
		<format>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:format"/>
		</format>
		<format.extent>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.extent"/>
		</format.extent>
		<format.medium>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.medium"/>
		</format.medium>
	</xsl:template>
	<xsl:template name="identifier">
		<identifier>
			<xsl:apply-templates select="/m:mets/@OBJID"/>
		</identifier>
		<identifier>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:identifier"/>
		</identifier>
		<identifier.bibliographicCitation>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.bibliographicCitation"
			/>
		</identifier.bibliographicCitation>
	</xsl:template>
	<xsl:template name="source">
		<source>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:source"/>
		</source>
	</xsl:template>
	<xsl:template name="language">
		<language>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:language"/>
		</language>
	</xsl:template>
	<xsl:template name="relation">
		<relation>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:relation"/>
		</relation>
		<relation.conformsTo>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.conformsTo"/>
		</relation.conformsTo>
		<relation.hasPart>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.hasPart"/>
		</relation.hasPart>
		<relation.hasVersion>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.hasVersion"/>
		</relation.hasVersion>
		<relation.isPartOf>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.isPartOf"/>
		</relation.isPartOf>
		<relation.isReferencedBy>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.isReferencedBy"
			/>
		</relation.isReferencedBy>
		<relation.isRequiredBy>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.isRequiredBy"/>
		</relation.isRequiredBy>
		<relation.isVersionOf>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.isVersionOf"/>
		</relation.isVersionOf>
		<relation.references>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.references"/>
		</relation.references>
		<relation.requires>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.requires"/>
		</relation.requires>
		<relation.hasFormat>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.hasFormat"/>
		</relation.hasFormat>
		<relation.isFormatOf>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.isFormatOf"/>
		</relation.isFormatOf>
		<relation.isReplacedBy>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.isReplacedBy"/>
		</relation.isReplacedBy>
		<relation.replaces>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.replaces"/>
		</relation.replaces>
	</xsl:template>
	<xsl:template name="coverage">
		<coverage>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:coverage"/>
		</coverage>
		<coverage.spatial>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.spatial"/>
		</coverage.spatial>
		<coverage.temporal>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.temporal"/>
		</coverage.temporal>
	</xsl:template>
	<xsl:template name="rights">
		<rights>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:rights"/>
		</rights>
		<rights.accessRights>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.accessRights"/>
		</rights.accessRights>
		<rights.license>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.license"/>
		</rights.license>
	</xsl:template>
	<xsl:template name="audience">
		<audience>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.audience"/>
		</audience>
		<audience.mediator>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.mediator"/>
		</audience.mediator>
		<audience.educationLevel>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/dc:dct.educationLevel"
			/>
		</audience.educationLevel>
	</xsl:template>
	<xsl:template name="harvestFile">
		<cdl.harvestFile>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='admin-dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/cdl:harvestFile"
			/>
		</cdl.harvestFile>
	</xsl:template>
	<xsl:template name="accessGroupID">
		<cdl.accessGroupID>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='admin-dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/cdl:accessGroupID"
			/>
		</cdl.accessGroupID>
	</xsl:template>
	<xsl:template name="accessURL">
		<cdl.accessURL>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/cdl:accessURL"/>
		</cdl.accessURL>
	</xsl:template>
	<xsl:template name="collectionID">
		<cdl.collectionID>
			<xsl:apply-templates
				select="/m:mets/m:dmdSec[@ID='admin-dc']/m:mdWrap/m:xmlData/cdl:qualifieddc/cdl:collectionID"
			/>
		</cdl.collectionID>
	</xsl:template>
</xsl:stylesheet>
