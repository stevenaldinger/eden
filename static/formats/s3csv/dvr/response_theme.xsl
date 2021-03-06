<?xml version="1.0" encoding="utf-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

    <!-- **********************************************************************
         DVR Response Themes - CSV Import Stylesheet

         CSV column..................Format..........Content

         Organisation................string..........Organisation Name
         Branch.........................optional.....Organisation Branch Name
         ...SubBranch,SubSubBranch...etc (indefinite depth, must specify all from root)

         Theme.......................string..........Theme Name
         Comments....................string..........Comments

    *********************************************************************** -->

    <xsl:import href="../orgh.xsl"/>

    <xsl:output method="xml"/>

    <!-- ****************************************************************** -->
    <xsl:template match="/">

        <s3xml>

            <!-- Import the organisation hierarchy -->
            <xsl:for-each select="table/row[1]">
                <xsl:call-template name="OrganisationHierarchy">
                    <xsl:with-param name="level">Organisation</xsl:with-param>
                    <xsl:with-param name="rows" select="//table/row"/>
                </xsl:call-template>
            </xsl:for-each>

            <!-- Process all rows for response themes -->
            <xsl:apply-templates select="table/row"/>

        </s3xml>
    </xsl:template>

    <!-- ****************************************************************** -->
    <!-- Response Themes -->
    <xsl:template match="row">

        <xsl:variable name="Name" select="col[@field='Theme']"/>
        <xsl:if test="$Name!=''">

            <resource name="dvr_response_theme">

                <!-- Name -->
                <data field="name">
                    <xsl:value-of select="$Name"/>
                </data>

                <!-- Link to Organisation -->
                <reference field="organisation_id" resource="org_organisation">
                    <xsl:attribute name="tuid">
                        <xsl:call-template name="OrganisationID"/>
                    </xsl:attribute>
                </reference>

                <!-- Comments -->
                <data field="comments">
                    <xsl:value-of select="col[@field='comments']"/>
                </data>

            </resource>
        </xsl:if>
    </xsl:template>

    <!-- END ************************************************************** -->

</xsl:stylesheet>
