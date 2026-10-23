
<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8" %>
<%@page import="affichage.*"%>
<%@page import="bean.CGenUtil"%>
<%@page import="bean.TypeObjet"%>
<%@page import="utilitaire.Utilitaire"%>
<%@page import="user.UserEJB"%>
<%@ page import="affichage.Champ" %>
<%@ page import="paie.configuration.LogDirection"%>
<%
    try {
         LogDirection a = new LogDirection();
         a.setNomTable("LOG_DIRECTION");
         String titre="Saisie d'une direction";
         if (request.getParameter("acte") != null && request.getParameter("acte").equalsIgnoreCase("update"))
        {
            titre = "Modification de la direction";
        }
         PageInsert pi = new PageInsert(a, request, (user.UserEJB) session.getValue("u"));
         pi.setLien((String) session.getValue("lien"));
         pi.getFormu().getChamp("val").setLibelle("Valeur");
         pi.getFormu().getChamp("desce").setLibelle("Description");

         String classe = "paie.configuration.LogDirection";

         String butApresPost = "paie/configuration/direction-saisie.jsp";
         String nomTable = "LOG_DIRECTION";
         pi.preparerDataFormu();
     %>
     <div class="content-wrapper">
         <h1 align="center"><%=titre %></h1>

         <form action="<%=pi.getLien()%>?but=apresTarif.jsp" method="post"  data-parsley-validate>
             <%
                pi.getFormu().makeHtmlInsertTabIndex();
                out.println(pi.getFormu().getHtmlInsert());
             %>
             <input name="acte" type="hidden" id="nature" value="insert">
             <input name="bute" type="hidden" id="bute" value="<%= butApresPost %>">
             <input name="classe" type="hidden" id="classe" value="<%= classe %>">
             <input name="nomtable" type="hidden" id="nomtable" value="<%= nomTable %>">
         </form>
     </div>
     <%
     }catch (Exception e) {
         e.printStackTrace();

 } %>
