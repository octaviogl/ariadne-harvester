<%@ page language="java"
	import="java.util.HashMap, java.io.IOException"%>
<%@page import="org.ariadne.util.OaiUtils"%>
<%@page import="java.util.Calendar"%>
<%@page import="org.quartz.SimpleTrigger"%>
<%@page import="java.util.GregorianCalendar"%>
<%@page import="org.ariadne.oai.config.servlet.cron.InitCronServlet"%>
<%@page import="org.quartz.Scheduler"%>
<%@page import="org.quartz.ObjectAlreadyExistsException"%>

<%@page import="org.quartz.JobDataMap"%>
<%@page import="java.util.Vector"%>
<%@page import="org.ariadne.oai.utils.HarvesterUtils"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="org.ariadne.oai.config.servlet.cron.SingleHarvestingJob"%><html>

<head>
<title>Harvesting from Targets</title>
<%@ include file="index.jsp"%>
<%!
void printHarvestedService(JspWriter out, HashMap<String,String> repos, Calendar untilDate, String status) throws IOException {

	String identName = repos.get("Identifier");
	String name = identName.replaceAll("_"," ");
	String from = repos.get("latestHarvestedDatestamp");
	String baseUrl = repos.get("baseURL");
	String metaDataPrefix = repos.get("metadataPrefix");
	String until = OaiUtils.calcUntil(untilDate,repos.get("granularity"));
	
	     out.println("<table class=\"adminlist\">");
//	      out.println("<td align=\"center\" class=\"user\" valign=\"middle\" width=\"64\">");
//	      out.println("<br>");
	      out.println("<td align=\"left\" class=\"sectionname\" valign=\"middle\">" + name +  "</td>");
	     out.println("</table>");
	     out.println("<table class=\"adminlist\">");
	      out.println("<tr>");
	       out.println("<th class=\"title\">Target Name</th>");
	       out.println("<td class=\"content\">" + name + "</td>");
	      out.println("</tr>");
	      out.println("<tr>");
	       out.println("<th class=\"title\">Base URL</th>");
	       out.println("<td class=\"content\">" + baseUrl + "</td>");
	      out.println("</tr>");
	      out.println("<tr>");
	       out.println("<th class=\"title\">From Date</th>");
	       out.println("<td class=\"content\">" + from + "</td>");
	      out.println("</tr>");
	      out.println("<tr>");
	       out.println("<th class=\"title\">Until Date</th>");
	       out.println("<td class=\"content\">" + until + "</td>");
	      out.println("</tr>");
	      out.println("<tr>");
	       out.println("<th class=\"title\">MetadataPrefix</th>");
	       out.println("<td class=\"content\">" + metaDataPrefix + "</td>");
	      out.println("</tr>");
	      out.println("<tr>");
	       out.println("<th class=\"title\">Status</th>");
	       out.println("<td class=\"content\">" + status + "</td>");
	      out.println("</tr>");
	      
	     out.println("</table>");

}

%>
<%
try{
	Vector<String> reposInternalIds = HarvesterUtils.getReposList();
	SingleHarvestingJob.triggerHarvesting("ManualHarvesting", "ManualHarvestingJob","manualAll",reposInternalIds);
	pageContext.forward("viewHistory.jsp" );
}
catch(ObjectAlreadyExistsException e){
	out.println("<br/>");
	out.println("<h3>Harvesting already started, please check the <a href=\"../start/viewHistory.jsp\">History</a> for progress</h3>");
	out.println("<br/>");
}
%>

</body>
</html>
